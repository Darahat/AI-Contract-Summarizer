import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/document/presentation/upload_screen.dart';
import '../features/document/presentation/summary_screen.dart';
import '../features/document/presentation/risk_highlight_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/document/domain/document_model.dart';

/// App router configuration using GoRouter
class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/';
  static const String upload = '/upload';
  static const String summary = '/summary';
  static const String riskHighlight = '/risk-highlight';
  static const String settings = '/settings';

  static GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      // Auth routes
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignUpScreen(),
      ),

      // Main app routes
      GoRoute(
        path: home,
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: upload,
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: summary,
        builder: (context, state) {
          final document = state.extra as DocumentModel?;
          if (document == null) {
            return const Scaffold(
              body: Center(child: Text('Document not found')),
            );
          }
          return SummaryScreen(document: document);
        },
      ),
      GoRoute(
        path: riskHighlight,
        builder: (context, state) {
          final document = state.extra as DocumentModel?;
          if (document == null) {
            return const Scaffold(
              body: Center(child: Text('Document not found')),
            );
          }
          return RiskHighlightScreen(document: document);
        },
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
