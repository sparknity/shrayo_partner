class Emergency {
  final String id;
  final String patientId;
  final String patientName;
  final String severity; // low, medium, critical
  final String status; // reported, analyzed, responding, updating_progress, completed
  final String description;
  final DateTime reportedAt;
  final DateTime? completedAt;

  const Emergency({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.severity,
    required this.status,
    required this.description,
    required this.reportedAt,
    this.completedAt,
  });

  factory Emergency.fromJson(Map<String, dynamic> json) {
    return Emergency(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      severity: json['severity'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'reported',
      description: json['description'] as String? ?? '',
      reportedAt: json['reportedAt'] != null
          ? DateTime.parse(json['reportedAt'] as String)
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'severity': severity,
        'status': status,
        'description': description,
        'reportedAt': reportedAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };
}

class EmergencyReportPayload {
  final String patientId;
  final String severity;
  final String description;
  final double? latitude;
  final double? longitude;

  const EmergencyReportPayload({
    required this.patientId,
    required this.severity,
    required this.description,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'severity': severity,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class EmergencyAnalysis {
  final String emergencyId;
  final String recommendedAction;
  final List<String> requiredServices; // 108 Ambulance, ER, Next of Kin

  const EmergencyAnalysis({
    required this.emergencyId,
    required this.recommendedAction,
    required this.requiredServices,
  });

  factory EmergencyAnalysis.fromJson(Map<String, dynamic> json) {
    return EmergencyAnalysis(
      emergencyId: json['emergencyId'] as String? ?? '',
      recommendedAction: json['recommendedAction'] as String? ?? '',
      requiredServices: (json['requiredServices'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class EmergencyResponsePayload {
  final String actionTaken;
  final String notes;

  const EmergencyResponsePayload({
    required this.actionTaken,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'actionTaken': actionTaken,
        'notes': notes,
      };
}

class ProgressUpdatePayload {
  final String updateText;
  final String? statusTag;

  const ProgressUpdatePayload({
    required this.updateText,
    this.statusTag,
  });

  Map<String, dynamic> toJson() => {
        'updateText': updateText,
        'statusTag': statusTag,
      };
}

class EmergencyCompletionPayload {
  final String resolutionSummary;
  final bool isFollowUpRequired;

  const EmergencyCompletionPayload({
    required this.resolutionSummary,
    this.isFollowUpRequired = false,
  });

  Map<String, dynamic> toJson() => {
        'resolutionSummary': resolutionSummary,
        'isFollowUpRequired': isFollowUpRequired,
      };
}
