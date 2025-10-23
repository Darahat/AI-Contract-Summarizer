# ClauseWise Architecture

## Overview

ClauseWise is built using Flutter with a clean, modular architecture that separates concerns and promotes maintainability.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens, Widgets, UI Components)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         State Management Layer          │
│    (Riverpod Providers & Notifiers)     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Service Layer                 │
│  (Business Logic & External APIs)       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Layer                   │
│    (Models, Local Storage, Cache)       │
└─────────────────────────────────────────┘
```

## Layer Details

### 1. Presentation Layer (`lib/screens`, `lib/widgets`)

**Screens:**
- `SplashScreen`: App launch screen with branding
- `HomeScreen`: Main dashboard showing contract list
- `UploadScreen`: Document upload interface
- `ContractDetailScreen`: Detailed view of analyzed contract
- `SubscriptionScreen`: Subscription plan management
- `SettingsScreen`: App configuration

**Widgets:**
- `ContractCard`: Reusable contract list item
- Custom UI components following Material Design 3

**Responsibilities:**
- Display data to users
- Handle user interactions
- Navigate between screens
- Consume state from providers

### 2. State Management Layer (`lib/providers`)

Using **Riverpod** for dependency injection and state management.

**Key Providers:**

```dart
// Service Providers
documentServiceProvider
contractStorageServiceProvider
encryptionServiceProvider
aiServiceProvider

// State Providers
contractsProvider        // List of contracts
subscriptionProvider     // User subscription
currentContractProvider  // Currently viewed contract
apiKeyProvider          // Stored API key
```

**Responsibilities:**
- Manage application state
- Coordinate between services
- Handle async operations
- Provide data to UI

### 3. Service Layer (`lib/services`)

**AIService** (`ai_service.dart`)
- Integrates with OpenAI/Mistral APIs
- Generates contract summaries
- Detects risky clauses
- Explains legal terms

**EncryptionService** (`encryption_service.dart`)
- AES encryption/decryption
- Hash generation
- Content verification

**DocumentService** (`document_service.dart`)
- File picking
- Text extraction (PDF, DOC, DOCX, TXT)
- File validation

**ContractStorageService** (`contract_storage_service.dart`)
- Hive database operations
- Contract CRUD operations
- Subscription management
- Usage tracking

**Responsibilities:**
- Implement business logic
- Interact with external APIs
- Handle data persistence
- Provide reusable functionality

### 4. Data Layer (`lib/models`)

**Models:**

```dart
Contract
├── id: String
├── fileName: String
├── filePath: String
├── uploadDate: DateTime
├── summary: String?
├── riskyClause: List<RiskClause>
├── encryptedContent: String
└── status: ContractStatus

RiskClause
├── type: String (payment/liability/IP)
├── clauseText: String
├── explanation: String
├── riskLevel: RiskLevel
└── recommendation: String

UserSubscription
├── plan: SubscriptionPlan (free/pro)
├── expiryDate: DateTime?
├── documentsUsedThisMonth: int
├── lastResetDate: DateTime
└── isActive: bool
```

**Responsibilities:**
- Define data structures
- Provide JSON serialization
- Include Hive type adapters
- Implement business rules

## Data Flow

### Upload Flow

```
User selects file
       ↓
DocumentService picks file
       ↓
DocumentService extracts text
       ↓
EncryptionService encrypts content
       ↓
Contract created and saved
       ↓
AIService processes contract
       ↓
Summary & risks detected
       ↓
Contract updated with results
       ↓
UI refreshed
```

### State Updates Flow

```
User action (e.g., upload contract)
       ↓
UI calls provider method
       ↓
Provider calls service
       ↓
Service performs operation
       ↓
Service updates local storage
       ↓
Provider updates state
       ↓
UI automatically rebuilds
```

## Security Architecture

### Encryption Flow

```
Document uploaded
       ↓
Text extracted
       ↓
AES encryption applied
       ↓
Encrypted content stored in Hive
       ↓
Original text sent to AI (temporary)
       ↓
Analysis results stored (plain text)
```

### API Key Storage

```
User enters API key
       ↓
Key encrypted by EncryptionService
       ↓
Stored in secure Hive box
       ↓
Decrypted on use
       ↓
Used for direct API calls
```

## Dependency Graph

```
main.dart
  ├── ProviderScope (Riverpod)
  │   ├── contractsProvider
  │   │   ├── ContractStorageService
  │   │   ├── DocumentService
  │   │   ├── EncryptionService
  │   │   └── AIService
  │   │
  │   └── subscriptionProvider
  │       └── ContractStorageService
  │
  └── ClauseWiseApp
      └── MaterialApp
          ├── SplashScreen
          └── HomeScreen
              ├── UploadScreen
              ├── ContractDetailScreen
              ├── SubscriptionScreen
              └── SettingsScreen
```

## Design Patterns

### 1. Provider Pattern
- Dependency injection via Riverpod
- State management with StateNotifier
- Reactive UI updates

### 2. Repository Pattern
- ContractStorageService acts as repository
- Abstracts data source (Hive)
- Single source of truth

### 3. Service Layer Pattern
- Business logic separated from UI
- Reusable services
- Easy to test

### 4. Observer Pattern
- Riverpod providers notify consumers
- Automatic UI updates
- Efficient rebuilds

## Testing Strategy

### Unit Tests
- Model serialization/deserialization
- Service logic (encryption, AI parsing)
- Business rules validation

### Widget Tests
- Screen rendering
- User interactions
- Navigation flows

### Integration Tests
- End-to-end workflows
- Service integration
- Storage operations

## Performance Considerations

1. **Lazy Loading**: Contracts loaded on demand
2. **Pagination**: Large lists paginated
3. **Caching**: Hive provides fast local storage
4. **Async Operations**: Heavy operations run asynchronously
5. **State Optimization**: Only affected widgets rebuild

## Scalability

### Current Limits
- Local storage limited by device capacity
- No cloud backup
- Single user per device

### Future Enhancements
- Cloud sync
- Multi-device support
- Team collaboration
- Offline-first architecture

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Riverpod 2.4+
- **Local Storage**: Hive 2.2+
- **HTTP Client**: Dio 5.4+
- **Encryption**: encrypt 5.0+
- **UI**: Material Design 3

## Best Practices

1. **Separation of Concerns**: Each layer has specific responsibilities
2. **Dependency Injection**: Services injected via providers
3. **Immutability**: Models are immutable with copyWith
4. **Type Safety**: Strong typing throughout
5. **Error Handling**: Try-catch with user-friendly messages
6. **Code Generation**: Hive adapters generated automatically
7. **Documentation**: Comprehensive inline documentation
