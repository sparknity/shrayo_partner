import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Notifier managing the count of unread notifications (fed by Phase 23).
class UnreadNotificationCountNotifier extends Notifier<int> {
  @override
  int build() => 3;

  void setCount(int count) => state = count;
  void increment() => state++;
  void decrement() {
    if (state > 0) state--;
  }
}

/// Global provider holding unread notification count.
final unreadNotificationCountProvider =
    NotifierProvider<UnreadNotificationCountNotifier, int>(
        UnreadNotificationCountNotifier.new);

/// Header icon button with unread notification badge overlay.
class NotificationBadgeIconButton extends ConsumerWidget {
  const NotificationBadgeIconButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadNotificationCountProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
          onPressed: onPressed,
          tooltip: 'Notifications',
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColors.emergencyRed,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
