/// Domain model representing an active authentication session.
class AuthSession {
  final String token;
  final String userId;
  final String employeeId;
  final DateTime? expiresAt;

  const AuthSession({
    required this.token,
    required this.userId,
    required this.employeeId,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          userId == other.userId &&
          employeeId == other.employeeId &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode =>
      token.hashCode ^
      userId.hashCode ^
      employeeId.hashCode ^
      expiresAt.hashCode;
}
