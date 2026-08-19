/// Enum representing the caregiver's active duty status.
enum ShiftStatus {
  active,
  onBreak,
  offDuty,
  emergencyLeave;

  static ShiftStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'ACTIVE':
        return ShiftStatus.active;
      case 'ON_BREAK':
        return ShiftStatus.onBreak;
      case 'OFF_DUTY':
        return ShiftStatus.offDuty;
      case 'EMERGENCY_LEAVE':
        return ShiftStatus.emergencyLeave;
      default:
        return ShiftStatus.active;
    }
  }

  String toApiString() {
    switch (this) {
      case ShiftStatus.active:
        return 'ACTIVE';
      case ShiftStatus.onBreak:
        return 'ON_BREAK';
      case ShiftStatus.offDuty:
        return 'OFF_DUTY';
      case ShiftStatus.emergencyLeave:
        return 'EMERGENCY_LEAVE';
    }
  }
}

/// Caregiver Profile Summary for the home header bar.
class CaregiverProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatarUrl;
  final ShiftStatus shiftStatus;
  final DateTime? shiftStartTime;
  final String currentDateFormatted;
  final int unreadNotificationCount;
  final bool hasCriticalAlerts;

  const CaregiverProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatarUrl,
    required this.shiftStatus,
    this.shiftStartTime,
    required this.currentDateFormatted,
    this.unreadNotificationCount = 0,
    this.hasCriticalAlerts = false,
  });

  factory CaregiverProfile.fromJson(Map<String, dynamic> json) {
    return CaregiverProfile(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? 'Caregiver',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'Senior Care Manager',
      avatarUrl: json['avatarUrl'] as String?,
      shiftStatus: ShiftStatus.fromString(json['shiftStatus'] as String?),
      shiftStartTime: json['shiftStartTime'] != null
          ? DateTime.tryParse(json['shiftStartTime'] as String)
          : null,
      currentDateFormatted:
          json['currentDateFormatted'] as String? ?? 'TODAY',
      unreadNotificationCount:
          (json['unreadNotificationCount'] as num?)?.toInt() ?? 0,
      hasCriticalAlerts: json['hasCriticalAlerts'] as bool? ?? false,
    );
  }
}

/// Progress metrics for daily assigned visits and hours.
class DailyProgress {
  final int totalVisits;
  final int completedVisits;
  final int inProgressVisits;
  final int pendingVisits;
  final double completionPercentage;
  final String formattedProgressText;
  final double hoursWorked;
  final double targetHours;

  const DailyProgress({
    required this.totalVisits,
    required this.completedVisits,
    required this.inProgressVisits,
    required this.pendingVisits,
    required this.completionPercentage,
    required this.formattedProgressText,
    required this.hoursWorked,
    required this.targetHours,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      totalVisits: (json['totalVisits'] as num?)?.toInt() ?? 0,
      completedVisits: (json['completedVisits'] as num?)?.toInt() ?? 0,
      inProgressVisits: (json['inProgressVisits'] as num?)?.toInt() ?? 0,
      pendingVisits: (json['pendingVisits'] as num?)?.toInt() ?? 0,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      formattedProgressText:
          json['formattedProgressText'] as String? ?? '0% Complete',
      hoursWorked: (json['hoursWorked'] as num?)?.toDouble() ?? 0.0,
      targetHours: (json['targetHours'] as num?)?.toDouble() ?? 8.0,
    );
  }
}

/// Health Condition Tag badge for patient cards.
class HealthTag {
  final String id;
  final String label;
  final String colorHex;

  const HealthTag({
    required this.id,
    required this.label,
    required this.colorHex,
  });

  factory HealthTag.fromJson(Map<String, dynamic> json) {
    return HealthTag(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      colorHex: json['color'] as String? ?? '#16A34A',
    );
  }
}

/// Location and distance details for the current visit.
class VisitLocationInfo {
  final String address;
  final String zoneName;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String distanceFormatted;
  final int travelTimeMinutes;
  final String travelInfoFormatted;

  const VisitLocationInfo({
    required this.address,
    required this.zoneName,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.distanceFormatted,
    required this.travelTimeMinutes,
    required this.travelInfoFormatted,
  });

