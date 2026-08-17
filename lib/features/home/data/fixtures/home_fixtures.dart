class HomeDashboardFixture {
  static const String caregiverName = "Sarah Jenkins, RN";
  static const String caregiverRole = "Senior Care Manager";
  static const int pendingVisitsCount = 3;
  static const int completedVisitsCount = 2;
  static const int criticalAlertsCount = 1;
  static const int totalPatients = 12;

  static final Map<String, dynamic> currentVisitPreview = {
    'id': 'v-101',
    'patientName': 'Eleanor Vance',
    'patientAge': 78,
    'address': '742 Evergreen Terrace, Springfield',
    'timeSlot': '10:00 AM - 11:30 AM',
    'status': 'Scheduled',
    'primaryCareType': 'Routine Check & Vital Monitoring',
    'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
  };

  static final List<Map<String, dynamic>> upcomingSchedule = [
    {
      'id': 'v-102',
      'patientName': 'Robert Chen',
      'patientAge': 82,
      'timeSlot': '01:00 PM - 02:30 PM',
      'status': 'Pending',
      'careType': 'Post-Op Physical Therapy Support',
    },
    {
      'id': 'v-103',
      'patientName': 'Margaret Higgins',
      'patientAge': 74,
      'timeSlot': '03:30 PM - 04:45 PM',
      'status': 'Pending',
      'careType': 'Medication Administration & Vitals',
    },
  ];
}
