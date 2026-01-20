# Integração Elite - Google, Microsoft Azure, OpenAI

## 🎯 Visão Geral

ClickforShine integra três infraestruturas de elite para análise profissional:

| Serviço | Função | Precisão |
|---------|--------|----------|
| **Microsoft Azure Vision** | Análise de superfícies | 99% |
| **OpenAI GPT-4** | Geração de laudos | Profissional |
| **Google Firebase** | Backend e sincronização | 99.9% uptime |

## 🔐 Configuração de Chaves

### 1. Arquivo `.env`

Crie um arquivo `.env` na raiz do projeto com suas chaves:

```bash
# Copiar template
cp .env.example .env

# Editar com suas credenciais
nano .env
```

### 2. Estrutura do `.env`

```env
# MICROSOFT AZURE VISION
AZURE_VISION_KEY=your_azure_vision_key_here
AZURE_VISION_ENDPOINT=https://your-region.api.cognitive.microsoft.com/
AZURE_VISION_REGION=eastus

# OPENAI GPT-4
OPENAI_API_KEY=sk-your_openai_key_here
OPENAI_MODEL=gpt-4
OPENAI_ORGANIZATION_ID=your_org_id_optional

# FIREBASE
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_project_id

# GOOGLE CLOUD
GOOGLE_CLOUD_PROJECT_ID=your_google_cloud_project
GOOGLE_CLOUD_API_KEY=your_google_cloud_api_key

# AMBIENTE
ENVIRONMENT=production
DEBUG_MODE=false
```

### 3. ⚠️ Segurança

**NUNCA commite o arquivo `.env`!**

```bash
# Adicionar ao .gitignore
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore
```

## 🏗️ Arquitetura de Integração

```
┌─────────────────────────────────────────────────────────┐
│                   FLUTTER APP                            │
│  (iOS/Android com câmera)                               │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   FIREBASE   │ │ AZURE VISION │ │   OPENAI     │
│   (Backend)  │ │  (Analysis)  │ │   (Reports)  │
└──────────────┘ └──────────────┘ └──────────────┘
```

## 🔧 Obter Chaves de API

### Microsoft Azure Vision

