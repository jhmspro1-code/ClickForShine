# ClickforShine - Guia Passo-a-Passo GitHub

## 🎯 Objetivo Final

Você vai:
1. ✅ Criar repositório no GitHub
2. ✅ Subir os arquivos do ClickforShine
3. ✅ Configurar Secrets (chaves de API)
4. ✅ Ver GitHub Actions compilar automaticamente
5. ✅ Baixar APK/IPA pronto para instalar

---

## 📋 PASSO 1: Criar Repositório no GitHub

### 1.1 Acessar GitHub

1. Abra [github.com](https://github.com)
2. Faça login (ou crie conta se não tiver)

### 1.2 Criar Novo Repositório

1. Clique no **"+"** (canto superior direito)
   ```
   Você verá: + ▼
   ```

2. Selecione **"New repository"**

### 1.3 Preencher Informações

**Repository name:**
```
clickforshine
```

**Description (opcional):**
```
ClickforShine - Plataforma de Diagnóstico de Polimento com IA
```

**Visibility:**
- Selecione **"Public"** (recomendado para usar GitHub Actions gratuito)

**Initialize this repository with:**
- Deixe em branco (não marque nada)

### 1.4 Criar Repositório

Clique em **"Create repository"**

✅ Seu repositório foi criado!

---

## 📥 PASSO 2: Preparar Arquivos Localmente

### 2.1 Descompactar ZIP

```bash
# Abra o terminal/prompt
# Windows: PowerShell ou CMD
# macOS/Linux: Terminal

# Navegue até a pasta onde baixou o ZIP
cd Downloads

# Descompacte
unzip clickforshine_flutter_production.zip

# Ou clique com botão direito → Extrair tudo
```

### 2.2 Abrir Pasta do Projeto

```bash
cd clickforshine_flutter
```

---

## 🔧 PASSO 3: Conectar Git ao GitHub

### 3.1 Inicializar Git

```bash
# Já deve estar inicializado, mas confirme:
git status

# Se der erro, inicialize:
git init
```

### 3.2 Conectar ao Repositório GitHub

```bash
# Substitua "seu-usuario" pelo seu usuário GitHub
git remote add origin https://github.com/seu-usuario/clickforshine.git

# Verificar conexão
git remote -v
```

**Você deve ver:**
```
origin  https://github.com/seu-usuario/clickforshine.git (fetch)
origin  https://github.com/seu-usuario/clickforshine.git (push)
```

### 3.3 Fazer Primeiro Commit

```bash
# Adicionar todos os arquivos
git add .

# Criar commit
git commit -m "Initial commit: ClickforShine Flutter production ready"

# Renomear branch para main (se necessário)
git branch -M main
```

### 3.4 Fazer Push para GitHub

```bash
# Fazer push
git push -u origin main

# Será pedido seu usuário e senha do GitHub
# Digite seu usuário GitHub
# Para senha, use um Personal Access Token (veja abaixo)
```

#### 🔐 Usar Personal Access Token (Recomendado)

Se der erro de autenticação:

1. Vá para [github.com/settings/tokens](https://github.com/settings/tokens)
2. Clique em **"Generate new token"** → **"Generate new token (classic)"**
3. Nome: `clickforshine-deployment`
4. Marque: `repo`, `workflow`
5. Clique em **"Generate token"**
6. Copie o token (aparece uma única vez!)
7. Use como senha no git push

**Exemplo:**
```bash
Username: seu-usuario
Password: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

✅ Arquivos foram para GitHub!

---

## 🔐 PASSO 4: Configurar Secrets (Chaves de API)

### 4.1 Acessar Secrets

1. Vá para seu repositório no GitHub
2. Clique em **"Settings"** (engrenagem, lado direito)
3. Na esquerda, clique em **"Secrets and variables"**
4. Clique em **"Actions"**

### 4.2 Adicionar Secrets

Você vai adicionar 4 secrets. Para cada um:

1. Clique em **"New repository secret"**
2. Preencha **Name** e **Secret**
3. Clique em **"Add secret"**

#### Secret 1: OpenAI API Key

**Name:**
```
OPENAI_API_KEY
```

**Secret:**
```
sk-proj-xxxxxxxxxxxxxxxxxxxxxxxxxx
```

Obter em: [platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)

#### Secret 2: Azure Vision Key

**Name:**
```
AZURE_VISION_KEY
```

**Secret:**
```
sua_chave_azure_aqui
```

Obter em: [portal.azure.com](https://portal.azure.com)

#### Secret 3: Google Cloud API Key

**Name:**
```
GOOGLE_CLOUD_API_KEY
```

**Secret:**
```
sua_chave_google_aqui
```

Obter em: [console.cloud.google.com](https://console.cloud.google.com)

#### Secret 4: Firebase API Key

**Name:**
```
FIREBASE_API_KEY
```

**Secret:**
```
sua_chave_firebase_aqui
```

Obter em: [console.firebase.google.com](https://console.firebase.google.com)

✅ Todos os secrets foram configurados!

---

## 🚀 PASSO 5: Fazer Push e Iniciar Compilação

### 5.1 Fazer Push de Teste

```bash
# Fazer uma pequena mudança (opcional)
echo "# ClickforShine" > README.md

# Adicionar
git add README.md

# Commit
git commit -m "Add README"

# Push
git push origin main
```

### 5.2 Verificar GitHub Actions

1. Vá para seu repositório no GitHub
2. Clique na aba **"Actions"** (topo)
3. Você verá o workflow **"Build ClickforShine APK & IPA"** rodando

**Status:**
- 🟡 Amarelo = Compilando
- 🟢 Verde = Sucesso
- 🔴 Vermelho = Erro

### 5.3 Aguardar Compilação

Tempo estimado:
- Android APK: 10-15 minutos
- iOS IPA: 15-20 minutos

---

## 📥 PASSO 6: Baixar APK/IPA

### 6.1 Opção 1: Do Workflow (Recomendado)

1. Vá para **"Actions"**
2. Clique no workflow mais recente (verde ✅)
3. Você verá **"Artifacts"** no final da página
4. Clique em **"android-apk"** para baixar APK
5. Clique em **"ios-ipa"** para baixar IPA

### 6.2 Opção 2: Do Release (Permanente)

Para criar uma versão permanente:

```bash
# Criar tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Push tag
git push origin v1.0.0
```

Depois:
1. Vá para **"Releases"** no seu repositório
2. Clique em **"v1.0.0"**
3. Baixe os arquivos APK/IPA

---

## 📱 PASSO 7: Instalar no Celular

### Android

#### Opção 1: Download Direto

1. Baixar APK do GitHub
2. Transferir para celular
3. Abrir arquivo
4. Instalar

#### Opção 2: Via ADB

```bash
# Conectar celular via USB
# Habilitar "Depuração USB" em Configurações > Desenvolvedor

# Instalar
adb install app-release.apk
```

### iOS

1. Baixar IPA do GitHub
2. Abrir em Xcode
3. Conectar iPhone
4. Instalar

---

## 🐛 PASSO 8: Troubleshooting

### Problema: "Build falhou"

**Solução:**
1. Vá para **"Actions"**
2. Clique no workflow que falhou
3. Clique em **"Build Android"** ou **"Build iOS"**
4. Veja os logs detalhados
5. Procure pela linha de erro

### Problema: "Secrets não funcionam"

**Solução:**
1. Verificar se foram adicionados em **Settings → Secrets**
2. Verificar nome exato (case-sensitive)
3. Fazer novo push para testar

### Problema: "APK não aparece"

**Solução:**
1. Verificar se build completou com sucesso (verde ✅)
2. Ir para **Actions → Workflow → Artifacts**
3. Baixar manualmente

### Problema: "Erro de autenticação no Git"

**Solução:**
1. Usar Personal Access Token (veja PASSO 3.4)
2. Ou configurar SSH:
   ```bash
   ssh-keygen -t ed25519
   # Adicionar chave pública em GitHub Settings
   ```

---

## 📊 Fluxo Completo

```
1. Criar repositório GitHub
   ↓
2. Descompactar ZIP
   ↓
3. git init + git remote add
   ↓
4. git add . + git commit + git push
   ↓
5. Configurar Secrets no GitHub
   ↓
6. Fazer novo push
   ↓
7. GitHub Actions detecta
   ↓
8. Compila Android (10-15 min)
   Compila iOS (15-20 min)
   ↓
9. Salva artefatos
   ↓
10. Você baixa APK/IPA
    ↓
11. Instala no celular
    ↓
12. 🎉 App rodando!
```

---

## 💡 Dicas Profissionais

### Commits Significativos

```bash
# Bom:
git commit -m "feat: Add Expert Shine Chat module"
git commit -m "fix: Resolve Azure Vision API timeout"
git commit -m "docs: Update README with setup instructions"

# Ruim:
git commit -m "Update"
git commit -m "Fix bug"
git commit -m "Changes"
```

### Branches para Desenvolvimento

```bash
# Criar branch para feature
git checkout -b feature/expert-chat
git push origin feature/expert-chat

# Depois fazer Pull Request no GitHub
```

### Ver Histórico

```bash
# Ver commits
git log --oneline

# Ver branches
git branch -a

# Ver status
git status
```

---

## 🔒 Segurança

### ✅ Boas Práticas

- ✅ Nunca commitar `.env` com chaves reais
- ✅ Usar `.env.example` como template
- ✅ Adicionar `.env` ao `.gitignore`
- ✅ Usar GitHub Secrets para chaves sensíveis
- ✅ Revogar chaves comprometidas imediatamente

### ❌ Nunca Faça

- ❌ Compartilhar chaves de API em chat
- ❌ Commitar chaves no repositório
- ❌ Usar mesma chave em múltiplos serviços
- ❌ Deixar chaves em código comentado

---

## 📞 Suporte

Se encontrar problemas:

1. Verificar logs no GitHub Actions
2. Ler documentação do Flutter
3. Procurar por erros específicos

---

## 🎉 Parabéns!

Você tem um **app profissional compilando automaticamente no GitHub!**

### Próximos Passos

1. ✅ App compilando automaticamente
2. ⏭️ Adicionar testes unitários
3. ⏭️ Deploy automático para Play Store
4. ⏭️ Deploy automático para App Store

---

**Seu ClickforShine está pronto para o mundo! 🚀**
