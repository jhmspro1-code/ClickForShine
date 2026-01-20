# Arquitetura Clean Architecture - ClickforShine

## 📐 Visão Geral

ClickforShine segue os princípios de **Clean Architecture** para garantir:
- ✅ Separação de responsabilidades
- ✅ Testabilidade
- ✅ Manutenibilidade
- ✅ Escalabilidade
- ✅ Independência de frameworks

## 🏗️ Camadas

### 1. Domain Layer (Lógica de Negócio)

**Responsabilidade**: Conter a lógica de negócio pura, independente de qualquer framework.

```
lib/domain/
├── entities/              # Objetos de domínio
│   ├── surface_entity.dart
│   └── correction_entity.dart
├── repositories/          # Interfaces abstratas
│   ├── surface_repository.dart
│   └── diagnostic_repository.dart
└── usecases/             # Casos de uso
    ├── calculate_aggressiveness_usecase.dart
    ├── analyze_surface_usecase.dart
    └── save_diagnostic_usecase.dart
```

**Exemplo**:

```dart
// lib/domain/usecases/calculate_aggressiveness_usecase.dart

/// Use case puro - sem dependências de Firebase, Flutter, etc
class CalculateAggressivenessUseCase {
  AggressivenessResult call({
    required double surfaceHardness,
    required double damageLevel,
    required String sector,
  }) {
    // Lógica pura: Agressividade = (S * 0.4) + (D * 0.6)
    final aggressivenessScore = (surfaceHardness * 0.4) + (damageLevel * 0.6);
    
    // ... retorna resultado
  }
}
```

**Características**:
- ✅ Sem imports de `flutter`
- ✅ Sem imports de `firebase`
- ✅ Sem imports de `package:riverpod`
- ✅ Totalmente testável com `flutter test`

### 2. Data Layer (Camada de Dados)

**Responsabilidade**: Implementar as interfaces de repositório e gerenciar dados.

```
lib/data/
├── datasources/          # Fontes de dados
│   ├── remote/
│   │   ├── firebase_compound_datasource.dart
│   │   └── firebase_diagnostic_datasource.dart
│   └── local/
│       └── local_storage_datasource.dart
├── models/              # Modelos de dados (com serialização)
│   ├── compound_model.dart
│   ├── pad_model.dart
│   └── diagnostic_model.dart
└── repositories/        # Implementações concretas
    ├── surface_repository_impl.dart
    └── diagnostic_repository_impl.dart
```

**Exemplo**:

```dart
// lib/data/repositories/diagnostic_repository_impl.dart

/// Implementação concreta do repositório
class DiagnosticRepositoryImpl implements DiagnosticRepository {
  final FirebaseFirestore _firestore;
  final LocalStorageDatasource _localStorage;

  DiagnosticRepositoryImpl(this._firestore, this._localStorage);

  @override
  Future<void> saveDiagnostic(DiagnosticEntity diagnostic) async {
    try {
      // Salvar no Firestore
      await _firestore
          .collection('diagnostics')
          .doc(diagnostic.id)
          .set(DiagnosticModel.fromEntity(diagnostic).toJson());
      
      // Cache local
      await _localStorage.cacheDiagnostic(diagnostic);
    } catch (e) {
      throw RepositoryException('Erro ao salvar diagnóstico: $e');
    }
  }
}
```

**Características**:
- ✅ Implementa interfaces do Domain
- ✅ Gerencia Firebase, APIs, banco local
- ✅ Trata erros e exceções
- ✅ Converte modelos (Model ↔ Entity)

### 3. Presentation Layer (UI)

**Responsabilidade**: Renderizar UI e gerenciar estado.

```
lib/presentation/
├── bloc/               # Gerenciamento de estado (BLoC/Riverpod)
│   ├── diagnostic_provider.dart
│   └── camera_provider.dart
├── pages/             # Páginas/Telas
│   ├── home_page.dart
│   ├── camera_page.dart
│   ├── result_page.dart
│   └── admin_panel.dart
└── widgets/           # Widgets reutilizáveis
    ├── hardness_chart.dart
    ├── camera_analyzer_view.dart
    ├── glass_card.dart
    └── safety_alert.dart
```

**Exemplo com Riverpod**:

```dart
// lib/presentation/bloc/diagnostic_provider.dart

/// Provider para gerenciar estado de diagnóstico
final diagnosticProvider = StateNotifierProvider<
  DiagnosticNotifier,
  AsyncValue<DiagnosticState>
>((ref) {
  final repository = ref.watch(diagnosticRepositoryProvider);
  return DiagnosticNotifier(repository);
});

class DiagnosticNotifier extends StateNotifier<AsyncValue<DiagnosticState>> {
  final DiagnosticRepository _repository;

  DiagnosticNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> performDiagnostic(SurfaceEntity surface) async {
    state = const AsyncValue.loading();
    
    try {
      final result = await _repository.analyzeSurface(surface);
      state = AsyncValue.data(DiagnosticState(result: result));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
```

