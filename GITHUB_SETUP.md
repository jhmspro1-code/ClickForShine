# GitHub Setup - ClickforShine Flutter

## 🚀 Configuração Completa do Repositório

### Passo 1: Criar Repositório no GitHub

1. Acesse [GitHub.com](https://github.com)
2. Clique em **"New"** (novo repositório)
3. Preencha:
   - **Repository name**: `clickforshine-flutter`
   - **Description**: `ClickforShine - Plataforma de Diagnóstico de Polimento`
   - **Visibility**: Public (ou Private se preferir)
   - **Initialize with**: Deixe em branco
4. Clique em **"Create repository"**

### Passo 2: Clonar o Repositório Localmente

```bash
# Clone o repositório vazio
git clone https://github.com/seu-usuario/clickforshine-flutter.git
cd clickforshine-flutter

# Ou se já tem o código local:
cd /caminho/para/clickforshine_flutter
git init
git remote add origin https://github.com/seu-usuario/clickforshine-flutter.git
```

### Passo 3: Fazer Push do Código

```bash
# Adicionar todos os arquivos
git add .

# Fazer commit inicial
git commit -m "Initial commit: ClickforShine Flutter with Clean Architecture"

# Fazer push para main
git branch -M main
git push -u origin main
```

### Passo 4: Configurar Secrets do GitHub

O GitHub Actions precisa de chaves para compilar. Vá para:

**Repositório → Settings → Secrets and variables → Actions**

Clique em **"New repository secret"** e adicione:

#### 1. Firebase Secrets

```
FIREBASE_API_KEY
FIREBASE_PROJECT_ID
FIREBASE_APP_ID
```

#### 2. Azure Vision Secrets

```
AZURE_VISION_KEY
AZURE_VISION_ENDPOINT
AZURE_VISION_REGION
```

#### 3. OpenAI Secrets

```
OPENAI_API_KEY
```

#### 4. Google Cloud Secrets

```
GOOGLE_CLOUD_API_KEY
GOOGLE_CLOUD_PROJECT_ID
```

#### 5. Chaves de Assinatura Android

```
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
```

**Como gerar ANDROID_KEYSTORE_BASE64:**

```bash
# 1. Criar keystore (se não tiver)
keytool -genkey -v -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias

# 2. Converter para base64
base64 my-release-key.jks > keystore-base64.txt

# 3. Copiar conteúdo para ANDROID_KEYSTORE_BASE64
```

#### 6. Certificado iOS (Opcional)

```
IOS_CERTIFICATE_BASE64
IOS_CERTIFICATE_PASSWORD
IOS_PROVISIONING_PROFILE_BASE64
```

### Passo 5: Verificar Workflow

1. Vá para **Actions** no seu repositório
2. Você verá "Build ClickforShine APK & IPA"
3. Clique para ver o progresso

### Passo 6: Fazer um Push de Teste

```bash
# Fazer uma pequena mudança
echo "# ClickforShine" > README.md

# Commit e push
git add README.md
git commit -m "Update README"
git push origin main
```

O workflow deve iniciar automaticamente!

## 📊 Entender o Workflow

### O que o `.github/workflows/build.yml` faz:

1. **Build Android**
   - Compila APK em release
   - Gera versões split por ABI (armeabi-v7a, arm64-v8a, x86_64)
   - Salva artefatos por 30 dias

2. **Build iOS**
   - Compila IPA em release
   - Salva artefatos por 30 dias

3. **Build Web**
   - Compila versão web
   - Faz deploy automático no GitHub Pages

4. **Notificação**
   - Mostra status de todos os builds

## 🏷️ Criar Releases

Para gerar APK/IPA automaticamente:

```bash
# Criar tag (versão)
git tag -a v1.0.0 -m "Release v1.0.0"

# Fazer push da tag
git push origin v1.0.0
```

O workflow vai:
1. Compilar APK e IPA
2. Criar Release no GitHub
3. Fazer upload dos arquivos

## 📥 Baixar APK/IPA

### Opção 1: Do Workflow

1. Vá para **Actions**
2. Clique no workflow mais recente
3. Clique em **"android-apk"** ou **"ios-ipa"**
4. Baixe o arquivo

### Opção 2: Do Release

1. Vá para **Releases**
2. Clique na versão
3. Baixe os arquivos

## 🔄 Workflow Automático

Toda vez que você faz push:

```
git push origin main
    ↓
GitHub Actions detecta
    ↓
Executa build.yml
    ↓
Compila Android, iOS e Web
    ↓
Salva artefatos
    ↓
Se for tag: cria Release
```

## 🐛 Troubleshooting

### Build falha

1. Verificar logs no GitHub Actions
2. Clicar em **"Run"** para ver detalhes
3. Procurar por erros

### Secrets não funcionam

1. Verificar se foram adicionados corretamente
2. Verificar nome exato (case-sensitive)
3. Fazer novo push para testar

### APK não aparece

1. Verificar se build completou com sucesso
2. Ir para **Actions → Workflow → Artifacts**
3. Baixar manualmente

## 📱 Instalar APK do GitHub

### Android

1. Baixar APK do GitHub Actions ou Release
2. Transferir para celular
3. Abrir arquivo
4. Instalar

**Ou via ADB:**

```bash
adb install app-release.apk
```

## 🚀 Próximos Passos

1. **Configurar CD/CD Avançado**
   - Deploy automático para Play Store
   - Deploy automático para App Store

2. **Adicionar Testes**
   - Testes unitários
   - Testes de integração
   - Testes de widget

3. **Adicionar Análise de Código**
   - SonarQube
   - CodeClimate
   - Codecov

## 📚 Referências

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD](https://flutter.dev/docs/deployment/cd)
- [Subosito Flutter Action](https://github.com/subosito/flutter-action)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)

## 💡 Dicas

### Acelerar Builds

```yaml
# No build.yml, adicione cache:
- uses: actions/setup-java@v3
  with:
    cache: gradle  # Cache do Gradle
    
- uses: subosito/flutter-action@v2
  with:
    cache: true  # Cache do Flutter
```

### Notificações

Adicione ao workflow para notificações:

```yaml
- name: 📧 Notify on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
    text: 'Build failed!'
```

### Versioning Automático

```yaml
- name: 🏷️ Bump version
  uses: anothrNick/github-tag-action@1.36.0
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

**Seu repositório está pronto para automação profissional! 🎉**
