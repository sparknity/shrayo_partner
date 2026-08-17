class DailyLogsFixtures {
  static final List<Map<String, dynamic>> logs = [
    {
      'id': 'log-1',
      'patientName': 'Eleanor Vance',
      'visitDate': 'Today',
      'timeRange': '10:00 AM - 11:15 AM',
      'caregiverName': 'Sarah Jenkins, RN',
      'summary': 'Routine care, vital check, medication administration completed. Elevated BP noted.',
      'status': 'Submitted',
      'vitals': {'bp': '155/98', 'pulse': '76 bpm', 'temp': '98.4 °F', 'spo2': '98%'},
    },
    {
      'id': 'log-2',
      'patientName': 'Robert Chen',
      'visitDate': 'Yesterday',
      'timeRange': '01:30 PM - 02:45 PM',
      'caregiverName': 'Sarah Jenkins, RN',
      'summary': 'Knee extension exercises, wound dressing check intact without redness.',
      'status': 'Submitted',
      'vitals': {'bp': '124/80', 'pulse': '72 bpm', 'temp': '98.1 °F', 'spo2': '99%'},
    },
    {
      'id': 'log-3',
      'patientName': 'Margaret Higgins',
      'visitDate': 'Aug 04, 2026',
      'timeRange': '03:00 PM - 04:15 PM',
      'caregiverName': 'Sarah Jenkins, RN',
      'summary': 'Blood glucose 118 mg/dL post-meal. Hydration encouraged.',
      'status': 'Submitted',
      'vitals': {'bp': '128/82', 'pulse': '70 bpm', 'temp': '98.6 °F', 'spo2': '97%'},
    },
  ];
}
