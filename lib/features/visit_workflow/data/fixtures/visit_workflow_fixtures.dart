class VisitWorkflowFixtures {
  static final Map<String, dynamic> activeVisit = {
    'id': 'v-101',
    'patientId': 'p-1',
    'patientName': 'Eleanor Vance',
    'patientAge': 78,
    'patientAddress': '742 Evergreen Terrace, Springfield',
    'patientLat': 37.7749,
    'patientLng': -122.4194,
    'caregiverLat': 37.7742,
    'caregiverLng': -122.4180,
    'timeWindow': '10:00 AM - 11:30 AM',
    'careType': 'Routine Check & Vital Monitoring',
    'scheduledDate': 'Today',
    'status': 'Scheduled',
    'stepsCompleted': 2,
    'totalSteps': 5,
    'vitals': {
      'systolic': '155',
      'diastolic': '98',
      'pulse': '76',
      'temp': '98.4',
      'spo2': '98',
      'glucose': '110',
    },
    'checklistItems': [
      {'title': 'Check-In GPS Verification', 'done': true},
      {'title': 'Vital Signs Captured', 'done': true},
      {'title': 'Medication Adherence Check', 'done': true},
      {'title': 'Mobility & Fall Assessment', 'done': false},
      {'title': 'Care Summary & Signature', 'done': false},
    ],
  };
}
