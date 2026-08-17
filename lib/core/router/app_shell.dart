import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/widgets/current_visit_banner.dart';
import '../../features/visit_workflow/presentation/providers/active_visit_provider.dart';
import '../sync/offline_sync_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/notification_badge.dart';
import '../widgets/offline_sync_banner.dart';
import 'visit_lock_scaffold.dart';

/// Authenticated App Shell hosting the 4-tab IndexedStack (Phase 11 v2).
///
/// Core Tabs:
/// 0: Home
/// 1: Visits
/// 2: Emergency
/// 3: Workspace
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  Future<void> _onTapTab(BuildContext context, WidgetRef ref, int index) async {
    final visitState = ref.read(activeVisitProvider);

    if (visitState.isVisitInProgress && index != navigationShell.currentIndex) {
      final shouldLeave = await showVisitLeaveConfirmationDialog(context);
      if (!shouldLeave) return;
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitState = ref.watch(activeVisitProvider);
    final syncState = ref.watch(offlineSyncStateProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    final title = switch (navigationShell.currentIndex) {
      0 => 'Operations Dashboard',
      1 => 'Current Visit',
      2 => 'Emergency Response',
      3 => 'Workspace',
      _ => 'Caregiver Portal',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        actions: [
          NotificationBadgeIconButton(
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: Column(
        children: [
          OfflineSyncBanner(
            isOffline: syncState.isOffline,
            pendingItemCount: syncState.pendingItemCount,
            onSyncPressed: () => ref.read(offlineSyncStateProvider.notifier).triggerSync(),
          ),
          Expanded(child: navigationShell),
          if (visitState.isVisitInProgress && visitState.activeVisitId != null)
            CurrentVisitBanner(
              stage: visitState.stage,
              visitId: visitState.activeVisitId!,
            ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTapTab(context, ref, index),
        unreadNotificationsCount: unreadCount,
      ),
    );
  }
}
