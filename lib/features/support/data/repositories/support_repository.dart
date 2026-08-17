import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/entities/support_models.dart';

abstract class SupportRepository {
  Future<Result<List<SupportTopic>>> getSupportHubContent();
  Future<Result<List<SupportTicket>>> getSupportTickets();
  Future<Result<SupportTicket>> createSupportTicket(SupportTicketPayload payload);
  Future<Result<List<LeaveRequest>>> getLeaveRequests();
  Future<Result<LeaveRequest>> createLeaveRequest(LeaveRequestPayload payload);
  Future<Result<LeaveRequest>> cancelLeaveRequest(String leaveRequestId);
}

class SupportRepositoryImpl implements SupportRepository {
  final ApiClient _apiClient;

  SupportRepositoryImpl(this._apiClient);

  @override
  Future<Result<List<SupportTopic>>> getSupportHubContent() async {
    return await _apiClient.get(
      '/api/v1/support/topics',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => SupportTopic.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <SupportTopic>[];
      },
    );
  }

  @override
  Future<Result<List<SupportTicket>>> getSupportTickets() async {
    return await _apiClient.get(
      '/api/v1/support/tickets',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => SupportTicket.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <SupportTicket>[];
      },
    );
  }

  @override
  Future<Result<SupportTicket>> createSupportTicket(SupportTicketPayload payload) async {
    return await _apiClient.post(
      '/api/v1/support/tickets',
      data: payload.toJson(),
      decoder: (json) => SupportTicket.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<LeaveRequest>>> getLeaveRequests() async {
    return await _apiClient.get(
      '/api/v1/support/leave-requests',
      decoder: (json) {
        if (json is List) {
          return json.map((e) => LeaveRequest.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <LeaveRequest>[];
      },
    );
  }

  @override
  Future<Result<LeaveRequest>> createLeaveRequest(LeaveRequestPayload payload) async {
    return await _apiClient.post(
      '/api/v1/support/leave-requests',
      data: payload.toJson(),
      decoder: (json) => LeaveRequest.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<LeaveRequest>> cancelLeaveRequest(String leaveRequestId) async {
    return await _apiClient.post(
      '/api/v1/support/leave-requests/$leaveRequestId/cancel',
      data: {},
      decoder: (json) => LeaveRequest.fromJson(json as Map<String, dynamic>),
    );
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SupportRepositoryImpl(apiClient);
});
