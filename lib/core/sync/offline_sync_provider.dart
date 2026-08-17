import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Offline connectivity and sync queue state.
class OfflineSyncState {
  final bool isOffline;
  final int pendingItemCount;

  const OfflineSyncState({
    required this.isOffline,
    required this.pendingItemCount,
  });

  const OfflineSyncState.initial()
      : isOffline = false,
        pendingItemCount = 0;

  OfflineSyncState copyWith({
    bool? isOffline,
    int? pendingItemCount,
  }) {
    return OfflineSyncState(
      isOffline: isOffline ?? this.isOffline,
      pendingItemCount: pendingItemCount ?? this.pendingItemCount,
    );
  }
}

/// Notifier managing global offline state and pending mutation count for Phase 22 integration.
class OfflineSyncNotifier extends Notifier<OfflineSyncState> {
  @override
  OfflineSyncState build() {
    return const OfflineSyncState.initial();
  }

  void setOffline(bool offline) {
    state = state.copyWith(isOffline: offline);
  }

  void setPendingItemCount(int count) {
    state = state.copyWith(pendingItemCount: count);
  }

  void triggerSync() {
    // Phase 22 trigger sync logic placeholder
    state = state.copyWith(pendingItemCount: 0);
  }
}

/// Global provider for [OfflineSyncNotifier].
final offlineSyncStateProvider =
    NotifierProvider<OfflineSyncNotifier, OfflineSyncState>(() {
  return OfflineSyncNotifier();
});