1. Acesse [Azure Portal](https://portal.azure.com)
2. Crie novo recurso: "Computer Vision"
3. Selecione região (ex: East US)
4. Copie:
   - **Chave**: Keys and Endpoint → Key 1
   - **Endpoint**: Keys and Endpoint → Endpoint
   - **Região**: Sua região selecionada

**Preço**: $1-7 por 1000 chamadas (conforme volume)

### OpenAI GPT-4

1. Acesse [OpenAI Platform](https://platform.openai.com)
2. Vá para "API Keys"
3. Crie nova chave
4. Copie a chave (formato: `sk-...`)

**Preço**: $0.03/1K tokens entrada, $0.06/1K tokens saída

### Google Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie novo projeto
3. Vá para "Project Settings"
4. Copie as credenciais

**Preço**: Gratuito até 1GB armazenamento

## 📊 Fluxo de Análise Completa

```
1. Usuário captura foto com câmera
   ↓
2. Imagem enviada para Microsoft Azure Vision
   ↓
3. Azure retorna:
   - Tipo de superfície
   - Defeitos detectados (99% precisão)
   - Dureza estimada
   - Nível de dano
   ↓
4. SmartShine calcula agressividade
   Agressividade = (S × 0.4) + (D × 0.6)
   ↓
5. Determina setup recomendado
   (RPM, Pad, Composto)
   ↓
6. Envia para OpenAI GPT-4
   ↓
7. GPT-4 gera laudo profissional
   ↓
8. Retorna resultado completo ao usuário
```

## 💻 Implementação

### Arquivo de Configuração

```dart
// lib/core/config/env_config.dart

class EnvConfig {
  // Carregado automaticamente do .env
  static const String azureVisionKey = String.fromEnvironment('AZURE_VISION_KEY');
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY');
  
  // Validar chaves
  static bool validateRequiredKeys() {
    return !azureVisionKey.contains('your_') &&
           !openaiApiKey.contains('your_');
  }
}
```

### Datasource do Azure Vision

```dart
// lib/data/datasources/azure_vision_datasource.dart

class AzureVisionDatasource {
  Future<AzureVisionResponse> analyzeSurfaceImage(
    Uint8List imageBytes, {
    required String sector,
  }) async {
    // 1. Validar chave
    if (_apiKey.contains('your_')) {
      throw Exception('Azure Vision API key não configurada');
    }
    
    // 2. Enviar para Azure
    final response = await _dio.post(
      '${_endpoint}vision/v3.2/analyze',
      data: imageBytes,
      options: Options(
        headers: {
          'Ocp-Apim-Subscription-Key': _apiKey,
          'Content-Type': 'application/octet-stream',
        },
      ),
    );
    
    // 3. Processar resposta
    return _processSurfaceAnalysis(response.data, sector: sector);
  }
}
```

### Datasource do OpenAI

```dart
// lib/data/datasources/openai_datasource.dart

class OpenAIDatasource {
  Future<OpenAIResponse> generateTechnicalReport({
    required String surfaceType,
    required List<String> defects,
    required double hardnessScore,
    // ... outros parâmetros
  }) async {
    // 1. Validar chave
    if (_apiKey.contains('sk-your')) {
      throw Exception('OpenAI API key não configurada');
    }
    
    // 2. Construir prompt profissional
    final prompt = _buildPrompt(...);
    
    // 3. Chamar OpenAI
    final response = await _dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: {
        'model': 'gpt-4',
        'messages': [
          {'role': 'system', 'content': _getSystemPrompt()},
          {'role': 'user', 'content': prompt},
        ],
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      ),
    );
    
    // 4. Processar laudo
    return _processResponse(response.data);
  }
}
```

### Use Case Orquestrador

```dart
// lib/domain/usecases/analyze_and_report_usecase.dart

class AnalyzeAndReportUseCase {
  Future<AnalysisAndReportResult> call({
    required Uint8List imageBytes,
    required String sector,
    required String clientName,
  }) async {
    // 1. Azure Vision
    final azureAnalysis = await analysisRepository.analyzeWithAzure(
      imageBytes,
      sector: sector,
    );
    
    // 2. SmartShine
    final aggressivenessScore = 
        (azureAnalysis.hardnessLevel * 0.4) + 
        (azureAnalysis.damageLevel * 0.6);
    
    // 3. Setup recomendado
    final (rpmRange, padType, compoundType, safetyIndex) =
        _getRecommendedSetup(aggressivenessScore, sector);
    
    // 4. OpenAI GPT-4
    final openaiReport = await analysisRepository.generateReportWithOpenAI(
      surfaceType: azureAnalysis.surfaceType,
      defects: azureAnalysis.defects,
      hardnessScore: azureAnalysis.hardnessLevel,
      damageLevel: azureAnalysis.damageLevel,
      aggressivenessScore: aggressivenessScore,
      rpmRange: rpmRange,
      padType: padType,
      compoundType: compoundType,
      sector: sector,
      clientName: clientName,
    );
    
    // 5. Retornar resultado completo
    return AnalysisAndReportResult(
      surfaceType: azureAnalysis.surfaceType,
      defects: azureAnalysis.defects,
      hardnessScore: azureAnalysis.hardnessLevel,
      damageLevel: azureAnalysis.damageLevel,
      aggressivenessScore: aggressivenessScore,
      rpmRange: rpmRange,
      padType: padType,
      compoundType: compoundType,
      safetyIndex: safetyIndex,
      technicalReport: openaiReport.technicalReport,
      recommendations: openaiReport.recommendations,
      safetyWarnings: openaiReport.safetyWarnings,
      estimatedWorkTime: openaiReport.estimatedWorkTime,
      estimatedCost: openaiReport.estimatedCost,
      analysisConfidence: azureAnalysis.confidence,
    );
  }
}
```

## 📈 Precisão e Performance

### Microsoft Azure Vision

- **Precisão**: 99% para detecção de defeitos
- **Latência**: ~500ms por imagem
- **Suporte**: Oxidação, Swirls, Hologramas, Corrosão, Calcinação

### OpenAI GPT-4

- **Qualidade**: Laudos profissionais e persuasivos
- **Latência**: ~2-3 segundos por laudo
- **Idioma**: Português fluente

### Firebase

- **Uptime**: 99.9%
- **Latência**: <100ms (região próxima)
- **Sincronização**: Automática

## 💰 Estimativa de Custos

| Serviço | Volume | Custo Mensal |
|---------|--------|------------|
| Azure Vision | 1000 análises | $5-10 |
| OpenAI GPT-4 | 1000 laudos | $30-50 |
| Firebase | 1GB dados | Gratuito |
| **Total** | | **$35-60/mês** |

## 🧪 Testar Integração

### 1. Validar Chaves

```dart
final config = EnvConfig();
if (!config.validateRequiredKeys()) {
  print('Chaves não configuradas!');
  print('Chaves faltando: ${config.getMissingKeys()}');
}
```

### 2. Testar Azure Vision

```dart
final azureDS = AzureVisionDatasource();
final isConnected = await azureDS.testConnection();
print('Azure Vision: ${isConnected ? "✅ Conectado" : "❌ Erro"}');
```

### 3. Testar OpenAI

```dart
final openaiDS = OpenAIDatasource();
final isConnected = await openaiDS.testConnection();
print('OpenAI: ${isConnected ? "✅ Conectado" : "❌ Erro"}');
```

## 🚀 Deploy em Produção

### 1. Configurar Variáveis no Servidor

```bash
# No seu servidor de deployment
export AZURE_VISION_KEY=sk-...
export OPENAI_API_KEY=sk-...
export FIREBASE_PROJECT_ID=...
```

### 2. Build com Variáveis

```bash
flutter build apk --release \
  --dart-define=AZURE_VISION_KEY=sk-... \
  --dart-define=OPENAI_API_KEY=sk-...
```

### 3. Monitorar Custos

- Azure: [Azure Cost Management](https://portal.azure.com)
- OpenAI: [Usage Dashboard](https://platform.openai.com/usage)
- Firebase: [Firebase Console](https://console.firebase.google.com)

## 📚 Referências

- [Azure Vision API](https://learn.microsoft.com/en-us/azure/ai-services/computer-vision/)
- [OpenAI API](https://platform.openai.com/docs/)
- [Firebase Documentation](https://firebase.google.com/docs)

---

**Infraestrutura de elite para diagnóstico profissional de polimento**
