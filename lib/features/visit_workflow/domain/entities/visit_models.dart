/// Entity representing a scheduled caregiver visit.
class Visit {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime scheduledTime;
  final String status;
  final String address;
  final String? notes;

  const Visit({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.scheduledTime,
    required this.status,
    required this.address,
    this.notes,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'scheduled',
      address: json['address'] as String? ?? '',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientId': patientId,
        'patientName': patientName,
        'scheduledTime': scheduledTime.toIso8601String(),
        'status': status,
        'address': address,
        'notes': notes,
      };
}

class CheckInPayload {
  final double latitude;
  final double longitude;
  final DateTime checkInTime;
  final String? notes;

  const CheckInPayload({
    required this.latitude,
    required this.longitude,
    required this.checkInTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'checkInTime': checkInTime.toIso8601String(),
        'notes': notes,
      };
}

class CheckOutPayload {
  final double latitude;
  final double longitude;
  final DateTime checkOutTime;
  final String? notes;

  const CheckOutPayload({
    required this.latitude,
    required this.longitude,
    required this.checkOutTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'checkOutTime': checkOutTime.toIso8601String(),
        'notes': notes,
      };
}

class AssessmentPayload {
  final Map<String, dynamic> vitals;
  final List<String> symptoms;
  final String? notes;

  const AssessmentPayload({
    required this.vitals,
    this.symptoms = const [],
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'vitals': vitals,
        'symptoms': symptoms,
        'notes': notes,
      };
}

class AssessmentResult {
  final String assessmentId;
  final String visitId;
  final DateTime submittedAt;
  final bool isSuccess;

  const AssessmentResult({
    required this.assessmentId,
    required this.visitId,
    required this.submittedAt,
    this.isSuccess = true,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      assessmentId: json['assessmentId'] as String? ?? '',
      visitId: json['visitId'] as String? ?? '',
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : DateTime.now(),
      isSuccess: json['isSuccess'] as bool? ?? true,
    );
  }
}

class NavigationInfo {
  final double destinationLatitude;
  final double destinationLongitude;
  final String addressText;
  final int estimatedDurationMinutes;

  const NavigationInfo({
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.addressText,
    required this.estimatedDurationMinutes,
  });

  factory NavigationInfo.fromJson(Map<String, dynamic> json) {
    return NavigationInfo(
      destinationLatitude: (json['destinationLatitude'] as num?)?.toDouble() ?? 0.0,
      destinationLongitude: (json['destinationLongitude'] as num?)?.toDouble() ?? 0.0,
      addressText: json['addressText'] as String? ?? '',
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 0,
    );
  }
}
