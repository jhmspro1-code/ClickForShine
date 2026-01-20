# Quick Start - ClickforShine Elite

## ⚡ Setup em 5 Minutos

### 1. Clone e Instale

```bash
git clone <seu-repositorio>
cd clickforshine_flutter
flutter pub get
```

### 2. Configure as Chaves de API

```bash
# Copiar template
cp .env.example .env

# Editar com suas chaves
nano .env
```

**Chaves necessárias:**

```env
# Microsoft Azure Vision (para análise de superfícies)
AZURE_VISION_KEY=your_key_here
AZURE_VISION_ENDPOINT=https://your-region.api.cognitive.microsoft.com/
AZURE_VISION_REGION=eastus

# OpenAI GPT-4 (para geração de laudos)
OPENAI_API_KEY=sk-your_key_here
OPENAI_MODEL=gpt-4

# Firebase
FIREBASE_API_KEY=your_key_here
FIREBASE_PROJECT_ID=your_project_id
```

### 3. Rode o App

```bash
flutter run
```

## 🔑 Onde Obter as Chaves

### Azure Vision
1. [Azure Portal](https://portal.azure.com)
2. Crie recurso "Computer Vision"
3. Copie chave e endpoint

### OpenAI
1. [OpenAI Platform](https://platform.openai.com)
2. Vá para "API Keys"
3. Crie nova chave

### Firebase
1. [Firebase Console](https://console.firebase.google.com)
2. Crie novo projeto
3. Copie credenciais

## 📱 Testar Funcionalidades

### 1. Análise com Azure Vision

```dart
final azureDS = AzureVisionDatasource();
final result = await azureDS.analyzeSurfaceImage(
  imageBytes,
  sector: 'automotive',
);

print('Superfície: ${result.surfaceType}');
print('Defeitos: ${result.defects}');
print('Dureza: ${result.hardnessLevel}/10');
```

### 2. Gerar Laudo com OpenAI

```dart
final openaiDS = OpenAIDatasource();
final report = await openaiDS.generateTechnicalReport(
  surfaceType: 'Clear Coat',
  defects: ['Swirls', 'Hologram'],
  hardnessScore: 5.0,
  damageLevel: 3.0,
  aggressivenessScore: 3.2,
  rpmRange: '1200-1600 RPM',
  padType: 'Espuma Fina',
  compoundType: 'Refino Suave',
  sector: 'automotive',
  clientName: 'João Silva',
);

print(report.technicalReport);
```

### 3. Análise Completa

```dart
final useCase = AnalyzeAndReportUseCase(repository);
final result = await useCase(
  imageBytes: imageData,
  sector: 'automotive',
  clientName: 'João Silva',
);

print('Laudo: ${result.technicalReport}');
print('Tempo estimado: ${result.estimatedWorkTime} minutos');
print('Custo estimado: ${result.estimatedCost}');
```

## 🐛 Troubleshooting

### "Azure Vision API key não configurada"

```bash
# Verificar se .env existe
cat .env

# Verificar se AZURE_VISION_KEY está preenchido
grep AZURE_VISION_KEY .env
```

### "OpenAI API key inválida"

```bash
# Verificar formato (deve começar com sk-)
grep OPENAI_API_KEY .env

# Testar chave
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer sk-your_key"
```

### "Firebase não conecta"

```bash
# Verificar firebase_options.dart
cat lib/firebase_options.dart

# Reconfigurar Firebase
flutterfire configure
```

## 📊 Estrutura de Pastas

```
lib/
├── core/
│   └── config/
│       └── env_config.dart          ← Carrega .env
├── data/
│   └── datasources/
│       ├── azure_vision_datasource.dart
│       └── openai_datasource.dart
├── domain/
│   └── usecases/
│       ├── calculate_aggressiveness_usecase.dart
│       └── analyze_and_report_usecase.dart
└── presentation/
    ├── pages/
    │   ├── home_page.dart
    │   ├── camera_page.dart
    │   ├── result_page.dart
    │   └── admin_panel.dart
    └── widgets/
        ├── hardness_chart.dart
        ├── camera_analyzer_view.dart
        └── glass_card.dart
```

## 🚀 Próximos Passos

1. **Testar integrações**: Execute os testes de conexão
2. **Capturar foto**: Use a câmera para testar análise
3. **Gerar laudo**: Veja o GPT-4 em ação
4. **Deploy**: Siga `DEPLOYMENT_GUIDE.md`

## 💡 Dicas

- Use `DEBUG_MODE=true` no `.env` para logs detalhados
- Monitore custos das APIs regularmente
- Faça backup de suas chaves de API
- Nunca commite o arquivo `.env`

## 📞 Suporte

Consulte a documentação completa em:
- `README.md` - Visão geral
- `docs/ARCHITECTURE.md` - Clean Architecture
- `docs/SMARTSHINE_ALGORITHM.md` - Algoritmo
- `docs/ELITE_INTEGRATION.md` - Integração com APIs

---

**Pronto para começar! 🚀**
