# Project Setup Guide

This guide will help you set up and run the AI Contract Summarizer project on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (>=3.0.0)
  - Download from: https://flutter.dev/docs/get-started/install
  - Verify installation: `flutter doctor`

- **Dart SDK** (>=3.0.0)
  - Usually comes with Flutter

- **IDE** (Choose one):
  - Visual Studio Code with Flutter extension
  - Android Studio with Flutter plugin

- **Platform-specific requirements**:
  - **For Android**: Android Studio, Android SDK
  - **For iOS**: Xcode (macOS only), CocoaPods
  - **For Web**: Chrome browser
  - **For Desktop**: Platform-specific dependencies

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Darahat/AI-Contract-Summarizer.git
cd AI-Contract-Summarizer
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all the packages specified in `pubspec.yaml`.

### 3. Verify Flutter Installation

```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor` before proceeding.

## Configuration

### 1. Environment Variables

Create a `.env` file in the root directory:

```bash
# .env file
OPENAI_API_KEY=your_openai_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
ENCRYPTION_PASSPHRASE=your_secure_passphrase_here
```

**Important:** Never commit the `.env` file to version control!

### 2. Platform-Specific Setup

#### Android

1. Open `android/` directory in Android Studio
2. Wait for Gradle sync to complete
3. Update `android/app/build.gradle` if needed
4. Run on emulator or device:
   ```bash
   flutter run -d android
   ```

#### iOS (macOS only)

1. Install CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

2. Install iOS dependencies:
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. Open `ios/Runner.xcworkspace` in Xcode (not .xcodeproj!)

4. Configure signing in Xcode:
   - Select Runner target
   - Go to Signing & Capabilities
   - Select your team

5. Run on simulator or device:
   ```bash
   flutter run -d ios
   ```

#### Web

```bash
flutter run -d chrome
```

#### Desktop

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

## Running the App

### Development Mode

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run with hot reload (default)
flutter run

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release
```

### Build for Production

#### Android APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS

```bash
flutter build ios --release
# Then open Xcode to archive and upload to App Store
```

#### Web

```bash
flutter build web --release
# Output: build/web/
```

## Development Workflow

### 1. Code Quality

#### Run Linter

```bash
flutter analyze
```

#### Format Code

```bash
dart format lib/ test/
```

#### Fix Linter Issues

```bash
dart fix --apply
```

### 2. Testing

#### Run All Tests

```bash
flutter test
```

#### Run Specific Test File

```bash
flutter test test/features/auth/domain/user_model_test.dart
```

#### Run Tests with Coverage

```bash
flutter test --coverage
```

View coverage report:
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### 3. Code Generation

If you add Riverpod code generation annotations:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Troubleshooting

### Common Issues

#### 1. "flutter: command not found"

Solution:
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 2. "pod install" fails on iOS

Solution:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

#### 3. Gradle build fails on Android

Solution:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 4. Dependencies not resolving

Solution:
```bash
flutter clean
flutter pub get
```

#### 5. Hot reload not working

Solution:
- Press 'r' in terminal to hot reload
- Press 'R' to hot restart
- Restart the debug session

### Getting Help

- Check [Flutter documentation](https://flutter.dev/docs)
- Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- Open an issue in this repository

## Development Tools

### Recommended VS Code Extensions

```json
{
  "recommendations": [
    "dart-code.dart-code",
    "dart-code.flutter",
    "alexisvt.flutter-snippets",
    "nash.awesome-flutter-snippets",
    "pflannery.vscode-versionlens"
  ]
}
```

### Useful Commands

```bash
# Check Flutter version
flutter --version

# Upgrade Flutter
flutter upgrade

# Clean build artifacts
flutter clean

# Get package updates
flutter pub upgrade

# Analyze code
flutter analyze

# Run specific test suite
flutter test test/features/

# Generate app icons
flutter pub run flutter_launcher_icons:main

# Generate splash screen
flutter pub run flutter_native_splash:create
```

## Project Structure

```
lib/
├── core/               # Shared code
├── features/           # Feature modules
├── services/           # External services
├── router/             # Navigation
├── theme/              # Theming
└── main.dart          # App entry point

test/
├── core/              # Core tests
└── features/          # Feature tests

docs/
├── AI_INTEGRATION.md  # AI setup guide
├── ARCHITECTURE.md    # Architecture docs
└── SETUP_GUIDE.md     # This file
```

## Next Steps

1. **Configure AI Service**: Follow [AI_INTEGRATION.md](AI_INTEGRATION.md)
2. **Understand Architecture**: Read [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Start Coding**: Check [CONTRIBUTING.md](../CONTRIBUTING.md)
4. **Run Tests**: `flutter test`
5. **Deploy**: Follow platform-specific deployment guides

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)
- [Flutter Samples](https://flutter.github.io/samples/)

## Support

For issues or questions:
- Open an issue on GitHub
- Check existing documentation
- Contact: support@aicontractsummarizer.com

Happy coding! 🚀
