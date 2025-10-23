# Contributing to AI Contract Summarizer

Thank you for your interest in contributing to AI Contract Summarizer! This document provides guidelines and steps for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/Darahat/AI-Contract-Summarizer/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Device and Flutter version info

### Suggesting Features

1. Check existing [Issues](https://github.com/Darahat/AI-Contract-Summarizer/issues) and [Pull Requests](https://github.com/Darahat/AI-Contract-Summarizer/pulls)
2. Create a new issue describing:
   - The feature and its benefits
   - Use cases
   - Proposed implementation (if applicable)

### Pull Requests

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR-USERNAME/AI-Contract-Summarizer.git
   cd AI-Contract-Summarizer
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow the project's code style and architecture
   - Write clean, documented code
   - Add tests for new features
   - Update documentation as needed

4. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   dart format lib/
   ```

5. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```
   
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` new features
   - `fix:` bug fixes
   - `docs:` documentation changes
   - `style:` code style changes
   - `refactor:` code refactoring
   - `test:` test additions/changes
   - `chore:` maintenance tasks

6. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub.

## Development Setup

1. **Prerequisites**
   - Flutter SDK (>=3.0.0)
   - Dart SDK (>=3.0.0)
   - IDE: VS Code or Android Studio

2. **Installation**
   ```bash
   flutter pub get
   ```

3. **Running**
   ```bash
   flutter run
   ```

## Project Architecture

This project follows Clean Architecture with Riverpod:

```
lib/
├── core/           # Shared utilities, constants, widgets
├── features/       # Feature-based modules
│   ├── auth/
│   ├── document/
│   └── settings/
├── services/       # External services
├── router/         # Navigation
├── theme/          # Theming
└── main.dart
```

### Code Guidelines

1. **Architecture**
   - Follow Clean Architecture principles
   - Separate concerns: domain, data, presentation
   - Use Riverpod for state management

2. **Code Style**
   - Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
   - Use meaningful variable/function names
   - Add comments for complex logic
   - Keep functions small and focused

3. **Testing**
   - Write unit tests for business logic
   - Write widget tests for UI components
   - Aim for >80% code coverage

4. **Documentation**
   - Document public APIs
   - Update README for new features
   - Add inline comments for complex code

## Feature Roadmap

### MVP (Current Focus)
- ✅ File upload (PDF/DOCX/Text)
- ✅ AI summarization
- ✅ Risk detection
- ✅ Clause explanation
- ✅ Document history
- ✅ Local encryption

### Future Features
- Multi-document comparison
- Cloud sync
- Smart recommendations
- Chat-style Q&A
- Advanced analytics

## Questions?

Feel free to:
- Open an issue for discussion
- Join our community channels
- Email: support@aicontractsummarizer.com

Thank you for contributing! 🙏