  factory VisitLocationInfo.fromJson(Map<String, dynamic> json) {
    return VisitLocationInfo(
      address: json['address'] as String? ?? '',
      zoneName: json['zoneName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      distanceFormatted: json['distanceFormatted'] as String? ?? '',
      travelTimeMinutes:
          (json['travelTimeMinutes'] as num?)?.toInt() ?? 0,
      travelInfoFormatted:
          json['travelInfoFormatted'] as String? ?? '',
    );
  }
}

/// Current Active Visit Hero Card Model.
class CurrentVisitHero {
  final String id;
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String? avatarUrl;
  final String riskLevel;
  final String riskBadgeColorHex;
  final String scheduledTime;
  final String scheduledTimeSlot;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final String status;
  final String careType;
  final VisitLocationInfo location;
  final List<HealthTag> healthTags;
  final String? directPhoneParent;
  final String? directPhoneFamily;

  const CurrentVisitHero({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    this.avatarUrl,
    required this.riskLevel,
    required this.riskBadgeColorHex,
    required this.scheduledTime,
    required this.scheduledTimeSlot,
    this.scheduledStartTime,
    this.scheduledEndTime,
    required this.status,
    required this.careType,
    required this.location,
    required this.healthTags,
    this.directPhoneParent,
    this.directPhoneFamily,
  });

  factory CurrentVisitHero.fromJson(Map<String, dynamic> json) {
    return CurrentVisitHero(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      patientName: json['patientName'] as String? ?? '',
      patientAge: (json['patientAge'] as num?)?.toInt() ?? 0,
      patientGender: json['patientGender'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      riskLevel: json['riskLevel'] as String? ?? 'LOW_RISK',
      riskBadgeColorHex: json['riskBadgeColor'] as String? ?? '#E11D48',
      scheduledTime: json['scheduledTime'] as String? ?? '',
      scheduledTimeSlot: json['scheduledTimeSlot'] as String? ?? '',
      scheduledStartTime: json['scheduledStartTime'] != null
          ? DateTime.tryParse(json['scheduledStartTime'] as String)
          : null,
      scheduledEndTime: json['scheduledEndTime'] != null
          ? DateTime.tryParse(json['scheduledEndTime'] as String)
          : null,
      status: json['status'] as String? ?? 'SCHEDULED',
      careType: json['careType'] as String? ?? '',
      location: VisitLocationInfo.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ),
      healthTags: (json['healthTags'] as List?)
              ?.map((e) => HealthTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      directPhoneParent: json['actions']?['directPhoneParent'] as String?,
      directPhoneFamily: json['actions']?['directPhoneFamily'] as String?,
    );
  }
}

/// Badge counts for the 4-grid quick navigation cards.
class QuickActionCounts {
  final int patientDirectoryCount;
  final int dailyLogsCount;
  final int activeProtocolsCount;
  final int supportTicketsPending;

  const QuickActionCounts({
    required this.patientDirectoryCount,
    required this.dailyLogsCount,
    required this.activeProtocolsCount,
    required this.supportTicketsPending,
  });

