import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/failure.dart';
import '../domain/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final SharedPreferences _prefs;

  AuthRepository(this._prefs);

  static const String _userKey = 'user_data';
  static const String _authTokenKey = 'auth_token';

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    try {
      // TODO: Implement actual authentication with backend
      // For now, return a mock user
      await Future.delayed(const Duration(seconds: 1));

      if (email.isEmpty || password.isEmpty) {
        throw const AuthFailure('Email and password are required');
      }

      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
        isPremium: false,
        monthlyUploadsUsed: 0,
        monthlyUploadsLimit: 2,
      );

      await _saveUser(user);
      await _saveAuthToken('mock_token_${user.id}');

      return user;
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      // TODO: Implement actual registration with backend
      await Future.delayed(const Duration(seconds: 1));

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw const AuthFailure('All fields are required');
      }

      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        isPremium: false,
        monthlyUploadsUsed: 0,
        monthlyUploadsLimit: 2,
      );

      await _saveUser(user);
      await _saveAuthToken('mock_token_${user.id}');

      return user;
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure('Sign up failed: ${e.toString()}');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(_authTokenKey);
    } catch (e) {
      throw AuthFailure('Sign out failed: ${e.toString()}');
    }
  }

  /// Get current user from local storage
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson == null) return null;

      // In a real app, parse the JSON and return UserModel
      // For now, return null as we need to implement JSON parsing
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = _prefs.getString(_authTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Save user data to local storage
  Future<void> _saveUser(UserModel user) async {
    // In a real app, save user.toJson() as string
    await _prefs.setString(_userKey, user.email);
  }

  /// Save auth token to local storage
  Future<void> _saveAuthToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    return _prefs.getString(_authTokenKey);
  }
}
