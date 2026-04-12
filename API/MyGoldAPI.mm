#import "MyGoldAPI.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@implementation MyGoldAPI

+ (instancetype)sharedInstance {
    static MyGoldAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.keyName = @"Desconhecido";
        sharedInstance.keyExpiry = @"0";
        sharedInstance.keyVersion = @"1.0";
        sharedInstance.packagerStatus = @"OFFLINE";
    });
    return sharedInstance;
}

- (NSString *)getHWID {
    NSString *identifierForVendor = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *combined = [NSString stringWithFormat:@"%@%@", identifierForVendor, deviceModel];
    const char *cStr = [combined UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (void)doLoginWithKey:(NSString *)key completion:(void (^)(BOOL success, NSString *message))completion {
    NSString *apiUrl = @"https://mygold.squareweb.app/api/public/verify";
    NSString *packageId = @"ec0c";
    NSString *packageToken = @"9809435213503eb65d6059f722f3e53e040e8680d7ec92976d358f1be6b27fbe";
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *hwid = [self getHWID];
    
    NSDictionary *jsonDict = @{
        @"key": key,
        @"hwid": hwid,
        @"device_model": deviceModel
    };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:packageId forHTTPHeaderField:@"X-Package-ID"];
    [request setValue:packageToken forHTTPHeaderField:@"X-Package-Token"];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, error.localizedDescription);
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (responseDict && [responseDict[@"success"] boolValue]) {
            self.keyName = responseDict[@"name"] ?: @"Desconhecido";
            self.keyVersion = responseDict[@"version"] ?: @"1.0";
            self.keyExpiry = [NSString stringWithFormat:@"%@", responseDict[@"days_left"] ?: @"0"];
            NSString *packager = responseDict[@"packager"];
            self.packagerStatus = (packager && packager.length > 0) ? [packager uppercaseString] : @"ONLINE";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES, nil);
            });
        } else {
            NSString *errorMessage = responseDict[@"error"] ?: @"Erro desconhecido";
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, errorMessage);
            });
        }
    }];
    [task resume];
}

@end
