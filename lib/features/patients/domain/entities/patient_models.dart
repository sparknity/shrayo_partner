class PatientSummary {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String primaryAddress;
  final String carePlanSummary;

  const PatientSummary({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.primaryAddress,
    required this.carePlanSummary,
  });

  factory PatientSummary.fromJson(Map<String, dynamic> json) {
    return PatientSummary(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] as String? ?? 'unspecified',
      primaryAddress: json['primaryAddress'] as String? ?? '',
      carePlanSummary: json['carePlanSummary'] as String? ?? '',
    );
  }
}

class PatientOverview {
  final PatientSummary summary;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final List<String> primaryDiagnoses;

  const PatientOverview({
    required this.summary,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.primaryDiagnoses,
  });

  factory PatientOverview.fromJson(Map<String, dynamic> json) {
    return PatientOverview(
      summary: PatientSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      emergencyContactName: json['emergencyContactName'] as String? ?? '',
      emergencyContactPhone: json['emergencyContactPhone'] as String? ?? '',
      primaryDiagnoses: (json['primaryDiagnoses'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class MedicalProfile {
  final String patientId;
  final List<String> allergies;
  final List<String> currentMedications;
  final String bloodType;
  final String notes;

  const MedicalProfile({
    required this.patientId,
    required this.allergies,
    required this.currentMedications,
    required this.bloodType,
    required this.notes,
  });

  factory MedicalProfile.fromJson(Map<String, dynamic> json) {
    return MedicalProfile(
      patientId: json['patientId'] as String? ?? '',
      allergies: (json['allergies'] as List?)?.map((e) => e.toString()).toList() ?? [],
      currentMedications: (json['currentMedications'] as List?)?.map((e) => e.toString()).toList() ?? [],
      bloodType: json['bloodType'] as String? ?? 'Unknown',
      notes: json['notes'] as String? ?? '',
    );
  }
}

class PatientDocument {
  final String id;
  final String title;
  final String fileType;
  final String downloadUrl;
  final DateTime uploadedAt;

  const PatientDocument({
    required this.id,
    required this.title,
    required this.fileType,
    required this.downloadUrl,
    required this.uploadedAt,
  });

  factory PatientDocument.fromJson(Map<String, dynamic> json) {
    return PatientDocument(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      fileType: json['fileType'] as String? ?? 'pdf',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'] as String)
          : DateTime.now(),
    );
  }
}
