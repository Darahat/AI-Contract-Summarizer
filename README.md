# AI Contract Summarizer 📄

An AI-powered contract analysis and summarization tool built with Flutter, designed to help users understand complex legal documents through intelligent analysis, risk detection, and plain-English explanations.

## ✨ Features

### MVP Features (Implemented)
- **📤 Upload Contracts**: Upload PDF/DOCX contracts or paste text directly
- **🧠 AI Summarization**: Automatically summarize contracts into clear bullet points
- **⚠️ Risk Detection**: Identify and highlight risky clauses (payment terms, termination, indemnity, liability, IP ownership)
- **💬 Clause Explanation**: Tap on any clause to get plain English explanations
- **🧾 Save & History**: Securely store and manage previously analyzed documents
- **🔒 Local Encryption**: On-device encryption for sensitive documents
- **💸 Subscription Model**: Free tier (2 files/month) + Pro plan ($10–15/month)

### Future Enhancements
- **🪄 Smart Recommendations**: AI-suggested edits and safer alternatives
- **🗂️ Multi-document Comparison**: Compare two contracts side-by-side
- **☁️ Cloud Sync**: Sync documents across devices
- **💬 Chat-style Q&A**: Ask AI questions about any clause

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **Riverpod** for state management, ensuring scalability, testability, and maintainability.

### Project Structure

```
lib/
 ├── core/
 │    ├── constants/
 │    │    └── app_colors.dart           # App-wide color constants
 │    ├── error/
 │    │    └── failure.dart              # Error handling classes
 │    ├── utils/
 │    │    └── file_utils.dart           # File operation utilities
 │    └── widgets/
 │         └── custom_button.dart        # Reusable UI components
 │
 ├── features/
 │    ├── auth/
 │    │    ├── data/
 │    │    │    └── auth_repository.dart
 │    │    ├── domain/
 │    │    │    └── user_model.dart
 │    │    ├── presentation/
 │    │    │    ├── login_screen.dart
 │    │    │    └── signup_screen.dart
 │    │    └── providers/
 │    │         └── auth_provider.dart
 │    │
 │    ├── document/
 │    │    ├── data/
 │    │    │    ├── document_repository.dart
 │    │    │    └── ai_service.dart      # OpenAI/AI API integration
 │    │    ├── domain/
 │    │    │    └── document_model.dart
 │    │    ├── application/
 │    │    │    └── document_notifier.dart
 │    │    ├── presentation/
 │    │    │    ├── upload_screen.dart
 │    │    │    ├── summary_screen.dart
 │    │    │    └── risk_highlight_screen.dart
 │    │    └── providers/
 │    │         └── document_provider.dart
 │    │
 │    └── settings/
 │         └── presentation/
 │              └── settings_screen.dart
 │
 ├── services/
 │    ├── api_client.dart               # HTTP client wrapper
 │    ├── file_storage_service.dart     # Local file storage
 │    └── encryption_service.dart       # Data encryption
 │
 ├── router/
 │    └── app_router.dart               # Navigation configuration
 │
 ├── theme/
 │    └── app_theme.dart                # Theme configuration
 │
 └── main.dart                          # Application entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for mobile development
- VS Code or Android Studio with Flutter plugins

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Darahat/AI-Contract-Summarizer.git
   cd AI-Contract-Summarizer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **API Keys**: Configure your AI service API keys
   - Create a `.env` file in the root directory
   - Add your API credentials:
     ```
     OPENAI_API_KEY=your_openai_api_key
     # or
     HUGGINGFACE_API_KEY=your_huggingface_api_key
     ```

2. **Encryption**: The app uses AES encryption for local data
   - Default passphrase is used for demo purposes
   - In production, use secure key storage (e.g., flutter_secure_storage)

## 📦 Dependencies

### Core Dependencies
- **flutter_riverpod**: State management
- **go_router**: Navigation and routing
- **dio**: HTTP client for API requests
- **hive**: Local database
- **shared_preferences**: Simple key-value storage

### File Handling
- **file_picker**: File selection
- **path_provider**: File system access
- **pdf**: PDF processing
- **syncfusion_flutter_pdf**: Advanced PDF features

### Security
- **encrypt**: Data encryption
- **crypto**: Cryptographic operations

### AI/ML
- **google_generative_ai**: Google AI integration

## 🔐 Security Features

- **Local Encryption**: All stored documents are encrypted using AES-256
- **Secure Storage**: Sensitive data stored with platform-specific security
- **No External Storage**: Documents stay on device by default
- **Auth Token Management**: Secure authentication flow

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⏳ Web (Coming soon)
- ⏳ Desktop (Coming soon)

## 🎨 UI/UX

The app features a modern, clean interface with:
- Material Design 3
- Custom color scheme optimized for readability
- Smooth animations and transitions
- Responsive layouts for different screen sizes
- Accessibility support

## 🛠️ Development

### Code Generation
Some features use code generation. Run the build runner when needed:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
Check code quality:
```bash
flutter analyze
```

### Formatting
Format code:
```bash
dart format lib/
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support, email support@aicontractsummarizer.com or open an issue on GitHub.

## 🙏 Acknowledgments

- OpenAI for GPT models
- Flutter team for the amazing framework
- Riverpod community for state management patterns

---

**Made with ❤️ using Flutter**