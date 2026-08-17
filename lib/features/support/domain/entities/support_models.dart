class SupportTopic {
  final String id;
  final String title;
  final String description;

  const SupportTopic({
    required this.id,
    required this.title,
    required this.description,
  });

  factory SupportTopic.fromJson(Map<String, dynamic> json) {
    return SupportTopic(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class SupportTicket {
  final String id;
  final String subject;
  final String description;
  final String status; // open, in_progress, resolved, closed
  final DateTime createdAt;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}

class SupportTicketPayload {
  final String subject;
  final String description;
  final String category;

  const SupportTicketPayload({
    required this.subject,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'description': description,
        'category': category,
      };
}

class LeaveRequest {
  final String id;
  final String leaveType; // sick, casual, emergency
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // pending, approved, rejected, cancelled

  const LeaveRequest({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'] as String? ?? '',
      leaveType: json['leaveType'] as String? ?? 'casual',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.now(),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
    );
  }
}

class LeaveRequestPayload {
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  const LeaveRequestPayload({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'leaveType': leaveType,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'reason': reason,
      };
}
