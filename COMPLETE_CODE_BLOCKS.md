# ClickforShine - Blocos de Código Completos

## 📋 Índice

1. [GitHub Actions Workflow](#github-actions-workflow)
2. [Configuração de Ambiente (.env)](#configuração-de-ambiente)
3. [Código Flutter - Main](#código-flutter---main)
4. [SmartShine Algorithm](#smartshine-algorithm)
5. [Expert Chat Integration](#expert-chat-integration)
6. [Admin Panel Web](#admin-panel-web)
7. [Segurança e Secrets](#segurança-e-secrets)

---

## GitHub Actions Workflow

### Arquivo: `.github/workflows/main.yml`

```yaml
name: Build ClickforShine APK & IPA

on:
  push:
    branches: [ main, develop ]
    tags: [ 'v*' ]
  pull_request:
    branches: [ main, develop ]

env:
  FLUTTER_VERSION: '3.16.0'

jobs:
  build-android:
    runs-on: ubuntu-latest
    
    steps:
    - name: 📥 Checkout code
      uses: actions/checkout@v4
    
    - name: 🔧 Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '11'
        cache: gradle
    
    - name: 🐦 Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: ${{ env.FLUTTER_VERSION }}
        channel: 'stable'
        cache: true
    
    - name: 📦 Get dependencies
      run: flutter pub get
    
    - name: 🔍 Analyze code
      run: flutter analyze
    
    - name: 🧪 Run tests
      run: flutter test
    
    - name: 🏗️ Build APK (Release)
      run: flutter build apk --release --split-per-abi
      env:
        OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        AZURE_VISION_KEY: ${{ secrets.AZURE_VISION_KEY }}
        GOOGLE_CLOUD_API_KEY: ${{ secrets.GOOGLE_CLOUD_API_KEY }}
        FIREBASE_API_KEY: ${{ secrets.FIREBASE_API_KEY }}
    
    - name: 📤 Upload APK artifacts
      uses: actions/upload-artifact@v3
      with:
        name: android-apk
        path: build/app/outputs/flutter-apk/
        retention-days: 30
    
    - name: 📤 Upload to Release
      if: startsWith(github.ref, 'refs/tags/')
      uses: softprops/action-gh-release@v1
      with:
        files: build/app/outputs/flutter-apk/app-*.apk
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  build-ios:
    runs-on: macos-latest
    
    steps:
    - name: 📥 Checkout code
      uses: actions/checkout@v4
    
    - name: 🐦 Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: ${{ env.FLUTTER_VERSION }}
        channel: 'stable'
        cache: true
    
    - name: 📦 Get dependencies
      run: flutter pub get
    
    - name: 🔍 Analyze code
      run: flutter analyze
    
    - name: 🏗️ Build IPA (Release)
      run: flutter build ipa --release --export-method ad-hoc
      env:
        OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        AZURE_VISION_KEY: ${{ secrets.AZURE_VISION_KEY }}
        GOOGLE_CLOUD_API_KEY: ${{ secrets.GOOGLE_CLOUD_API_KEY }}
        FIREBASE_API_KEY: ${{ secrets.FIREBASE_API_KEY }}
    
    - name: 📤 Upload IPA artifacts
      uses: actions/upload-artifact@v3
      with:
        name: ios-ipa
        path: build/ios/ipa/
        retention-days: 30
    
    - name: 📤 Upload to Release
      if: startsWith(github.ref, 'refs/tags/')
      uses: softprops/action-gh-release@v1
      with:
        files: build/ios/ipa/*.ipa
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  notify:
    runs-on: ubuntu-latest
    needs: [build-android, build-ios]
    if: always()
    
    steps:
    - name: ✅ Build Status
      run: |
        echo "Android Build: ${{ needs.build-android.result }}"
        echo "iOS Build: ${{ needs.build-ios.result }}"
```

---

## Configuração de Ambiente

### Arquivo: `.env.example`

```env
# OPENAI GPT-4o
OPENAI_API_KEY=sk-your_key_here
OPENAI_MODEL=gpt-4o

# MICROSOFT AZURE VISION
AZURE_VISION_KEY=your_azure_vision_key_here
AZURE_VISION_ENDPOINT=https://eastus.api.cognitive.microsoft.com/
AZURE_VISION_REGION=eastus

# GOOGLE CLOUD
GOOGLE_CLOUD_API_KEY=your_google_cloud_api_key_here
GOOGLE_CLOUD_PROJECT_ID=your_project_id

# FIREBASE
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_APP_ID=your_app_id

# AMBIENTE
ENVIRONMENT=production
DEBUG_MODE=false
```

### Arquivo: `lib/core/config/env_config.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuração centralizada de variáveis de ambiente
/// 
/// Carrega chaves de API do arquivo .env
/// Valida automaticamente chaves obrigatórias
class EnvConfig {
  static late final String openaiApiKey;
  static late final String azureVisionKey;
  static late final String azureVisionEndpoint;
  static late final String azureVisionRegion;
  static late final String googleCloudApiKey;
  static late final String googleCloudProjectId;
  static late final String firebaseApiKey;
  static late final String firebaseProjectId;
  static late final String environment;
  static late final bool debugMode;

  /// Inicializar configurações
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    openaiApiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    azureVisionKey = dotenv.env['AZURE_VISION_KEY'] ?? '';
    azureVisionEndpoint = dotenv.env['AZURE_VISION_ENDPOINT'] ?? '';
    azureVisionRegion = dotenv.env['AZURE_VISION_REGION'] ?? '';
    googleCloudApiKey = dotenv.env['GOOGLE_CLOUD_API_KEY'] ?? '';
    googleCloudProjectId = dotenv.env['GOOGLE_CLOUD_PROJECT_ID'] ?? '';
    firebaseApiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
    firebaseProjectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
    environment = dotenv.env['ENVIRONMENT'] ?? 'production';
    debugMode = dotenv.env['DEBUG_MODE'] == 'true';

    _validateRequiredKeys();
  }

  /// Validar chaves obrigatórias
  static void _validateRequiredKeys() {
    final missing = <String>[];

    if (openaiApiKey.isEmpty) missing.add('OPENAI_API_KEY');
    if (azureVisionKey.isEmpty) missing.add('AZURE_VISION_KEY');
    if (googleCloudApiKey.isEmpty) missing.add('GOOGLE_CLOUD_API_KEY');

    if (missing.isNotEmpty) {
      throw Exception(
        'Chaves de API faltando: ${missing.join(", ")}\n'
        'Configure o arquivo .env com suas chaves.'
      );
    }
  }

  /// Verificar se está em modo debug
  static bool get isDebug => debugMode;

  /// Verificar se está em produção
  static bool get isProduction => environment == 'production';
}
```

---

## Código Flutter - Main

### Arquivo: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente
  await EnvConfig.initialize();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ClickforShineApp());
}

class ClickforShineApp extends StatelessWidget {
  const ClickforShineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickforShine',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### Arquivo: `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema Dark Mode Premium para ClickforShine
class AppTheme {
  // Paleta de cores
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF333333);
  static const Color gold = Color(0xFFD4AF37);
  static const Color cobaltBlue = Color(0xFF2E5EAA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xFFB3B3B3);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: black,
      appBarTheme: AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: gold,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.montserrat(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          color: white70,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gold),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: black,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

---

## SmartShine Algorithm

### Arquivo: `lib/domain/usecases/smartshine_algorithm.dart`

```dart
import 'dart:math';

/// SmartShine Algorithm - Cálculo de Agressividade
/// 
/// Fórmula: Agressividade = (S × 0.4) + (D × 0.6)
/// Onde:
/// - S = Dureza da Superfície (1-10)
/// - D = Nível de Dano (1-10)
class SmartShineAlgorithm {
  /// Calcula agressividade baseado em dureza e dano
  static double calculateAggressiveness({
    required double hardness,      // 1-10
    required double damageLevel,   // 1-10
  }) {
    // Validar entrada
    hardness = hardness.clamp(1.0, 10.0);
    damageLevel = damageLevel.clamp(1.0, 10.0);

    // Fórmula: Agressividade = (S × 0.4) + (D × 0.6)
    final aggressiveness = (hardness * 0.4) + (damageLevel * 0.6);

    return aggressiveness.clamp(1.0, 10.0);
  }

  /// Gera recomendação de setup baseado em agressividade
  static SetupRecommendation getSetupRecommendation({
    required double aggressiveness,
    required String sector,
  }) {
    if (aggressiveness > 7) {
      return _getHeavyCutSetup(sector);
    } else if (aggressiveness > 4) {
      return _getMediumCutSetup(sector);
    } else {
      return _getLightPolishSetup(sector);
    }
  }

  /// Setup para corte pesado (agressividade > 7)
  static SetupRecommendation _getHeavyCutSetup(String sector) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return SetupRecommendation(
          rpmMin: 1800,
          rpmMax: 2500,
          padType: 'Lã Natural',
          compoundType: 'Compound Cut - Rupes',
          safetyIndex: 6.0,
          estimatedTime: 45,
          warnings: [
            'AVISO: Não exceder 2500 RPM',
            'Monitorar temperatura da superfície',
            'Usar proteção adequada',
          ],
        );
      case 'marine':
        return SetupRecommendation(
          rpmMin: 1200,
          rpmMax: 1800,
          padType: 'Lã Marinha',
          compoundType: 'Marine Cut - Rupes',
          safetyIndex: 7.0,
          estimatedTime: 60,
          warnings: [
            'CRÍTICO: Gel Coat é extremamente duro',
            'Risco de queimadura em RPM alto',
            'Usar água para resfriar',
          ],
        );
      case 'aerospace':
        return SetupRecommendation(
          rpmMin: 800,
          rpmMax: 1200,
          padType: 'Espuma Especial Aeronáutica',
          compoundType: 'Aerospace Cut - 3M',
          safetyIndex: 9.0,
          estimatedTime: 90,
          warnings: [
            'CRÍTICO: Área de fuselagem sensível',
            'Não remover mais de 0.5mm de material',
            'Inspeção obrigatória após polimento',
          ],
        );
      case 'industrial':
        return SetupRecommendation(
          rpmMin: 2000,
          rpmMax: 3400,
          padType: 'Lã Industrial',
          compoundType: 'Industrial Cut - Sonax',
          safetyIndex: 5.0,
          estimatedTime: 30,
          warnings: [
            'Usar EPI completo',
            'Ventilação adequada',
          ],
        );
      default:
        return SetupRecommendation(
          rpmMin: 1200,
          rpmMax: 1800,
          padType: 'Espuma Média',
          compoundType: 'Compound Cut',
          safetyIndex: 6.0,
          estimatedTime: 45,
          warnings: [],
        );
    }
  }

  /// Setup para corte médio (4 < agressividade <= 7)
  static SetupRecommendation _getMediumCutSetup(String sector) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return SetupRecommendation(
          rpmMin: 1200,
          rpmMax: 1600,
          padType: 'Espuma Média',
          compoundType: 'Compound Refino - Koch-Chemie',
          safetyIndex: 7.0,
          estimatedTime: 35,
          warnings: [],
        );
      case 'marine':
        return SetupRecommendation(
          rpmMin: 800,
          rpmMax: 1200,
          padType: 'Espuma Marinha',
          compoundType: 'Marine Refino - Koch-Chemie',
          safetyIndex: 8.0,
          estimatedTime: 45,
          warnings: [],
        );
      case 'aerospace':
        return SetupRecommendation(
          rpmMin: 600,
          rpmMax: 900,
          padType: 'Espuma Fina Aeronáutica',
          compoundType: 'Aerospace Refino - 3M',
          safetyIndex: 8.5,
          estimatedTime: 60,
          warnings: [],
        );
      case 'industrial':
        return SetupRecommendation(
          rpmMin: 1500,
          rpmMax: 2200,
          padType: 'Espuma Industrial',
          compoundType: 'Industrial Refino',
          safetyIndex: 7.0,
          estimatedTime: 25,
          warnings: [],
        );
      default:
        return SetupRecommendation(
          rpmMin: 1000,
          rpmMax: 1400,
          padType: 'Espuma Média',
          compoundType: 'Compound Refino',
          safetyIndex: 7.0,
          estimatedTime: 35,
          warnings: [],
        );
    }
  }

  /// Setup para lustro leve (agressividade <= 4)
  static SetupRecommendation _getLightPolishSetup(String sector) {
    switch (sector.toLowerCase()) {
      case 'automotive':
        return SetupRecommendation(
          rpmMin: 800,
          rpmMax: 1200,
          padType: 'Espuma Fina',
          compoundType: 'Lustro Premium - Meguiar\'s',
          safetyIndex: 9.0,
          estimatedTime: 20,
          warnings: [],
        );
      case 'marine':
        return SetupRecommendation(
          rpmMin: 600,
          rpmMax: 900,
          padType: 'Microfibra Marinha',
          compoundType: 'Marine Lustro - Gyeon',
          safetyIndex: 9.5,
          estimatedTime: 25,
          warnings: [],
        );
      case 'aerospace':
        return SetupRecommendation(
          rpmMin: 500,
          rpmMax: 700,
          padType: 'Microfibra Aeronáutica',
          compoundType: 'Aerospace Lustro - Carpro',
          safetyIndex: 9.5,
          estimatedTime: 30,
          warnings: [],
        );
      case 'industrial':
        return SetupRecommendation(
          rpmMin: 1000,
          rpmMax: 1500,
          padType: 'Microfibra',
          compoundType: 'Industrial Lustro',
          safetyIndex: 9.0,
          estimatedTime: 15,
          warnings: [],
        );
      default:
        return SetupRecommendation(
          rpmMin: 800,
          rpmMax: 1200,
          padType: 'Espuma Fina',
          compoundType: 'Lustro',
          safetyIndex: 9.0,
          estimatedTime: 20,
          warnings: [],
        );
    }
  }
}

/// Recomendação de Setup
class SetupRecommendation {
  final int rpmMin;
  final int rpmMax;
  final String padType;
  final String compoundType;
  final double safetyIndex;
  final int estimatedTime;
  final List<String> warnings;

  SetupRecommendation({
    required this.rpmMin,
    required this.rpmMax,
    required this.padType,
    required this.compoundType,
    required this.safetyIndex,
    required this.estimatedTime,
    required this.warnings,
  });

  String get rpmRange => '$rpmMin-$rpmMax RPM';
}
```

---

## Expert Chat Integration

### Arquivo: `lib/data/datasources/expert_chat_datasource.dart`

```dart
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

/// Expert Chat Datasource com Streaming
class ExpertChatDatasource {
  final Dio _dio;
  static const String _openaiBaseUrl = 'https://api.openai.com/v1';

  ExpertChatDatasource({Dio? dio}) : _dio = dio ?? Dio();

  /// Chat com streaming
  Stream<String> chatWithStreaming({
    required String userMessage,
    required String surfaceType,
    required String sector,
    required List<String> defects,
    required double hardness,
    required double damage,
  }) async* {
    try {
      if (EnvConfig.openaiApiKey.isEmpty) {
        yield 'Erro: OpenAI API key não configurada';
        return;
      }

      final systemPrompt = _buildSystemPrompt(
        surfaceType: surfaceType,
        sector: sector,
        defects: defects,
        hardness: hardness,
        damage: damage,
      );

      final response = await _dio.post(
        '$_openaiBaseUrl/chat/completions',
        data: {
          'model': 'gpt-4o',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 1500,
          'stream': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${EnvConfig.openaiApiKey}',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for (final chunk in stream) {
        buffer += utf8.decode(chunk);
        final lines = buffer.split('\n');
        buffer = lines.last;

        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();
          if (line.isEmpty || line == 'data: [DONE]') continue;

          if (line.startsWith('data: ')) {
            try {
              final jsonStr = line.substring(6);
              final json = jsonDecode(jsonStr);
              final delta = json['choices']?[0]?['delta'];
              if (delta != null && delta['content'] != null) {
                yield delta['content'];
              }
            } catch (e) {
              // Ignorar erros de parsing
            }
          }
        }
      }
    } catch (e) {
      yield 'Erro ao conectar com o chat: $e';
    }
  }

  /// Construir system prompt com contexto técnico
  String _buildSystemPrompt({
    required String surfaceType,
    required String sector,
    required List<String> defects,
    required double hardness,
    required double damage,
  }) {
    return '''Você é um Master Detailer internacional com 20+ anos de experiência.

CONTEXTO TÉCNICO:
- Superfície: $surfaceType
- Setor: $sector
- Defeitos: ${defects.join(', ')}
- Dureza: $hardness/10
- Dano: $damage/10

PERSONALIDADE:
- Técnico, direto, educado
- Especialista em Rupes, Koch-Chemie, 3M, Meguiar's
- Foco em segurança e preservação
- Português técnico

RESPONDA COM:
- Base técnica sólida
- Justificativas científicas
- Alertas de segurança quando necessário
- Alternativas seguras''';
  }
}
```

---

## Admin Panel Web

### Arquivo: `lib/presentation/pages/admin_panel_web.dart`

```dart
import 'package:flutter/material.dart';

/// Admin Panel Web para gerenciar banco de dados
class AdminPanelWeb extends StatefulWidget {
  const AdminPanelWeb({Key? key}) : super(key: key);

  @override
  State<AdminPanelWeb> createState() => _AdminPanelWebState();
}

class _AdminPanelWebState extends State<AdminPanelWeb> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClickforShine - Admin Panel'),
        backgroundColor: const Color(0xFF000000),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: const Color(0xFF1A1A1A),
            child: ListView(
              children: [
                _buildSidebarItem(0, '📊 Dashboard', Icons.dashboard),
                _buildSidebarItem(1, '💎 Vernizes', Icons.palette),
                _buildSidebarItem(2, '⚙️ RPM Presets', Icons.settings),
                _buildSidebarItem(3, '🧪 Compostos', Icons.science),
                _buildSidebarItem(4, '🎨 Pads', Icons.category),
                _buildSidebarItem(5, '⚠️ Alertas', Icons.warning),
              ],
            ),
          ),
          // Conteúdo
          Expanded(
            child: Container(
              color: const Color(0xFF000000),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF000000) : const Color(0xFFD4AF37)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF000000) : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildVarnishManager();
      case 2:
        return _buildRpmPresetsManager();
      case 3:
        return _buildCompoundsManager();
      case 4:
        return _buildPadsManager();
      case 5:
        return _buildAlertsManager();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard('Vernizes', '24'),
              _buildStatCard('Compostos', '18'),
              _buildStatCard('Pads', '12'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildVarnishManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Vernizes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Tipo', 'Dureza', 'Setor', 'Ações'],
            rows: [
              ['Clear Coat Soft', '4', 'Automotivo', '✏️ 🗑️'],
              ['Gel Coat ISO', '9', 'Náutico', '✏️ 🗑️'],
              ['PU Aeronáutico', '8', 'Aeronáutico', '✏️ 🗑️'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRpmPresetsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Presets de RPM',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Setor', 'Agressividade', 'RPM Min', 'RPM Max', 'Ações'],
            rows: [
              ['Automotivo', 'Baixa', '800', '1200', '✏️ 🗑️'],
              ['Náutico', 'Média', '600', '1200', '✏️ 🗑️'],
              ['Aeronáutico', 'Alta', '500', '1000', '✏️ 🗑️'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompoundsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Compostos',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Nome', 'Marca', 'Abrasividade', 'Ações'],
            rows: [
              ['Compound Cut', 'Rupes', 'Alta', '✏️ 🗑️'],
              ['Marine Cut', 'Koch-Chemie', 'Alta', '✏️ 🗑️'],
              ['Lustro Premium', '3M', 'Baixa', '✏️ 🗑️'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPadsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Pads',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Nome', 'Material', 'Dureza', 'Ações'],
            rows: [
              ['Espuma Fina', 'Espuma', 'Macia', '✏️ 🗑️'],
              ['Lã Natural', 'Lã', 'Dura', '✏️ 🗑️'],
              ['Microfibra', 'Microfibra', 'Macia', '✏️ 🗑️'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsManager() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerenciar Alertas',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 24),
          _buildDataTable(
            columns: ['Alerta', 'Setor', 'Nível', 'Ações'],
            rows: [
              ['Não exceder 2500 RPM', 'Automotivo', 'Crítico', '✏️ 🗑️'],
              ['Risco de corrosão', 'Náutico', 'Alto', '✏️ 🗑️'],
              ['Proteger áreas críticas', 'Aeronáutico', 'Crítico', '✏️ 🗑️'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable({
    required List<String> columns,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: columns.map((col) {
                return Expanded(
                  child: Text(
                    col,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ...rows.map((row) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF333333))),
              ),
              child: Row(
                children: row.map((cell) {
                  return Expanded(
                    child: Text(
                      cell,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
```

---

## Segurança e Secrets

### Arquivo: `.github/workflows/main.yml` - Secrets Configuration

```yaml
# ADICIONE ESTES SECRETS NO GITHUB:
# Settings → Secrets and variables → Actions → New repository secret

# 1. OPENAI_API_KEY
#    Valor: sk-proj-xxxxxxxxxxxxx
#    Fonte: https://platform.openai.com/account/api-keys

# 2. AZURE_VISION_KEY
#    Valor: sua_chave_azure
#    Fonte: https://portal.azure.com

# 3. GOOGLE_CLOUD_API_KEY
#    Valor: sua_chave_google
#    Fonte: https://console.cloud.google.com

# 4. FIREBASE_API_KEY
#    Valor: sua_chave_firebase
#    Fonte: https://console.firebase.google.com

# COMO ADICIONAR:
# 1. Vá para seu repositório GitHub
# 2. Settings → Secrets and variables → Actions
# 3. Clique em "New repository secret"
# 4. Nome: OPENAI_API_KEY
# 5. Valor: sk-proj-xxxxxxxxxxxxx
# 6. Clique em "Add secret"
# 7. Repita para outras chaves
```

### Arquivo: `pubspec.yaml` - Dependências

```yaml
name: clickforshine
description: ClickforShine - Plataforma de Diagnóstico de Polimento
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Networking
  dio: ^5.3.1
  
  # Environment
  flutter_dotenv: ^5.1.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.14.0
  
  # UI
  google_fonts: ^6.1.0
  
  # State Management
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
  
  # Utils
  uuid: ^4.0.0
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  vitest: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - .env
```

---

## 📝 Resumo de Implementação

### Passo 1: Copiar Arquivos
1. Copie `.github/workflows/main.yml` para seu repositório
2. Copie `lib/` arquivos para seu projeto
3. Copie `pubspec.yaml` com dependências

### Passo 2: Configurar Secrets no GitHub
1. Vá para Settings → Secrets
2. Adicione: OPENAI_API_KEY, AZURE_VISION_KEY, etc.

### Passo 3: Fazer Push
```bash
git add .
git commit -m "Add ClickforShine complete implementation"
git push origin main
```

### Passo 4: GitHub Actions Compila Automaticamente
- APK gerado em ~15 minutos
- IPA gerado em ~20 minutos
- Baixe dos Artifacts ou Releases

---

**Pronto para copiar e usar! 🚀**
