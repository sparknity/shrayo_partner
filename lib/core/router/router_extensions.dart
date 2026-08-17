import 'package:go_router/go_router.dart';

/// Extension helpers on [GoRouterState] for standardized query parameter parsing.
extension GoRouterStateQueryParsing on GoRouterState {
  /// Extracts `returnTo` redirect path parameter.
  String? get returnTo => uri.queryParameters['returnTo'];

  /// Extracts `visitId` parameter.
  String? get visitId => uri.queryParameters['visitId'];
}
