# Build e Instalação Mobile - ClickforShine

## 🚀 Instalação Automática

### Android (Windows/macOS/Linux)

#### Opção 1: Script Automático (Recomendado)

**Windows:**
```bash
# Duplo-clique em:
build_and_install_android.bat

# Ou execute:
build_and_install_android.bat
```

**macOS/Linux:**
```bash
chmod +x build_and_install_android.sh
./build_and_install_android.sh
```

#### Opção 2: Manual

```bash
# 1. Conectar dispositivo via USB
# 2. Habilitar "Depuração USB" em Configurações > Desenvolvedor

# 3. Compilar e instalar
flutter run --release

# Ou compilar APK
flutter build apk --release

# Depois instalar
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### iOS (macOS apenas)

#### Opção 1: Script Automático (Recomendado)

```bash
chmod +x build_and_install_ios.sh
./build_and_install_ios.sh
```

#### Opção 2: Manual

```bash
# 1. Conectar iPhone/iPad via USB
# 2. Confiar no computador no dispositivo

# 3. Compilar e instalar
flutter run --release

# Ou compilar IPA
flutter build ipa --release

# Depois instalar com Xcode
open -a Xcode build/ios/Runner.xcworkspace
```

## 📋 Pré-requisitos

### Android

- ✅ Flutter instalado
- ✅ Android SDK instalado
- ✅ Android Debug Bridge (adb)
- ✅ Dispositivo Android com USB Debug habilitado

**Verificar:**
```bash
flutter doctor
adb devices
```

### iOS

- ✅ macOS
- ✅ Flutter instalado
- ✅ Xcode instalado
- ✅ CocoaPods instalado
- ✅ iPhone/iPad com iOS 12+

**Verificar:**
```bash
flutter doctor
xcode-select --version
pod --version
```

## 🔧 Configuração Pré-Build

### 1. Configurar Firebase

```bash
flutterfire configure
```

### 2. Configurar Chaves de API

Edite `.env`:
```env
AZURE_VISION_KEY=your_key
OPENAI_API_KEY=sk-your_key
GOOGLE_CLOUD_API_KEY=your_key
FIREBASE_API_KEY=your_key
```

### 3. Atualizar App Name (Opcional)

Edite `app.config.ts`:
```dart
const env = {
  appName: "ClickforShine",
  appSlug: "clickforshine",
  // ...
};
```

## 📱 Processo de Build

### Android - Passo a Passo

```bash
# 1. Limpar build anterior
flutter clean

# 2. Obter dependências
flutter pub get

# 3. Compilar APK
flutter build apk --release

# Arquivo gerado:
# build/app/outputs/flutter-apk/app-release.apk
```

**Tamanho esperado:** ~50-100 MB

### iOS - Passo a Passo

```bash
# 1. Limpar build anterior
flutter clean

# 2. Obter dependências
flutter pub get

# 3. Instalar pods
cd ios
pod install --repo-update
cd ..

# 4. Compilar IPA
flutter build ipa --release

# Arquivo gerado:
# build/ios/ipa/clickforshine.ipa
```

**Tamanho esperado:** ~80-150 MB

## 🔐 Assinatura de Código

### Android

O build automático usa a keystore padrão. Para usar sua própria:

```bash
# 1. Criar keystore
keytool -genkey -v -keystore ~/my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias

# 2. Configurar em android/key.properties
storeFile=/Users/username/my-release-key.jks
storePassword=password
keyPassword=password
keyAlias=my-key-alias

# 3. Build
flutter build apk --release
```

### iOS

Requer conta de desenvolvedor Apple:

1. Abrir Xcode
2. Ir para: Product > Scheme > Edit Scheme
3. Selecionar "Release"
4. Ir para: Product > Build
5. Depois: Product > Archive

## 📦 Distribuição

### Google Play Store

```bash
# 1. Compilar APK
flutter build apk --release

# 2. Ou compilar App Bundle (recomendado)
flutter build appbundle --release

# Arquivo: build/app/outputs/bundle/release/app-release.aab

# 3. Fazer upload em:
# https://play.google.com/console
```

### Apple App Store

```bash
# 1. Compilar IPA
flutter build ipa --release

# 2. Fazer upload com Xcode ou Transporter
# https://appstoreconnect.apple.com
```

## 🐛 Troubleshooting

### "Dispositivo não encontrado"

```bash
# Android
adb devices
adb kill-server
adb start-server

# iOS
xcrun xdevice list
```

### "Erro de assinatura"

```bash
# Android
flutter build apk --release --verbose

# iOS
flutter build ipa --release --verbose
```

### "Erro de dependências"

```bash
flutter pub get
flutter pub upgrade
```

### "Erro de build"

```bash
flutter clean
flutter pub get
flutter build apk --release --verbose
```

## 📊 Otimizações

### Reduzir tamanho do APK

```bash
# Build com split por ABI
flutter build apk --release --split-per-abi

# Gera:
# - app-armeabi-v7a-release.apk (~30 MB)
# - app-arm64-v8a-release.apk (~35 MB)
# - app-x86_64-release.apk (~35 MB)
```

### Reduzir tamanho do IPA

```bash
# Build com bitcode
flutter build ipa --release --export-method ad-hoc
```

## ✅ Checklist Pré-Deploy

- [ ] Firebase configurado
- [ ] Chaves de API configuradas em .env
- [ ] App name atualizado
- [ ] Ícone do app definido
- [ ] Splash screen configurada
- [ ] Versão do app atualizada (pubspec.yaml)
- [ ] Build testado no dispositivo
- [ ] Testes unitários passando
- [ ] Sem erros de análise (flutter analyze)

## 📚 Referências

- [Flutter Build Documentation](https://flutter.dev/docs/deployment)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)
- [iOS App Distribution](https://developer.apple.com/app-store/)
- [Firebase Setup](https://firebase.flutter.dev/docs/overview)

## 🆘 Suporte

Para problemas específicos:

1. Executar com verbose:
   ```bash
   flutter build apk --release --verbose
   ```

2. Verificar logs:
   ```bash
   flutter doctor -v
   ```

3. Limpar cache:
   ```bash
   flutter clean
   rm -rf pubspec.lock
   flutter pub get
   ```

---

**Pronto para distribuir seu app! 🚀**
