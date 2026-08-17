/// Abstract class representing application failures.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Represents authentication/credentials failure (401/403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid employee ID or password'])
      : super(code: 'UNAUTHORIZED');
}

/// Represents network connectivity failures.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Unable to connect. Please check your internet connection.'])
      : super(code: 'NETWORK_ERROR');
}

/// Represents request timeout failures.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The request timed out. Please try again.'])
      : super(code: 'TIMEOUT_ERROR');
}

/// Represents server side errors (500, 502, etc.).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.'])
      : super(code: 'SERVER_ERROR');
}

/// Represents validation or bad request errors (400/422).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code = 'VALIDATION_ERROR'});
}

/// Represents 409 conflict errors for out-of-order or duplicate state transitions.
class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'The requested action conflicts with the current resource state.'])
      : super(code: 'CONFLICT_ERROR');
}

/// Represents generic unknown failures.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.'])
      : super(code: 'UNKNOWN');
}
