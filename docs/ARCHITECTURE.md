# Architecture Documentation

## Overview

The AI Contract Summarizer follows **Clean Architecture** principles with **Riverpod** for state management. This architecture ensures:
- Separation of concerns
- Testability
- Maintainability
- Scalability

## Architectural Layers

### 1. Presentation Layer
**Location:** `lib/features/*/presentation/`

**Responsibilities:**
- UI components (screens, widgets)
- User interaction handling
- Display data from state

**Example:**
```dart
// lib/features/auth/presentation/login_screen.dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: authState.isLoading 
        ? CircularProgressIndicator()
        : LoginForm(),
    );
  }
}
```

### 2. Application Layer
**Location:** `lib/features/*/application/`

**Responsibilities:**
- Business logic coordination
- State management (Notifiers)
- Orchestrating data flow

**Example:**
```dart
// lib/features/document/application/document_notifier.dart
class DocumentNotifier extends StateNotifier<DocumentState> {
  final DocumentRepository _repository;
  
  Future<void> uploadDocument(String path) async {
    state = state.copyWith(isLoading: true);
    final doc = await _repository.uploadDocument(path);
    state = state.copyWith(document: doc, isLoading: false);
  }
}
```

### 3. Domain Layer
**Location:** `lib/features/*/domain/`

**Responsibilities:**
- Business entities
- Domain models
- Core business rules

**Example:**
```dart
// lib/features/document/domain/document_model.dart
class DocumentModel {
  final String id;
  final String fileName;
  final List<RiskyClause> riskyClauses;
  
  bool get hasHighRiskClauses => 
    riskyClauses.any((c) => c.riskLevel == RiskLevel.high);
}
```

### 4. Data Layer
**Location:** `lib/features/*/data/`

**Responsibilities:**
- Data source interaction
- API calls
- Local storage operations
- Data transformation

**Example:**
```dart
// lib/features/document/data/document_repository.dart
class DocumentRepository {
  final AIService _aiService;
  final FileStorageService _storage;
  
  Future<DocumentModel> uploadDocument(String path) async {
    final file = await _storage.readFile(path);
    final analysis = await _aiService.analyzeDocument(file);
    return DocumentModel.fromAnalysis(analysis);
  }
}
```

### 5. Core Layer
**Location:** `lib/core/`

**Responsibilities:**
- Shared utilities
- Constants
- Common widgets
- Error handling

## State Management with Riverpod

### Provider Types

#### 1. Provider
For read-only objects that don't change:
```dart
final apiClientProvider = Provider<APIClient>((ref) {
  return APIClient(baseUrl: 'https://api.example.com');
});
```

#### 2. StateNotifierProvider
For mutable state with complex logic:
```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
```

#### 3. FutureProvider
For async operations:
```dart
final documentsProvider = FutureProvider<List<DocumentModel>>((ref) async {
  final repository = ref.watch(documentRepositoryProvider);
  return repository.getUserDocuments();
});
```

### State Flow

```
User Action (UI)
    ↓
Provider/Notifier
    ↓
Repository (Data Layer)
    ↓
External Service (API/Storage)
    ↓
Repository (Transform Data)
    ↓
Update State
    ↓
UI Rebuilds
```

## Dependency Injection

Riverpod handles DI automatically:

```dart
// Define dependencies
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final authRepoProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return AuthRepository(prefs);
});

// Override in main.dart
void main() async {
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: MyApp(),
    ),
  );
}
```

## Navigation

Using GoRouter for type-safe navigation:

```dart
// lib/router/app_router.dart
class AppRouter {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/upload',
        builder: (context, state) => UploadScreen(),
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) {
          final doc = state.extra as DocumentModel;
          return SummaryScreen(document: doc);
        },
      ),
    ],
  );
}

// Usage
context.go('/upload');
context.push('/summary', extra: document);
```

## Error Handling

Unified error handling with Failure classes:

```dart
// lib/core/error/failure.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// Usage in repository
try {
  final response = await _apiClient.post('/analyze');
  return DocumentModel.fromJson(response.data);
} on DioException catch (e) {
  throw ServerFailure('Failed to analyze document: ${e.message}');
}

// Handle in notifier
try {
  await _repository.uploadDocument(path);
} on ServerFailure catch (e) {
  state = state.copyWith(error: e.message);
}
```

## Testing Strategy

### Unit Tests
Test business logic in isolation:
```dart
void main() {
  group('DocumentNotifier', () {
    test('uploads document successfully', () async {
      final mockRepo = MockDocumentRepository();
      final notifier = DocumentNotifier(mockRepo);
      
      await notifier.uploadDocument('/path/to/file');
      
      expect(notifier.state.document, isNotNull);
      expect(notifier.state.isLoading, false);
    });
  });
}
```

### Widget Tests
Test UI components:
```dart
void main() {
  testWidgets('LoginScreen shows error message', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: LoginScreen()),
      ),
    );
    
    expect(find.text('Login'), findsOneWidget);
  });
}
```

### Integration Tests
Test complete features end-to-end.

## Project Structure Best Practices

### Feature Organization
```
features/
└── document/
    ├── data/              # Data layer
    │   ├── models/        # DTOs
    │   ├── repositories/  # Data sources
    │   └── services/      # External services
    ├── domain/            # Business logic
    │   ├── entities/      # Domain models
    │   └── repositories/  # Repository interfaces
    ├── application/       # Use cases
    │   └── notifiers/     # State management
    ├── presentation/      # UI
    │   ├── screens/
    │   └── widgets/
    └── providers/         # Riverpod providers
```

### File Naming Conventions
- Screens: `*_screen.dart` (e.g., `login_screen.dart`)
- Models: `*_model.dart` (e.g., `user_model.dart`)
- Repositories: `*_repository.dart`
- Providers: `*_provider.dart`
- Services: `*_service.dart`

## Performance Considerations

### 1. Lazy Loading
Load data only when needed:
```dart
final documentsProvider = FutureProvider.autoDispose((ref) async {
  // Automatically disposed when no longer used
  return await ref.watch(documentRepositoryProvider).getDocuments();
});
```

### 2. Caching
Cache expensive operations:
```dart
final userProvider = FutureProvider((ref) async {
  final cache = ref.watch(cacheProvider);
  return cache.get('user') ?? await fetchUser();
});
```

### 3. State Optimization
Use `select` to rebuild only when specific fields change:
```dart
final isLoading = ref.watch(authProvider.select((state) => state.isLoading));
```

## Security Best Practices

1. **Encryption**: Encrypt sensitive data at rest
2. **Secure Storage**: Use flutter_secure_storage for keys
3. **API Keys**: Never hardcode, use environment variables
4. **Input Validation**: Validate all user inputs
5. **Error Messages**: Don't expose sensitive info in errors

## Scalability

The architecture supports:
- Adding new features without affecting existing ones
- Replacing implementations (e.g., switching AI providers)
- Horizontal scaling (multiple data sources)
- Team collaboration (clear boundaries)

## Resources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
