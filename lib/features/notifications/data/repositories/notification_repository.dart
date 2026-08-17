import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/notification_models.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationItem>>> getNotificationList({int? page});
  Future<Result<NotificationDetail>> getNotificationDetail(String notificationId);
  Future<Result<void>> markAsRead(String notificationId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<NotificationItem>>> getNotificationList({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    return await _apiClient.get(
      '/api/v1/notifications',
      queryParameters: queryParams,
      decoder: (json) {
        if (json is List) {
          return json.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <NotificationItem>[];
      },
    );
  }

  @override
  Future<Result<NotificationDetail>> getNotificationDetail(String notificationId) async {
    return await _apiClient.get(
      '/api/v1/notifications/$notificationId',
      decoder: (json) => NotificationDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<void>> markAsRead(String notificationId) async {
    return await _apiClient.post(
      '/api/v1/notifications/$notificationId/read',
      data: {},
      decoder: (_) {},
    );
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepositoryImpl(apiClient);
});
