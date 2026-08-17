import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notification_repository.dart';
import '../../domain/entities/notification_models.dart';

/// Granular provider for fetching caregiver notification list.
final notificationListProvider =
    FutureProvider.family<List<NotificationItem>, int?>(
  (ref, page) async {
    final repository = ref.watch(notificationRepositoryProvider);
    final result = await repository.getNotificationList(page: page);
    return result.when(
      success: (notifications) => notifications,
      failure: (failure) => throw failure,
    );
  },
);

/// Granular provider for notification details.
final notificationDetailProvider =
    FutureProvider.family<NotificationDetail, String>(
  (ref, notificationId) async {
    final repository = ref.watch(notificationRepositoryProvider);
    final result = await repository.getNotificationDetail(notificationId);
    return result.when(
      success: (detail) => detail,
      failure: (failure) => throw failure,
    );
  },
);
