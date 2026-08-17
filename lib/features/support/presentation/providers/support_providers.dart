import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/support_repository.dart';
import '../../domain/entities/support_models.dart';

/// Granular provider for support hub topics.
final supportHubProvider = FutureProvider<List<SupportTopic>>((ref) async {
  final repository = ref.watch(supportRepositoryProvider);
  final result = await repository.getSupportHubContent();
  return result.when(
    success: (topics) => topics,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for support tickets list.
final supportTicketListProvider =
    FutureProvider<List<SupportTicket>>((ref) async {
  final repository = ref.watch(supportRepositoryProvider);
  final result = await repository.getSupportTickets();
  return result.when(
    success: (tickets) => tickets,
    failure: (failure) => throw failure,
  );
});

/// Granular provider for leave requests list.
final leaveRequestListProvider =
    FutureProvider<List<LeaveRequest>>((ref) async {
  final repository = ref.watch(supportRepositoryProvider);
  final result = await repository.getLeaveRequests();
  return result.when(
    success: (requests) => requests,
    failure: (failure) => throw failure,
  );
});
