# ClickforShine - Flutter Edition

**Plataforma universal de diagnóstico técnico de polimento com Clean Architecture, algoritmo SmartShine e Admin Panel web.**

## 🎯 Visão Geral

ClickforShine é uma aplicação mobile profissional (Android/iOS) + web admin para diagnóstico técnico de polimento em 4 setores especializados:

- **🚗 Automotivo**: Vernizes, plásticos, revestimentos
- **⛵ Náutico**: Gel Coat, madeiras nobres, embarcações
- **✈️ Aeronáutico**: Alumínio, poliuretano, acrílicos de aviação
- **🏭 Industrial**: Metais, pedras, resinas

### Algoritmo SmartShine

```
Agressividade = (S * 0.4) + (D * 0.6)
Onde:
- S: Dureza da Superfície (1-10)
- D: Nível de Dano (1-10)
```

**Output**: Recomendações automáticas de RPM, tipo de pad, composto e proteção.

## 🏗️ Arquitetura

```
lib/
├── core/
│   ├── constants/        # Constantes da aplicação
│   ├── theme/           # ThemeData dark mode premium
│   ├── utils/           # Utilitários
│   └── errors/          # Tratamento de erros
├── domain/              # Clean Architecture - Lógica de Negócio
│   ├── entities/        # SurfaceEntity, CorrectionRecommendationEntity
│   ├── repositories/    # Interfaces abstratas
│   └── usecases/        # CalculateAggressivenessUseCase
├── data/                # Clean Architecture - Camada de Dados
│   ├── datasources/     # Firebase, APIs
│   ├── models/          # Modelos de dados
│   └── repositories/    # Implementações concretas
└── presentation/        # Clean Architecture - UI
    ├── bloc/            # BLoC/Riverpod providers
    ├── pages/           # HomePage, AdminPanel
    └── widgets/         # CameraAnalyzerView, HardnessChart
```

## 🚀 Setup Inicial

### Pré-requisitos

