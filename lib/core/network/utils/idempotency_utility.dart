/// Utility helper for generating unique idempotency keys for state-transition write operations.
abstract class IdempotencyUtility {
  static const String idempotencyHeaderKey = 'X-Idempotency-Key';

  /// Generates a unique idempotency key string based on action prefix and current timestamp/hash.
  static String generateKey([String prefix = 'tx']) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomPart = (timestamp ^ (prefix.hashCode)).toRadixString(36);
    return '$prefix-$timestamp-$randomPart';
  }

  /// Appends `X-Idempotency-Key` header to an existing headers map.
  static Map<String, String> withIdempotencyHeader(
    Map<String, String>? existingHeaders, {
    String? existingKey,
    String prefix = 'tx',
  }) {
    final headers = Map<String, String>.from(existingHeaders ?? {});
    headers[idempotencyHeaderKey] = existingKey ?? generateKey(prefix);
    return headers;
  }
}
