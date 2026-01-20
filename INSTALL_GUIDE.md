# Guia de Instalação - ClickforShine Flutter

## 🚀 Instalação Rápida

### Windows

1. **Baixar o projeto**
   - Baixe `clickforshine_flutter.zip`
   - Descompacte em uma pasta

2. **Executar instalador**
   ```bash
   # Duplo-clique em: install.bat
   # Ou execute no terminal:
   install.bat
   ```

3. **Configurar chaves de API**
   - Edite o arquivo `.env`
   - Preencha com suas chaves (veja seção abaixo)

4. **Rodar o app**
   ```bash
   flutter run
   ```

### macOS / Linux

1. **Baixar o projeto**
   ```bash
   unzip clickforshine_flutter.zip
   cd clickforshine_flutter
   ```

2. **Executar instalador**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Configurar chaves de API**
   ```bash
   nano .env
   # Preencha com suas chaves
   ```

4. **Rodar o app**
   ```bash
   flutter run
   ```

## 🔑 Configurar Chaves de API

### 1. Abrir arquivo .env

```bash
# Windows
notepad .env

# macOS/Linux
nano .env
```

### 2. Preencher as chaves

```env
# MICROSOFT AZURE VISION
AZURE_VISION_KEY=your_key_here
AZURE_VISION_ENDPOINT=https://eastus.api.cognitive.microsoft.com/
AZURE_VISION_REGION=eastus

# OPENAI GPT-4o
OPENAI_API_KEY=sk-your_key_here
OPENAI_MODEL=gpt-4o

# FIREBASE
FIREBASE_API_KEY=your_key_here
FIREBASE_PROJECT_ID=your_project_id

# GOOGLE CLOUD
GOOGLE_CLOUD_API_KEY=your_key_here
GOOGLE_CLOUD_PROJECT_ID=your_project_id

# AMBIENTE
ENVIRONMENT=production
DEBUG_MODE=false
```

### 3. Onde obter as chaves

#### Microsoft Azure Vision
1. Acesse [Azure Portal](https://portal.azure.com)
2. Crie recurso "Computer Vision"
3. Copie a chave e endpoint

#### OpenAI GPT-4o
1. Acesse [OpenAI Platform](https://platform.openai.com)
2. Vá para "API Keys"
3. Crie nova chave (começa com `sk-`)

#### Firebase
1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie novo projeto
3. Copie as credenciais

#### Google Cloud
1. Acesse [Google Cloud Console](https://console.cloud.google.com)
2. Crie novo projeto
3. Habilite "Custom Search API"
4. Copie a chave

## 📱 Rodar no Celular

### Android

```bash
# Conectar celular via USB
# Habilitar "Depuração USB" nas configurações

flutter run
```

### iOS

```bash
# Requer macOS
flutter run
```

### Web

```bash
flutter run -d chrome
```

## 🐛 Troubleshooting

### "Flutter não encontrado"

```bash
# Adicionar Flutter ao PATH
# Windows: Adicionar C:\flutter\bin ao PATH
# macOS/Linux: Adicionar ~/flutter/bin ao PATH

# Ou execute:
flutter doctor
```

### "Erro ao instalar dependências"

```bash
flutter clean
flutter pub get
```

### "Erro Firebase"

```bash
flutterfire configure
```

### "Chaves de API não funcionam"

1. Verificar se as chaves estão corretas
2. Verificar se estão habilitadas no console
3. Verificar limite de requisições
4. Verificar se a região está correta

## ✅ Verificar Instalação

```bash
# Verificar Flutter
flutter doctor

# Verificar dependências
flutter pub get

# Verificar análise de código
flutter analyze

# Rodar testes
flutter test
```

## 📚 Próximos Passos

1. Ler `README.md` para visão geral
2. Ler `QUICK_START.md` para exemplos
3. Ler `docs/ELITE_INTEGRATION.md` para integração com APIs
4. Explorar o código em `lib/`

## 🆘 Suporte

Se encontrar problemas:

1. Verificar `QUICK_START.md`
2. Verificar `docs/ELITE_INTEGRATION.md`
3. Verificar logs: `flutter run -v`
4. Verificar `flutter doctor`

## 📞 Contato

Para suporte técnico, consulte a documentação no projeto.

---

**Pronto para começar! 🚀**