- Flutter 3.16+ ([Download](https://flutter.dev/docs/get-started/install))
- Dart 3.2+
- Android Studio ou Xcode
- Firebase CLI

### Instalação

```bash
# 1. Clonar repositório
git clone <seu-repositorio>
cd clickforshine_flutter

# 2. Instalar dependências
flutter pub get

# 3. Configurar Firebase
flutterfire configure

# 4. Rodar o app
flutter run
```

## 🔧 Configuração Firebase

### 1. Criar Projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie novo projeto: `clickforshine-prod`
3. Ative os serviços:
   - Authentication (Email/Password)
   - Firestore Database
   - Storage
   - Remote Config

### 2. Atualizar `firebase_options.dart`

```dart
// Substitua pelos seus dados do Firebase Console
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
);
```

### 3. Estrutura Firestore

```
firestore/
├── compounds/
│   ├── doc_id
│   │   ├── name: string
│   │   ├── brand: string
│   │   ├── abrasivity: number (1-10)
│   │   └── sector: string
├── pads/
│   ├── doc_id
│   │   ├── name: string
│   │   ├── material: string
│   │   ├── hardness: number (1-10)
│   │   └── sector: string
└── diagnostics/
    ├── doc_id
    │   ├── userId: string
    │   ├── sector: string
    │   ├── surfaceType: string
    │   ├── defects: array
    │   ├── hardnessScore: number
    │   ├── aggressivenessScore: number
    │   └── timestamp: timestamp
```

## 📱 Compilação

### Android

```bash
# Build APK
flutter build apk --release

# Build AAB (para Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build IPA
flutter build ipa --release
```

### Web (Admin Panel)

```bash
# Build web
flutter build web --release

# Deploy no Firebase Hosting
firebase deploy --only hosting
```

## 🎨 Tema Dark Mode Premium

Paleta de cores:
- **Fundo**: `#000000` (Preto Profundo)
- **Surface**: `#1A1A1A` (Cinza Grafite)
- **Primary**: `#D4AF37` (Dourado Champagne)
- **Secondary**: `#2E5EAA` (Azul Cobalto)

Tipografia: **Montserrat** (Google Fonts)

## 📊 Algoritmo SmartShine - Exemplo

```dart
final useCase = CalculateAggressivenessUseCase();

final result = useCase(
  surfaceHardness: 7.0,      // Verniz duro
  damageLevel: 6.0,          // Dano moderado
  sector: 'automotive',
);

// Output:
// aggressivenessScore: 6.4
// cuttingLevel: 2 (Corte Pesado)
// rpmRange: "1600-2000 RPM"
// padType: "Espuma Média"
// compoundType: "Corte Médio"
// safetyIndex: 6.5
```

## 🛠️ Admin Panel Web

Acesse em `http://localhost:5000/admin` (após deploy)

**Funcionalidades**:
- ✅ CRUD de Compostos
- ✅ CRUD de Pads
- ✅ Edição de RPM ranges
- ✅ Sincronização automática com app

**Sem necessidade de recompilar o app!**

## 🧪 Testes

```bash
# Executar testes unitários
flutter test

# Executar testes de integração
flutter test integration_test/
```

## 📦 Dependências Principais

| Pacote | Versão | Uso |
|--------|--------|-----|
| `riverpod` | ^2.4.0 | Gerenciamento de estado |
| `firebase_core` | ^2.24.0 | Firebase initialization |
| `firebase_firestore` | ^4.14.0 | Database |
| `camera` | ^0.10.5 | Câmera |
| `lottie` | ^2.7.0 | Animações |
| `google_fonts` | ^6.1.0 | Tipografia |

## 🚀 Deploy

### App Store (iOS)

```bash
# 1. Criar certificado de distribuição
# 2. Build IPA
flutter build ipa --release

# 3. Upload via Transporter
open /Applications/Transporter.app
```

### Google Play (Android)

```bash
# 1. Criar keystore
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# 2. Build AAB
flutter build appbundle --release

# 3. Upload no Google Play Console
```

### Firebase Hosting (Admin Panel)

```bash
# 1. Build web
flutter build web --release

# 2. Deploy
firebase deploy --only hosting
```

## 📝 Estrutura de Código

### Domain Layer (Lógica de Negócio)

```dart
// lib/domain/usecases/calculate_aggressiveness_usecase.dart
class CalculateAggressivenessUseCase {
  AggressivenessResult call({
    required double surfaceHardness,
    required double damageLevel,
    required String sector,
  }) {
    // Algoritmo SmartShine
    final aggressivenessScore = (surfaceHardness * 0.4) + (damageLevel * 0.6);
    // ... retorna recomendações
  }
}
```

### Data Layer (Firestore)

```dart
// lib/data/repositories/compound_repository_impl.dart
class CompoundRepositoryImpl implements CompoundRepository {
  final FirebaseFirestore _firestore;
  
  Future<List<Compound>> getCompounds(String sector) async {
    final snapshot = await _firestore
        .collection('compounds')
        .where('sector', isEqualTo: sector)
        .get();
    
    return snapshot.docs.map((doc) => Compound.fromJson(doc.data())).toList();
  }
}
```

### Presentation Layer (UI)

```dart
// lib/presentation/widgets/hardness_chart.dart
class HardnessChart extends StatefulWidget {
  final double surfaceHardness;
  final double setupAggressiveness;
  
  // Renderiza gráfico animado com CustomPainter
}
```

## 🔐 Segurança

- ✅ Firebase Authentication
- ✅ Firestore Security Rules
- ✅ API Key protection
- ✅ Sem armazenamento de dados sensíveis localmente

## 📞 Suporte

Para issues ou dúvidas:
1. Abra uma issue no GitHub
2. Consulte a documentação em `/docs`
3. Entre em contato: support@clickforshine.com

## 📄 Licença

Propriedade intelectual. Todos os direitos reservados.

---

**Desenvolvido com ❤️ para profissionais de polimento e detalhamento**

**Versão**: 1.0.0  
**Última atualização**: Janeiro 2024
