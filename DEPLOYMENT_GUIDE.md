# Guia de Deployment - ClickforShine Flutter

## 📋 Checklist Pré-Deployment

- [ ] Atualizar `firebase_options.dart` com credenciais reais
- [ ] Configurar Firestore Security Rules
- [ ] Testar em dispositivo físico (iOS e Android)
- [ ] Executar `flutter test` com sucesso
- [ ] Atualizar versão em `pubspec.yaml`
- [ ] Gerar screenshots para lojas
- [ ] Preparar descrição da app

## 🔐 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura pública de compostos e pads
    match /compounds/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null && request.auth.token.admin == true;
    }
    
    match /pads/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null && request.auth.token.admin == true;
    }
    
    // Diagnósticos privados do usuário
    match /diagnostics/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Admin Panel
    match /admin/{document=**} {
      allow read, write: if request.auth.token.admin == true;
    }
  }
}
```

## 🚀 Android - Google Play

### 1. Preparar Keystore

```bash
# Gerar keystore (execute uma única vez)
keytool -genkey -v -keystore ~/clickforshine-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias clickforshine

# Salvar informações em local seguro!
```

### 2. Configurar Gradle

Editar `android/app/build.gradle`:

```gradle
android {
  signingConfigs {
    release {
      keyAlias 'clickforshine'
      keyPassword 'SUA_SENHA'
      storeFile file('/path/to/clickforshine-key.jks')
      storePassword 'SUA_SENHA'
    }
  }
  
  buildTypes {
    release {
      signingConfig signingConfigs.release
    }
  }
}
```

### 3. Build AAB

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### 4. Upload no Google Play Console

1. Acesse [Google Play Console](https://play.google.com/console)
2. Crie nova app: "ClickforShine"
3. Vá para "Release" → "Production"
4. Upload do `app-release.aab`
5. Preencha descrição, screenshots, etc.
6. Submeta para review

**Tempo de aprovação**: 2-4 horas

## 🍎 iOS - App Store

### 1. Configurar Certificados

```bash
# Abrir Xcode para gerenciar certificados
open ios/Runner.xcworkspace
```

1. Selecione "Runner" no Project Navigator
2. Vá para "Signing & Capabilities"
3. Configure Team ID e Bundle Identifier
4. Crie certificado de distribuição

### 2. Build IPA

```bash
flutter build ipa --release
# Output: build/ios/ipa/Runner.ipa
```

### 3. Upload via Transporter

```bash
# Abrir Transporter
open /Applications/Transporter.app

# Ou via CLI
xcrun altool --upload-app -f build/ios/ipa/Runner.ipa \
  -t ios -u seu_email@apple.com -p sua_senha_app
```

### 4. App Store Connect

1. Acesse [App Store Connect](https://appstoreconnect.apple.com)
2. Crie nova app: "ClickforShine"
3. Preencha informações:
   - Descrição
   - Screenshots (5 mínimo)
   - Palavras-chave
   - Categoria
   - Classificação etária
4. Selecione build e submeta para review

**Tempo de aprovação**: 24-48 horas

## 🌐 Web - Firebase Hosting (Admin Panel)

### 1. Build Web

```bash
flutter build web --release
# Output: build/web/
```

### 2. Deploy Firebase

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Deploy
firebase deploy --only hosting
```

### 3. Configurar Custom Domain

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Vá para Hosting
3. Clique em "Conectar domínio"
4. Siga as instruções de DNS

**URL final**: `https://admin.clickforshine.com`

## 📊 Monitoramento Pós-Deploy

### Firebase Console

- Ative Google Analytics
- Configure Crashlytics
- Monitore Performance

```dart
// lib/main.dart
await FirebaseCrashlytics.instance.recordFlutterError(details);
```

### Google Play Console

- Monitore reviews
- Verifique crash reports
- Analise métricas de uso

## 🔄 Atualização de Versão

### Incrementar Versão

```bash
# Editar pubspec.yaml
version: 1.0.1+2

# Rebuild
flutter pub get
flutter build appbundle --release
```

### Rollout Gradual (Google Play)

1. Vá para "Release" → "Production"
2. Crie novo release
3. Configure rollout: 10% → 50% → 100%
4. Monitore crash reports em cada etapa

## 🛠️ Troubleshooting

### iOS Build Fails

```bash
# Limpar build
flutter clean
cd ios && rm -rf Pods Podfile.lock && cd ..

# Reinstalar
flutter pub get
flutter build ios --release
```

### Android Build Fails

```bash
# Limpar build
flutter clean
rm -rf android/.gradle

# Rebuild
flutter build appbundle --release
```

### Firebase Connection Issues

```bash
# Verificar configuração
flutterfire configure

# Testar conexão
firebase emulators:start
```

## 📝 Changelog

```markdown
# v1.0.1 (2024-01-20)

## Novo
- Suporte para Gel Coat Náutico
- Gráfico de dureza interativo

## Corrigido
- Bug na câmera em Android 14
- Crash ao salvar diagnóstico

## Melhorado
- Performance do algoritmo SmartShine
- UI do Admin Panel
```

## 🔗 Recursos

- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)
- [Google Play Console](https://support.google.com/googleplay/android-developer)
- [App Store Connect](https://help.apple.com/app-store-connect/)

---

**Última atualização**: Janeiro 2024
