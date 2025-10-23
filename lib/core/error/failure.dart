/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

/// Failure that occurs during server communication
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Failure that occurs during local storage operations
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Failure that occurs during file operations
class FileFailure extends Failure {
  const FileFailure(super.message, {super.code});
}

/// Failure that occurs during authentication
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Failure that occurs during validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Failure that occurs during encryption/decryption
class EncryptionFailure extends Failure {
  const EncryptionFailure(super.message, {super.code});
}

/// Generic failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}
