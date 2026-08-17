import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/protocol_models.dart';

abstract class ProtocolRepository {
  Future<Result<List<ProtocolCategory>>> getCategories();
  Future<Result<List<ProtocolSummary>>> getProtocols({String? categoryId});
  Future<Result<ProtocolDetail>> getProtocolDetail(String protocolId);
}

class ProtocolRepositoryImpl implements ProtocolRepository {
  final ApiClient _apiClient;

  ProtocolRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<ProtocolCategory>>> getCategories() async {
    return await _apiClient.get(
      '/api/v1/protocols/categories',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => ProtocolCategory.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <ProtocolCategory>[];
      },
    );
  }

  @override
  Future<Result<List<ProtocolSummary>>> getProtocols({String? categoryId}) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId;

    return await _apiClient.get(
      '/api/v1/protocols',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => ProtocolSummary.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <ProtocolSummary>[];
      },
    );
  }

  @override
  Future<Result<ProtocolDetail>> getProtocolDetail(String protocolId) async {
    return await _apiClient.get(
      '/api/v1/protocols/$protocolId',
      decoder: (json) => ProtocolDetail.fromJson(json as Map<String, dynamic>),
    );
  }
}

final protocolRepositoryProvider = Provider<ProtocolRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProtocolRepositoryImpl(apiClient);
});
