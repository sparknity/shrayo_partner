class NotificationFixtures {
  static final List<Map<String, dynamic>> items = [
    {
      'id': 'n-1',
      'title': 'Critical Vital Alert: High Blood Pressure',
      'body': 'Eleanor Vance reported BP 155/98 mmHg during morning log.',
      'category': 'Vitals Alert',
      'timestamp': '10 mins ago',
      'isUnread': true,
      'patientId': 'p-1',
      'details': 'Systolic pressure exceeded 150 mmHg threshold. Care manager intervention requested.',
    },
    {
      'id': 'n-2',
      'title': 'Schedule Change: Visit Rescheduled',
      'body': 'Robert Chen\'s visit shifted to 01:00 PM today by Ops Team.',
      'category': 'Schedule',
      'timestamp': '1 hour ago',
      'isUnread': true,
      'patientId': 'p-2',
      'details': 'Transportation delayed. Visit window updated from 11:30 AM to 01:00 PM.',
    },
    {
      'id': 'n-3',
      'title': 'New Clinical Protocol Uploaded',
      'body': 'Updated Cardiac Rehab Protocol v3.2 published.',
      'category': 'Protocol Update',
      'timestamp': '3 hours ago',
      'isUnread': false,
      'patientId': null,
      'details': 'Includes updated step-by-step guidance on telemetry sync and emergency escalation.',
    },
    {
      'id': 'n-4',
      'title': 'Leave Request Approved',
      'body': 'Your leave request for Aug 15 - Aug 16 has been approved by Ops Admin.',
      'category': 'System',
      'timestamp': '1 day ago',
      'isUnread': false,
      'patientId': null,
      'details': 'Coverage coverage assigned to Caregiver Mark Stevens.',
    },
  ];
}