**Características**:
- ✅ Depende de Domain e Data layers
- ✅ Gerencia estado com Riverpod
- ✅ Renderiza widgets
- ✅ Responde a eventos do usuário

## 🔄 Fluxo de Dados

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  (Widgets, Pages, Riverpod Providers)                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                        │
│  (Use Cases, Entities, Repository Interfaces)           │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                       DATA LAYER                         │
│  (Repository Implementations, DataSources, Models)      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────────┐
        │  Firebase / APIs / Storage │
        └────────────────────────────┘
```

## 📊 Exemplo Completo: Diagnóstico

### 1. User Action (Presentation)

```dart
// lib/presentation/pages/camera_page.dart
onPhotoCapture(XFile image) {
  ref.read(diagnosticProvider.notifier).performDiagnostic(image);
}
```

### 2. State Management (Presentation)

```dart
// lib/presentation/bloc/diagnostic_provider.dart
Future<void> performDiagnostic(XFile image) async {
  final useCase = ref.read(calculateAggressivenessUseCaseProvider);
  final surface = await _analyzeSurface(image);
  final result = useCase(
    surfaceHardness: surface.hardnessScore,
    damageLevel: surface.calculateDamageLevel(),
    sector: surface.sector.name,
  );
}
```

### 3. Use Case (Domain)

```dart
// lib/domain/usecases/calculate_aggressiveness_usecase.dart
AggressivenessResult call({
  required double surfaceHardness,
  required double damageLevel,
  required String sector,
}) {
  final aggressivenessScore = (surfaceHardness * 0.4) + (damageLevel * 0.6);
  // ... lógica pura de negócio
}
```

### 4. Repository (Data)

```dart
// lib/data/repositories/diagnostic_repository_impl.dart
Future<void> saveDiagnostic(DiagnosticEntity diagnostic) async {
  await _firestore.collection('diagnostics').add(
    DiagnosticModel.fromEntity(diagnostic).toJson()
  );
}
```

### 5. Data Source (Data)

```dart
// lib/data/datasources/firebase_diagnostic_datasource.dart
Future<void> saveDiagnostic(DiagnosticModel model) async {
  await _firestore.collection('diagnostics').add(model.toJson());
}
```

## 🧪 Testabilidade

### Teste de Use Case (Domain)

```dart
// test/domain/usecases/calculate_aggressiveness_usecase_test.dart

void main() {
  group('CalculateAggressivenessUseCase', () {
    late CalculateAggressivenessUseCase useCase;

    setUp(() {
      useCase = CalculateAggressivenessUseCase();
    });

    test('Deve calcular agressividade corretamente', () {
      final result = useCase(
        surfaceHardness: 7.0,
        damageLevel: 6.0,
        sector: 'automotive',
      );

      expect(result.aggressivenessScore, 6.4);
      expect(result.cuttingLevel, 2);
    });
  });
}
```

### Teste de Repository (Data)

```dart
// test/data/repositories/diagnostic_repository_impl_test.dart

void main() {
  group('DiagnosticRepositoryImpl', () {
    late DiagnosticRepositoryImpl repository;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      repository = DiagnosticRepositoryImpl(mockFirestore);
    });

    test('Deve salvar diagnóstico no Firestore', () async {
      final diagnostic = DiagnosticEntity(...);
      
      await repository.saveDiagnostic(diagnostic);
      
      verify(mockFirestore.collection('diagnostics').add(...)).called(1);
    });
  });
}
```

## 📦 Dependency Injection

Usar Riverpod para injeção de dependências:

```dart
// lib/data/repositories/providers.dart

final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

final diagnosticRepositoryProvider = Provider<DiagnosticRepository>((ref) {
  final firestore = ref.watch(firebaseProvider);
  return DiagnosticRepositoryImpl(firestore);
});

final calculateAggressivenessUseCaseProvider = Provider((ref) {
  return CalculateAggressivenessUseCase();
});
```

## 🎯 Benefícios

| Benefício | Descrição |
|-----------|-----------|
| **Testabilidade** | Use cases e repositories são fáceis de testar |
| **Manutenibilidade** | Código organizado e bem separado |
| **Escalabilidade** | Adicionar novos features sem quebrar código existente |
| **Reutilização** | Use cases podem ser usados em diferentes contextos |
| **Independência** | Trocar Firebase por outro backend sem afetar domain |

## 📚 Referências

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd)
- [Riverpod Documentation](https://riverpod.dev)

---

**Desenvolvido seguindo os melhores padrões da indústria**
