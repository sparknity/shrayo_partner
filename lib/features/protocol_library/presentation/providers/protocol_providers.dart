import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/protocol_repository.dart';
import '../../domain/entities/protocol_models.dart';

/// Granular provider for fetching protocol categories.
final protocolCategoryListProvider =
    FutureProvider<List<ProtocolCategory>>((ref) async {
  final repository = ref.watch(protocolRepositoryProvider);
  final result = await repository.getCategories();
  return result.when(
    success: (categories) => categories,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for protocols list by category.
final protocolListProvider =
    FutureProvider.family<List<ProtocolSummary>, String?>(
  (ref, categoryId) async {
    final repository = ref.watch(protocolRepositoryProvider);
    final result = await repository.getProtocols(categoryId: categoryId);
    return result.when(
      success: (protocols) => protocols,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for protocol details.
final protocolDetailProvider =
    FutureProvider.family<ProtocolDetail, String>(
  (ref, protocolId) async {
    final repository = ref.watch(protocolRepositoryProvider);
    final result = await repository.getProtocolDetail(protocolId);
    return result.when(
      success: (detail) => detail,
      failure: (failure) => throw failure,
    );
  },
);
