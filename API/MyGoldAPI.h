#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyGoldAPI : NSObject

@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *keyExpiry;
@property (nonatomic, strong) NSString *keyVersion;
@property (nonatomic, strong) NSString *packagerStatus;

+ (instancetype)sharedInstance;
- (NSString *)getHWID;
- (void)doLoginWithKey:(NSString *)key completion:(void (^)(BOOL success, NSString *message))completion;

@end
