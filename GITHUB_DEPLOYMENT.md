# GitHub Deployment - ClickforShine Flutter

## 🚀 Guia Completo de Deploy com GitHub Actions

Este guia mostra como fazer upload do ClickforShine para GitHub e configurar compilação automática.

## 📋 Pré-requisitos

- ✅ Conta GitHub (gratuita em [github.com](https://github.com))
- ✅ Git instalado no seu computador
- ✅ Arquivo `clickforshine_flutter_github_ready.zip` descompactado

## 🔧 Passo 1: Criar Repositório no GitHub

### 1.1 Acessar GitHub

1. Vá para [github.com](https://github.com)
2. Faça login (ou crie conta)
3. Clique em **"+"** (canto superior direito)
4. Selecione **"New repository"**

### 1.2 Configurar Repositório

Preencha:
- **Repository name**: `clickforshine-flutter`
- **Description**: `ClickforShine - Plataforma de Diagnóstico de Polimento`
- **Visibility**: Public (recomendado) ou Private
- **Initialize this repository with**: Deixe em branco

Clique em **"Create repository"**

## 📥 Passo 2: Fazer Upload do Código

### 2.1 Abrir Terminal/Prompt

```bash
# Windows: Abra PowerShell ou CMD
# macOS/Linux: Abra Terminal
```

### 2.2 Navegar até a Pasta

```bash
cd /caminho/para/clickforshine_flutter
```

### 2.3 Inicializar Git

```bash
git init
git add .
git commit -m "Initial commit: ClickforShine Flutter with GitHub Actions"
```

### 2.4 Conectar ao GitHub

```bash
# Substituir seu-usuario pelo seu usuário GitHub
git remote add origin https://github.com/seu-usuario/clickforshine-flutter.git
git branch -M main
git push -u origin main
```

**Será pedido seu usuário e senha do GitHub**

## 🔐 Passo 3: Configurar Secrets

O GitHub Actions precisa de suas chaves de API para compilar. Siga:

### 3.1 Acessar Secrets

1. Vá para seu repositório no GitHub
2. Clique em **"Settings"** (engrenagem)
3. Na esquerda, clique em **"Secrets and variables"**
4. Clique em **"Actions"**

### 3.2 Adicionar Secrets

Clique em **"New repository secret"** para cada chave:

#### Chaves Obrigatórias

```
FIREBASE_API_KEY=your_key_here
FIREBASE_PROJECT_ID=your_project_id
AZURE_VISION_KEY=your_key_here
OPENAI_API_KEY=sk-your_key_here
GOOGLE_CLOUD_API_KEY=your_key_here
```

#### Chaves para Android (Opcional)

```
ANDROID_KEYSTORE_BASE64=base64_encoded_keystore
ANDROID_KEYSTORE_PASSWORD=your_password
ANDROID_KEY_ALIAS=your_alias
ANDROID_KEY_PASSWORD=your_key_password
```

**Como gerar ANDROID_KEYSTORE_BASE64:**

```bash
# 1. Se não tiver keystore, criar:
keytool -genkey -v -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias

# 2. Converter para base64:
# Windows (PowerShell):
[Convert]::ToBase64String([IO.File]::ReadAllBytes("my-release-key.jks")) | clip

# macOS/Linux:
base64 my-release-key.jks | pbcopy
```

## ✅ Passo 4: Verificar Workflow

### 4.1 Acessar Actions

1. Vá para seu repositório
2. Clique em **"Actions"** (abas superiores)
3. Você verá **"Build ClickforShine APK & IPA"**

### 4.2 Fazer Push de Teste

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

O arquivo `.github/workflows/build.yml` faz:

1. **Ao fazer push**:
   - Compila APK para Android
   - Compila IPA para iOS
   - Compila versão Web
   - Salva os arquivos por 30 dias

2. **Ao criar tag (versão)**:
   - Cria Release no GitHub
   - Faz upload dos arquivos

## 🏷️ Criar Release (Versão)

Para gerar APK/IPA com versão:

```bash
# Criar tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Fazer push
git push origin v1.0.0
```

O GitHub Actions vai:
1. Compilar APK e IPA
2. Criar Release
3. Fazer upload dos arquivos

## 📥 Baixar APK/IPA

### Opção 1: Do Workflow (Últimos 30 dias)

1. Vá para **"Actions"**
2. Clique no workflow mais recente
3. Clique em **"android-apk"** para baixar APK
4. Clique em **"ios-ipa"** para baixar IPA

### Opção 2: Do Release (Permanente)

1. Vá para **"Releases"** (lado direito)
2. Clique na versão (ex: v1.0.0)
3. Baixe os arquivos

## 🔄 Fluxo Automático

```
Você faz: git push
    ↓
GitHub detecta mudança
    ↓
Executa .github/workflows/build.yml
    ↓
Compila Android, iOS, Web
    ↓
Salva artefatos (30 dias)
    ↓
Se for tag: cria Release (permanente)
```

## 📱 Instalar APK no Celular

### Opção 1: Download Direto

1. Baixar APK do GitHub
2. Transferir para celular
3. Abrir arquivo
4. Instalar

### Opção 2: Via ADB

```bash
# Conectar celular via USB
adb install app-release.apk
```

## 🐛 Troubleshooting

### Build falha

1. Ir para **"Actions"**
2. Clicar no workflow que falhou
3. Ver logs detalhados
4. Procurar por erros

### Secrets não funcionam

1. Verificar se foram adicionados em **Settings → Secrets**
2. Verificar nome exato (case-sensitive)
3. Fazer novo push para testar

### APK não aparece

1. Verificar se build completou com sucesso
2. Ir para **Actions → Workflow → Artifacts**
3. Baixar manualmente

## 📚 Próximos Passos

### 1. Adicionar Mais Colaboradores

1. Vá para **Settings → Collaborators**
2. Clique em **"Add people"**
3. Digite email

### 2. Configurar Branch Protection

1. Vá para **Settings → Branches**
2. Clique em **"Add rule"**
3. Exigir pull requests antes de merge

### 3. Adicionar Testes Automáticos

```yaml
# No build.yml, já temos:
- name: 🧪 Run tests
  run: flutter test
```

### 4. Deploy Automático para Play Store

```yaml
# Adicionar ao build.yml:
- name: 📤 Deploy to Play Store
  uses: r0adkll/upload-google-play@v1
  with:
    serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_SERVICE_ACCOUNT }}
    packageName: com.clickforshine.app
    releaseFiles: build/app/outputs/bundle/release/app-release.aab
    track: internal
```

## 💡 Dicas Profissionais

### Versionamento Automático

```bash
# Criar versão automaticamente
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

### Commits Significativos

```bash
# Bom:
git commit -m "feat: Add Expert Shine Chat module"
git commit -m "fix: Resolve Azure Vision API timeout"

# Ruim:
git commit -m "Update"
git commit -m "Fix bug"
```

### Branches para Desenvolvimento

```bash
# Criar branch para feature
git checkout -b feature/expert-chat
git push origin feature/expert-chat

# Depois fazer Pull Request no GitHub
```

## 🔒 Segurança

### Proteger Secrets

- ✅ Nunca commitar `.env` com chaves reais
- ✅ Usar `.env.example` como template
- ✅ Adicionar `.env` ao `.gitignore`
- ✅ Usar GitHub Secrets para chaves sensíveis

### Proteger Main Branch

1. Vá para **Settings → Branches**
2. Clique em **"Add rule"**
3. Marque:
   - "Require pull request reviews"
   - "Require status checks to pass"
   - "Require branches to be up to date"

## 📞 Suporte

Se encontrar problemas:

1. Verificar logs no GitHub Actions
2. Ler documentação do Flutter
3. Verificar erros específicos

## 📖 Referências

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD](https://flutter.dev/docs/deployment/cd)
- [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Seu app está pronto para automação profissional! 🎉**

**Próximo passo: Fazer push para GitHub e ver a magia acontecer!**