  factory QuickActionCounts.fromJson(Map<String, dynamic> json) {
    return QuickActionCounts(
      patientDirectoryCount:
          (json['patientDirectoryCount'] as num?)?.toInt() ?? 0,
      dailyLogsCount: (json['dailyLogsCount'] as num?)?.toInt() ?? 0,
      activeProtocolsCount:
          (json['activeProtocolsCount'] as num?)?.toInt() ?? 0,
      supportTicketsPending:
          (json['supportTicketsPending'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Item in the Recent Activity timeline.
class ActivityItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String? timePill;
  final DateTime timestamp;
  final String iconType;
  final String iconBgHex;
  final String iconColorHex;
  final String? referenceId;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.timePill,
    required this.timestamp,
    required this.iconType,
    required this.iconBgHex,
    required this.iconColorHex,
    this.referenceId,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      timePill: json['timePill'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      iconType: json['iconType'] as String? ?? 'CHECK',
      iconBgHex: json['iconBg'] as String? ?? '#DCFCE7',
      iconColorHex: json['iconColor'] as String? ?? '#16A34A',
      referenceId: json['referenceId'] as String?,
    );
  }
}

/// Item in the Upcoming Schedule timeline.
class UpcomingScheduleItem {
  final String id;
  final String? visitId;
  final String type;
  final String timeFormatted;
  final DateTime? scheduledStartTime;
  final String? badgeText;
  final String title;
  final String? subtitle;
  final String? icon;
  final bool isHighlighted;
  final bool isDashed;
  final String status;

  const UpcomingScheduleItem({
    required this.id,
    this.visitId,
    required this.type,
    required this.timeFormatted,
    this.scheduledStartTime,
    this.badgeText,
    required this.title,
    this.subtitle,
    this.icon,
    this.isHighlighted = false,
    this.isDashed = false,
    required this.status,
  });

  factory UpcomingScheduleItem.fromJson(Map<String, dynamic> json) {
    return UpcomingScheduleItem(
      id: json['id'] as String? ?? '',
      visitId: json['visitId'] as String?,
      type: json['type'] as String? ?? 'PATIENT_VISIT',
      timeFormatted: json['timeFormatted'] as String? ?? '',
      scheduledStartTime: json['scheduledStartTime'] != null
          ? DateTime.tryParse(json['scheduledStartTime'] as String)
          : null,
      badgeText: json['badgeText'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      icon: json['icon'] as String?,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      isDashed: json['isDashed'] as bool? ?? false,
      status: json['status'] as String? ?? 'PENDING',
    );
  }
}

/// Clinical / Behavioral AI briefing card.
class CareIntelligenceItem {
  final String id;
  final String? patientId;
  final String category;
  final String headline;
  final String message;
  final String priority;
  final DateTime? generatedAt;

  const CareIntelligenceItem({
    required this.id,
    this.patientId,
    required this.category,
    required this.headline,
    required this.message,
    required this.priority,
    this.generatedAt,
  });

  factory CareIntelligenceItem.fromJson(Map<String, dynamic> json) {
    return CareIntelligenceItem(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String?,
      category: json['category'] as String? ?? 'BEHAVIORAL_INSIGHT',
      headline: json['headline'] as String? ?? 'CARE INTELLIGENCE',
      message: json['message'] as String? ?? '',
      priority: json['priority'] as String? ?? 'HIGH',
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'] as String)
          : null,
    );
  }
}

/// Master Aggregated Home Dashboard Data Model.
class HomeDashboardData {
  final CaregiverProfile caregiver;
  final DailyProgress dailyProgress;
  final CurrentVisitHero? currentVisit;
  final QuickActionCounts quickActions;
  final List<ActivityItem> recentActivities;
  final List<UpcomingScheduleItem> upcomingSchedule;
  final CareIntelligenceItem? careIntelligence;

  const HomeDashboardData({
    required this.caregiver,
    required this.dailyProgress,
    this.currentVisit,
    required this.quickActions,
    required this.recentActivities,
    required this.upcomingSchedule,
    this.careIntelligence,
  });

  factory HomeDashboardData.fromJson(Map<String, dynamic> json) {
    return HomeDashboardData(
      caregiver: CaregiverProfile.fromJson(
        json['caregiver'] as Map<String, dynamic>? ?? {},
      ),
      dailyProgress: DailyProgress.fromJson(
        json['dailyProgress'] as Map<String, dynamic>? ?? {},
      ),
      currentVisit: json['currentVisit'] != null
          ? CurrentVisitHero.fromJson(
              json['currentVisit'] as Map<String, dynamic>,
            )
          : null,
      quickActions: QuickActionCounts.fromJson(
        json['quickActions'] as Map<String, dynamic>? ?? {},
      ),
      recentActivities: (json['recentActivities'] as List?)
              ?.map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      upcomingSchedule: (json['upcomingSchedule'] as List?)
              ?.map(
                (e) => UpcomingScheduleItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      careIntelligence: json['careIntelligence'] != null
          ? CareIntelligenceItem.fromJson(
              json['careIntelligence'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
