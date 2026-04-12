# Snowz Panel - MyGold Integration

## O que foi adicionado

### 1. MyGoldAPI Integration
- Arquivo: `API/MyGoldAPI.mm` e `API/MyGoldAPI.h`
- Funcionalidade: Gerenciamento de licenças e autenticação
- Token: `9809435213503eb65d6059f722f3e53e040e8680d7ec92976d358f1be6b27fbe`
- PackID: `ec0c`

### 2. Tela de Login MyGold
- Botão "Login" / "Logout" na aba Profile
- UIAlertController para inserir chave de licença
- Validação automática de login
- Suporte a português e inglês

### 3. Exibição de Dados do Perfil
- HWID do dispositivo (copiável)
- Status de autorização (verde/vermelho)
- Developer: snowzdev
- Tempo restante em dias
- Nome do usuário/chave
- API Key mascarada

## Como Compilar

### Requisitos
- Mac com Xcode instalado OU
- Linux com Theos + SDK iOS 16.5 + ld64 funcional

### Compilação em Mac (Recomendado)
```bash
cd sourcegay_working
make clean
make package ARCHS=arm64 SDKVERSION=16.5
```

A dylib compilada estará em: `.theos/obj/arm64/ffz.dylib`

### Compilação em Linux
⚠️ **Problema conhecido**: O Theos em Linux não possui um linker iOS ARM64 funcional. A compilação completa não é possível em Linux sem um ld64 pré-compilado específico.

## Arquivos Incluídos

- `sourcegay_working/` - Source completa com todas as alterações
- `ffz_compiled.dylib` - Dylib compilada (versão anterior, sem as novas alterações)
- `Makefile` - Configurado para compilar MyGoldAPI.mm
- `Draw.mm` - Atualizado com tela de login e exibição de dados

## Alterações no Código

### Draw.mm
- Adicionado método `showMyGoldLoginAlert` para gerenciar login/logout
- Adicionado botão de login na seção de Profile
- Exibição de dados do MyGoldAPI

### Hidestream/Stream.mm
- Adicionado include `<iomanip>` para corrigir erro de compilação

### Makefile
- Adicionado `API/MyGoldAPI.mm` à lista de arquivos a compilar

## Próximos Passos

1. Compile em um Mac com Xcode
2. Teste a tela de login com uma chave de licença válida
3. Verifique se os dados do perfil são exibidos corretamente
4. Distribua a dylib compilada

## Suporte

Para problemas de compilação em Linux, você precisará:
- De um Mac com Xcode, OU
- De um servidor macOS na nuvem (AWS EC2 Mac, etc.), OU
- De um ld64 pré-compilado funcional para Linux

