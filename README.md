# ClauseWise - AI Legal Companion

<div align="center">

![ClauseWise](https://img.shields.io/badge/ClauseWise-AI%20Legal%20Companion-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)

**Your AI-powered legal clarity for contracts**

</div>

## 🎯 Overview

ClauseWise is an AI-powered legal companion designed specifically for **freelancers and SMEs in developed markets**. Get quick, affordable legal clarity for your contracts without expensive lawyer consultations.

### Key Features

- 📄 **Contract Upload** - Support for PDF, DOC, DOCX, and TXT files
- 🤖 **AI-Powered Summaries** - Clear overviews of key terms and obligations using OpenAI/Mistral
- ⚠️ **Risk Detection** - Automatically identify risky clauses in:
  - Payment terms
  - Liability clauses
  - Intellectual Property rights
- 💡 **Simple Explanations** - Complex legal terms explained in plain English
- 🔒 **AES Encryption** - Your documents are encrypted and secure
- 📚 **Document History** - Access all your analyzed contracts anytime
- 💰 **Affordable Pricing**
  - **FREE**: 2 documents/month
  - **PRO**: $12/month for unlimited documents

## 🏗️ Technical Stack

- **Frontend**: Flutter 3.0+ with Material Design 3
- **State Management**: Riverpod 2.4+
- **AI Integration**: OpenAI GPT-4 / Mistral API
- **Storage**: Hive (local, encrypted)
- **Security**: AES encryption for all documents
- **Document Processing**: Support for multiple formats

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── contract.dart        # Contract model with Hive annotations
│   └── user_subscription.dart
├── providers/               # Riverpod state management
│   ├── contract_provider.dart
│   └── subscription_provider.dart
├── screens/                 # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── upload_screen.dart
│   ├── contract_detail_screen.dart
│   ├── subscription_screen.dart
│   └── settings_screen.dart
├── services/                # Business logic
│   ├── ai_service.dart           # OpenAI/Mistral integration
│   ├── encryption_service.dart   # AES encryption
│   ├── document_service.dart     # File handling
│   └── contract_storage_service.dart
├── widgets/                 # Reusable components
│   └── contract_card.dart
└── utils/
    └── theme.dart          # App theming
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- An OpenAI API key (get one at [platform.openai.com](https://platform.openai.com))

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Darahat/AI-Contract-Summarizer.git
cd AI-Contract-Summarizer
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code for Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## 🔑 Configuration

### OpenAI API Key

The app requires an OpenAI API key for AI-powered analysis. You can configure it in two ways:

1. **Via Settings Screen**: Navigate to Settings and enter your API key
2. **During Upload**: Enter your API key when uploading your first document

Your API key is stored locally and encrypted for security.

### Alternative: Using Mistral

To use Mistral instead of OpenAI, modify the `AIProvider` in `ai_service.dart`:

```dart
AIService(apiKey: apiKey, provider: AIProvider.mistral)
```

## 💎 Subscription Plans

### FREE Plan
- 2 documents per month
- AI-powered summaries
- Risk detection for payment, liability, and IP
- AES encryption
- Document history

### PRO Plan - $12/month
- **Unlimited documents**
- AI-powered summaries
- Advanced risk detection
- AES encryption
- Priority support
- Export reports (PDF)
- Custom clause explanations

## 🔒 Security Features

1. **AES Encryption**: All uploaded documents are encrypted using AES before storage
2. **Local Storage**: Documents are stored locally on your device using Hive
3. **API Key Security**: Your API keys are encrypted and never shared
4. **No Cloud Storage**: Your sensitive documents never leave your device (except for AI processing)

## 🎯 Target Audience

ClauseWise is designed for:

- **Freelancers** in developed markets who frequently deal with client contracts
- **Small Business Owners** who need quick legal clarity without expensive consultations
- **Startups** looking to understand partnership and vendor agreements
- **Contractors** reviewing service agreements and NDAs

## 📊 AI Analysis Features

### Contract Summaries
- Main parties involved
- Purpose of the agreement
- Key obligations
- Payment terms
- Duration and termination
- Important deadlines

### Risk Detection
1. **Payment Risks**
   - Unclear payment schedules
   - Unfavorable payment terms
   - Missing payment protection clauses

2. **Liability Risks**
   - Unlimited liability exposure
   - Indemnification issues
   - Insurance requirements

3. **Intellectual Property Risks**
   - IP ownership ambiguity
   - Usage rights concerns
   - Work-for-hire implications

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 🏗️ Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Development Notes

### Code Generation

The app uses code generation for Hive type adapters. After modifying models with Hive annotations, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### State Management

The app uses Riverpod for state management:
- **Providers**: For dependency injection and shared state
- **StateNotifier**: For complex state management (contracts, subscriptions)
- **StateProvider**: For simple state (API keys, current contract)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- OpenAI for GPT-4 API
- Mistral AI for alternative AI processing
- Flutter team for the amazing framework
- Riverpod for state management

## 📧 Support

For support, email [support@clausewise.app](mailto:support@clausewise.app) or open an issue on GitHub.

## 🗺️ Roadmap

- [ ] Multi-language support
- [ ] PDF export of analysis reports
- [ ] Comparison of multiple contracts
- [ ] Mobile app release (iOS & Android)
- [ ] Web app deployment
- [ ] Integration with cloud storage providers
- [ ] Collaborative features for teams
- [ ] Custom risk categories

---

<div align="center">
Made with ❤️ for freelancers and SMEs seeking legal clarity
</div>