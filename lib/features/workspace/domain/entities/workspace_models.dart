class CareManagerProfile {
  final String id;
  final String employeeId;
  final String fullName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String role;

  const CareManagerProfile({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.role,
  });

  factory CareManagerProfile.fromJson(Map<String, dynamic> json) {
    return CareManagerProfile(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      role: json['role'] as String? ?? 'Care Manager',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeId': employeeId,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'role': role,
      };
}

class ProfileUpdatePayload {
  final String? fullName;
  final String? phone;
  final String? avatarUrl;

  const ProfileUpdatePayload({
    this.fullName,
    this.phone,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      };
}

class AttendanceRecord {
  final String id;
  final String employeeId;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final String status; // clocked_in, clocked_out

  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    this.clockInTime,
    this.clockOutTime,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      clockInTime: json['clockInTime'] != null
          ? DateTime.parse(json['clockInTime'] as String)
          : null,
      clockOutTime: json['clockOutTime'] != null
          ? DateTime.parse(json['clockOutTime'] as String)
          : null,
      status: json['status'] as String? ?? 'clocked_out',
    );
  }
}

class ScheduleEntry {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  const ScheduleEntry({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : DateTime.now(),
      location: json['location'] as String? ?? '',
    );
  }
}

class WorkspaceTask {
  final String id;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed
  final DateTime dueDate;

  const WorkspaceTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
  });

  factory WorkspaceTask.fromJson(Map<String, dynamic> json) {
    return WorkspaceTask(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : DateTime.now(),
    );
  }
}

class WorkspaceDocument {
  final String id;
  final String title;
  final String category;
  final String downloadUrl;

  const WorkspaceDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.downloadUrl,
  });

  factory WorkspaceDocument.fromJson(Map<String, dynamic> json) {
    return WorkspaceDocument(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      downloadUrl: json['downloadUrl'] as String? ?? '',
    );
  }
}

class TrainingModule {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;

  const TrainingModule({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
  });

  factory TrainingModule.fromJson(Map<String, dynamic> json) {
    return TrainingModule(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
    );
  }
}

class TrainingProgress {
  final String moduleId;
  final double progressPercentage;
  final bool isCompleted;

  const TrainingProgress({
    required this.moduleId,
    required this.progressPercentage,
    required this.isCompleted,
  });

  factory TrainingProgress.fromJson(Map<String, dynamic> json) {
    return TrainingProgress(
      moduleId: json['moduleId'] as String? ?? '',
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class WorkspaceSettings {
  final bool enableNotifications;
  final bool enableBiometrics;

  const WorkspaceSettings({
    required this.enableNotifications,
    required this.enableBiometrics,
  });

  factory WorkspaceSettings.fromJson(Map<String, dynamic> json) {
    return WorkspaceSettings(
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableBiometrics: json['enableBiometrics'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'enableNotifications': enableNotifications,
        'enableBiometrics': enableBiometrics,
      };
}

class SettingsUpdatePayload {
  final bool? enableNotifications;
  final bool? enableBiometrics;

  const SettingsUpdatePayload({
    this.enableNotifications,
    this.enableBiometrics,
  });

  Map<String, dynamic> toJson() => {
        if (enableNotifications != null) 'enableNotifications': enableNotifications,
        if (enableBiometrics != null) 'enableBiometrics': enableBiometrics,
      };
}
