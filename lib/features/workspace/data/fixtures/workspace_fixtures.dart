class WorkspaceFixtures {
  static final Map<String, dynamic> caregiverProfile = {
    'name': 'Sarah Jenkins',
    'fullName': 'Sarah Jenkins',
    'title': 'Senior Care Coordinator',
    'designation': 'Senior Field Nurse',
    'employeeId': 'EMPLOYEE CG-88291',
    'idNumber': '#WS-8842-EMP',
    'department': 'Geriatric Care Unit',
    'branch': 'Metropolitan Central',
    'joiningDate': 'March 12, 2018',
    'experience': '6 Years, 4 Months',
    'yearsExperience': 12,
    'certificationsCount': 48,
    'rating': 5.0,
    'phone': '+1 (555) 012-3456',
    'email': 's.mitchell@workspace.care',
    'workEmail': 'sarah.jenkins@carecare.com',
    'dob': '05/14/1988',
    'gender': 'Female',
    'address': '482 Oakwood Avenue',
    'city': 'Portland',
    'state': 'OR',
    'zipCode': '97201',
    'shiftSchedule': '08:00 - 16:00',
    'shiftLocation': "St. Mary's Wing B",
    'tasksCount': 4,
    'visitsCount': 2,
    'score': '98%',
    'avatarUrl': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
    'emergencyContact': {
      'name': 'Mark Mitchell',
      'relationship': 'Spouse',
      'phone': '+1 (555) 987-6543',
    },
    'primaryEmergencyContact': {
      'name': 'Eleanor Vance',
      'relationship': 'Daughter & Healthcare Proxy',
      'mobile': '+1 (555) 234-8890',
      'work': '+1 (555) 900-1122',
      'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    },
    'secondaryEmergencyContact': {
      'name': 'Julian Vance',
      'relationship': 'Son / Secondary',
      'phone': '+1 (555) 982-3344',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    },
    'reportingManager': {
      'name': 'Dr. Sarah Jenkins',
      'role': 'Reporting Manager',
      'email': 's.jenkins@carecare.com',
    },
  };

  // --- ATTENDANCE FIXTURES ---
  static final Map<String, dynamic> attendanceOverview = {
    'sessionTime': '06h 12m',
    'checkInTime': '08:00 AM',
    'expectedOutTime': '05:00 PM',
    'weeklyProgressCurrent': 32,
    'weeklyProgressTotal': 40,
    'activeDayIndex': 3, // Thursday
    'earnedToday': '\$142.50',
    'reliability': '98%',
  };

  static final List<Map<String, dynamic>> attendanceRecentActivity = [
    {
      'id': 'att-wed-25',
      'day': 'Wed, Oct 25',
      'timeRange': '08:05 AM - 05:12 PM',
      'duration': '9h 07m',
      'status': 'PRESENT',
      'isLate': false,
    },
    {
      'id': 'att-tue-24',
      'day': 'Tue, Oct 24',
      'timeRange': '08:45 AM - 05:00 PM',
      'duration': '8h 15m',
      'status': 'LATE',
      'isLate': true,
    },
    {
      'id': 'att-mon-23',
      'day': 'Mon, Oct 23',
      'timeRange': '07:58 AM - 05:03 PM',
      'duration': '9h 05m',
      'status': 'PRESENT',
      'isLate': false,
    },
  ];

  static final Map<String, dynamic> attendanceHistorySummary = {
    'daysWorked': 22,
    'totalWorkingDays': 26,
    'lateArrivalsCount': 3,
    'averageDelayMins': 12,
  };

  static final List<Map<String, dynamic>> attendanceDailyRecords = [
    {
      'id': 'att-mon-23',
      'month': 'OCT',
      'dayNumber': '23',
      'title': 'Monday Shift',
      'timeRange': '08:00 AM - 04:00 PM',
      'status': 'Present',
      'isLate': false,
      'dateFormatted': 'Monday, Oct 23, 2023',
      'fullPeriodDate': 'Tuesday, May 14, 2024',
      'clockIn': '08:30 AM',
      'clockInStatus': 'On Time',
      'clockOut': '05:15 PM',
      'clockOutStatus': 'Normal Exit',
      'breakTime': '45 min',
      'breakTimeRange': '12:30 PM - 01:15 PM',
      'locationName': 'ST. JUDE CARE CENTER',
      'locationAddress': '124 Healthcare Plaza, North Wing Entrance, Suite 402',
      'gpsAccuracy': '3.5m',
      'netWorkingTime': '08.00',
      'scheduled': '08:00 hrs',
      'overtime': '00:00 hrs',
      'deficit': '00:00 hrs',
      'verifications': [
        {'title': 'Face-ID Recognition', 'subtitle': 'Matched at 08:30:12 AM', 'verified': true},
        {'title': 'Geofence Validation', 'subtitle': 'Within 10m radius of site', 'verified': true},
        {'title': 'Manager Review', 'subtitle': 'Auto-approved by system', 'verified': true},
      ],
    },
    {
      'id': 'att-sun-22',
      'month': 'OCT',
      'dayNumber': '22',
      'title': 'Sunday Shift',
      'timeRange': 'Arrived at 08:25 AM (+25m)',
      'status': 'Late',
      'isLate': true,
      'dateFormatted': 'Sunday, Oct 22, 2023',
      'fullPeriodDate': 'Sunday, Oct 22, 2023',
      'clockIn': '08:25 AM',
      'clockInStatus': 'Late (+25m)',
      'clockOut': '05:00 PM',
      'clockOutStatus': 'Normal Exit',
      'breakTime': '30 min',
      'breakTimeRange': '01:00 PM - 01:30 PM',
      'locationName': 'METROPOLITAN CARE HOME',
      'locationAddress': '89 Pinehurst Boulevard, Building 4',
      'gpsAccuracy': '4.1m',
      'netWorkingTime': '08.05',
      'scheduled': '08:00 hrs',
      'overtime': '00:05 hrs',
      'deficit': '00:00 hrs',
      'verifications': [
        {'title': 'Face-ID Recognition', 'subtitle': 'Matched at 08:25:04 AM', 'verified': true},
        {'title': 'Geofence Validation', 'subtitle': 'Within 12m radius of site', 'verified': true},
        {'title': 'Manager Review', 'subtitle': 'Approved with note by Supervisor', 'verified': true},
      ],
    },
    {
      'id': 'att-sat-21',
      'month': 'OCT',
      'dayNumber': '21',
      'title': 'Saturday Shift',
      'timeRange': '08:00 AM - 04:00 PM',
      'status': 'Present',
      'isLate': false,
      'dateFormatted': 'Saturday, Oct 21, 2023',
      'fullPeriodDate': 'Saturday, Oct 21, 2023',
      'clockIn': '07:58 AM',
      'clockInStatus': 'On Time',
      'clockOut': '04:02 PM',
      'clockOutStatus': 'Normal Exit',
      'breakTime': '45 min',
      'breakTimeRange': '12:00 PM - 12:45 PM',
      'locationName': 'ST. JUDE CARE CENTER',
      'locationAddress': '124 Healthcare Plaza, North Wing Entrance, Suite 402',
      'gpsAccuracy': '3.2m',
      'netWorkingTime': '08.00',
      'scheduled': '08:00 hrs',
      'overtime': '00:00 hrs',
      'deficit': '00:00 hrs',
      'verifications': [
        {'title': 'Face-ID Recognition', 'subtitle': 'Matched at 07:58:11 AM', 'verified': true},
        {'title': 'Geofence Validation', 'subtitle': 'Within 8m radius of site', 'verified': true},
        {'title': 'Manager Review', 'subtitle': 'Auto-approved by system', 'verified': true},
      ],
    },
    {
      'id': 'att-fri-20',
      'month': 'OCT',
      'dayNumber': '20',
      'title': 'Friday Shift',
      'timeRange': '08:00 AM - 04:00 PM',
      'status': 'Present',
      'isLate': false,
      'dateFormatted': 'Friday, Oct 20, 2023',
      'fullPeriodDate': 'Friday, Oct 20, 2023',
      'clockIn': '08:00 AM',
      'clockInStatus': 'On Time',
      'clockOut': '04:05 PM',
      'clockOutStatus': 'Normal Exit',
      'breakTime': '40 min',
      'breakTimeRange': '12:15 PM - 12:55 PM',
      'locationName': 'ST. JUDE CARE CENTER',
      'locationAddress': '124 Healthcare Plaza, North Wing Entrance, Suite 402',
      'gpsAccuracy': '2.9m',
      'netWorkingTime': '08.00',
      'scheduled': '08:00 hrs',
      'overtime': '00:00 hrs',
      'deficit': '00:00 hrs',
      'verifications': [
        {'title': 'Face-ID Recognition', 'subtitle': 'Matched at 08:00:02 AM', 'verified': true},
        {'title': 'Geofence Validation', 'subtitle': 'Within 6m radius of site', 'verified': true},
        {'title': 'Manager Review', 'subtitle': 'Auto-approved by system', 'verified': true},
      ],
    },
  ];

  static final List<Map<String, dynamic>> attendanceRecords = attendanceDailyRecords;

  // --- SCHEDULE FIXTURES ---
  static final Map<String, dynamic> scheduleSummary = {
    'dateTitle': 'THURSDAY, OCTOBER 24',
    'upcomingCount': 2,
    'completedCount': 4,
    'days': [
      {'day': 'MON', 'date': '21', 'active': false},
      {'day': 'TUE', 'date': '22', 'active': false},
      {'day': 'WED', 'date': '23', 'active': false},
      {'day': 'THU', 'date': '24', 'active': true},
      {'day': 'FRI', 'date': '25', 'active': false},
      {'day': 'SAT', 'date': '26', 'active': false},
    ],
  };

  static final List<Map<String, dynamic>> dailyScheduleTimeline = [
    {
      'id': 'sch-1',
      'time': '08:30 AM - 09:15 AM',
      'name': 'Arthur Morgan',
      'service': 'Wound Care Dressing',
      'serviceIcon': 'medical',
      'isCompleted': true,
      'isNext': false,
      'avatarUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    },
    {
      'id': 'sch-2',
      'time': '10:00 AM - 11:00 AM',
      'name': 'Evelyn Reed',
      'service': 'Meal Prep & Hydration',
      'serviceIcon': 'food',
      'isCompleted': true,
      'isNext': false,
      'avatarUrl': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
    },
    {
      'id': 'sch-3',
      'time': '01:00 PM - 02:30 PM (Starts in 15m)',
      'name': 'Johnathan Wick',
      'service': 'Medication Support',
      'services': ['Medication Support', 'Physio Assist'],
      'isCompleted': false,
      'isNext': true,
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    },
    {
      'id': 'sch-4',
      'time': '04:00 PM - 05:00 PM',
      'name': 'Sarah Jenkins',
      'service': 'Social Check-in',
      'serviceIcon': 'social',
      'isCompleted': false,
      'isNext': false,
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    },
  ];

  // --- TASKS FIXTURES ---
  static final List<Map<String, dynamic>> tasks = [
    {
      'id': 'tsk-102',
      'priority': 'High',
      'dueTime': 'Today, 5 PM',
      'title': 'Submit Incident Report #102',
      'description': 'Complete the fall assessment report for Room 304. Require signatures from the attending...',
      'tag': '2 Docs',
      'tagIcon': 'doc',
      'status': 'Pending',
      'detailTitle': 'Administer Evening Medication',
      'detailDue': 'Today, 8:00 PM',
      'detailDescription':
          'Please ensure the patient takes their prescribed cardiac medication following the evening meal. Monitor for any immediate side effects such as dizziness or nausea. Document the exact time of administration and the patient\'s vitals (BP and Heart Rate) prior to dosage.',
      'assignedTo': 'Sarah Mitchell, RN',
      'patient': 'Robert J. Henderson',
      'attachments': [
        {
          'name': 'Medication_Schedule.pdf',
          'size': '2.4 MB • PDF',
          'type': 'pdf',
        },
        {
          'name': 'Prescription_Label.jpg',
          'size': '1.1 MB • Image',
          'type': 'image',
        },
      ],
      'notes': [
        {
          'author': 'Dr. Aris Thorne',
          'time': '09:15 AM',
          'content': 'Confirmed dosage with the pharmacy. Please note patient prefers it with water, not juice.',
        },
        {
          'author': 'Morning Shift',
          'time': 'Yesterday',
          'content': 'Vitals have been stable all morning.',
        },
      ],
      'timeline': [
        {'title': 'Task Created', 'time': 'Today, 08:00 AM by System'},
        {'title': 'Assigned to Sarah Mitchell', 'time': 'Today, 09:30 AM'},
      ],
    },
    {
      'id': 'tsk-103',
      'priority': 'Medium',
      'dueTime': 'Tomorrow',
      'title': 'Medication Inventory Check',
      'description': 'Reconcile controlled substance log for the morning shift. Report any discrepancies...',
      'tag': 'Log Entry',
      'tagIcon': 'log',
      'status': 'Pending',
      'detailTitle': 'Medication Inventory Check',
      'detailDue': 'Tomorrow, 10:00 AM',
      'detailDescription':
          'Perform physical count of all schedule II medications in vault A and vault B. Compare count against electronic registry.',
      'assignedTo': 'Sarah Mitchell, RN',
      'patient': 'Floor Central Storage',
      'attachments': [
        {
          'name': 'Inventory_Checklist_Q3.pdf',
          'size': '1.8 MB • PDF',
          'type': 'pdf',
        },
      ],
      'notes': [
        {
          'author': 'Pharmacy Lead',
          'time': '08:00 AM',
          'content': 'New batch shipment arrived yesterday at 4 PM.',
        },
      ],
      'timeline': [
        {'title': 'Task Created', 'time': 'Yesterday, 04:30 PM by System'},
        {'title': 'Assigned to Sarah Mitchell', 'time': 'Today, 08:00 AM'},
      ],
    },
    {
      'id': 'tsk-104',
      'priority': 'Low',
      'dueTime': 'Oct 24',
      'title': 'Update Staff Bio Portal',
      'description': 'Ensure all caregiver certifications are uploaded and expiration dates are current in...',
      'tag': 'System',
      'tagIcon': 'system',
      'status': 'In Progress',
      'detailTitle': 'Update Staff Bio Portal',
      'detailDue': 'Oct 24, 05:00 PM',
      'detailDescription':
          'Check uploaded CPR and BLS credentials, verify dates and ensure state license profile is current for annual audit.',
      'assignedTo': 'Sarah Mitchell, RN',
      'patient': 'Self Verification',
      'attachments': [],
      'notes': [],
      'timeline': [
        {'title': 'Task Created', 'time': 'Oct 20, 09:00 AM by HR'},
      ],
    },
    {
      'id': 'tsk-105',
      'priority': 'High',
      'dueTime': 'Urgent',
      'title': 'Emergency Equipment Audit',
      'description': 'Validate AED battery levels and oxygen tank pressure across the East Wing stations.',
      'tag': 'Audit',
      'tagIcon': 'audit',
      'status': 'Pending',
      'detailTitle': 'Emergency Equipment Audit',
      'detailDue': 'Urgent (Within 2 hrs)',
      'detailDescription':
          'Conduct comprehensive checks on all AED units, emergency oxygen reservoirs, and crash carts in Station 3 and Station 4.',
      'assignedTo': 'Sarah Mitchell, RN',
      'patient': 'East Wing Stations',
      'attachments': [
        {
          'name': 'Safety_Protocol_Checklist.pdf',
          'size': '3.1 MB • PDF',
          'type': 'pdf',
        },
      ],
      'notes': [
        {
          'author': 'Safety Officer',
          'time': '07:30 AM',
          'content': 'East Wing AED 2 indicated low battery warning on routine telemetry check.',
        },
      ],
      'timeline': [
        {'title': 'Alert Triggered', 'time': 'Today, 07:15 AM by Telemetry'},
        {'title': 'Task Assigned', 'time': 'Today, 07:30 AM'},
      ],
    },
  ];

  // --- DOCUMENTS FIXTURES ---
  static final Map<String, dynamic> documentsVaultSummary = {
    'totalDocuments': 6,
    'usedStorage': '12.4 MB',
    'maxStorage': '100 MB',
    'usedRatio': 0.124,
  };

  static final List<Map<String, dynamic>> workspaceDocuments = [
    {
      'id': 'doc-1',
      'title': 'Educational Certificates',
      'fileName': 'Certification_HHA_2024.pdf',
      'fileType': 'PDF',
      'fileSize': '2.4 MB',
      'updatedDate': 'Updated May 12',
      'category': 'Verification',
      'verified': true,
      'iconType': 'certificate',
      'detailTitle': 'Home Health Aide Certification',
      'detailDescription':
          'Verified professional credential issued by the State Health Department. Essential for high-acuity care assignments.',
      'expirationDate': 'Expires Oct 12, 2025',
      'docType': 'Medical Certification',
      'issueDate': 'October 12, 2023',
      'issuer': 'State Dept of Health',
      'verificationHash': 'sha256:7f8e...3b21',
    },
    {
      'id': 'doc-2',
      'title': 'National Identity Card',
      'fileName': 'National_ID_Card.jpg',
      'fileType': 'JPG',
      'fileSize': '1.1 MB',
      'updatedDate': 'Updated Jan 04',
      'category': 'Verification',
      'verified': true,
      'iconType': 'id_card',
      'detailTitle': 'National Identity Card',
      'detailDescription': 'Official government issued identification verified by national registry.',
      'expirationDate': 'Expires Nov 20, 2030',
      'docType': 'Government ID',
      'issueDate': 'January 04, 2020',
      'issuer': 'Department of State Registry',
      'verificationHash': 'sha256:4a1b...99cc',
    },
    {
      'id': 'doc-3',
      'title': 'Police Verification Report',
      'fileName': 'Police_Verification_Report.pdf',
      'fileType': 'PDF',
      'fileSize': '4.2 MB',
      'updatedDate': 'Updated Aug 19',
      'category': 'Legal',
      'verified': true,
      'iconType': 'security',
      'detailTitle': 'Police Background Clearance',
      'detailDescription': 'Clear criminal history record and biometric check approved for senior care services.',
      'expirationDate': 'Expires Aug 19, 2027',
      'docType': 'Background Verification',
      'issueDate': 'August 19, 2024',
      'issuer': 'Metropolitan Police Dept',
      'verificationHash': 'sha256:11bb...ff42',
    },
    {
      'id': 'doc-4',
      'title': 'Medical Fitness Certificate',
      'fileName': 'Medical_Fitness_Cert.pdf',
      'fileType': 'PDF',
      'fileSize': '0.8 MB',
      'updatedDate': 'Updated Oct 22',
      'category': 'Health',
      'verified': true,
      'iconType': 'first_aid',
      'detailTitle': 'Annual Medical Fitness Report',
      'detailDescription': 'Comprehensive occupational health screening including TB test and immunization records.',
      'expirationDate': 'Expires Oct 22, 2025',
      'docType': 'Medical Examination',
      'issueDate': 'October 22, 2024',
      'issuer': 'Providence Health Clinic',
      'verificationHash': 'sha256:88ac...23de',
    },
    {
      'id': 'doc-5',
      'title': 'Professional Insurance',
      'fileName': 'Professional_Liability_Policy.pdf',
      'fileType': 'PDF',
      'fileSize': '3.5 MB',
      'updatedDate': 'Updated Feb 15',
      'category': 'Legal',
      'verified': true,
      'iconType': 'insurance',
      'detailTitle': 'Professional Liability Insurance',
      'detailDescription': 'Active clinical malpractice coverage up to \$2,000,000 aggregate policy.',
      'expirationDate': 'Expires Feb 15, 2026',
      'docType': 'Insurance Policy',
      'issueDate': 'February 15, 2024',
      'issuer': 'CareShield Mutual Group',
      'verificationHash': 'sha256:77fa...8100',
    },
    {
      'id': 'doc-6',
      'title': 'Employment Offer Letter',
      'fileName': 'Employment_Agreement.pdf',
      'fileType': 'PDF',
      'fileSize': '1.2 MB',
      'updatedDate': 'Updated Nov 30',
      'category': 'Legal',
      'verified': true,
      'iconType': 'letter',
      'detailTitle': 'Employment Agreement',
      'detailDescription': 'Official signed contract for Senior Care Coordinator position.',
      'expirationDate': 'Indefinite',
      'docType': 'Employment Agreement',
      'issueDate': 'March 12, 2018',
      'issuer': 'Lumina Healthcare Systems',
      'verificationHash': 'sha256:99de...1123',
    },
  ];

  static final List<Map<String, dynamic>> documentSecurityLogs = [
    {
      'title': 'Employment Letter Viewed',
      'subtitle': 'by Workspace Admin • 2h ago',
      'color': 'green',
    },
    {
      'title': 'Identity Card Updated',
      'subtitle': 'by You • Yesterday',
      'color': 'blue',
    },
  ];

  // --- TRAINING FIXTURES ---
  static final Map<String, dynamic> trainingHero = {
    'title': 'Level up\nyour\nprofessional\ncare skills.',
    'subtitle': "You're only two modules away from your Senior Caregiver Certification.",
    'buttonLabel': 'Continue Learning',
  };

  static final List<Map<String, dynamic>> trainingCertifications = [
    {'title': 'Core Essentials', 'color': 'green', 'icon': 'check'},
    {'title': 'First Aid 2024', 'color': 'blue', 'icon': 'medical_bag'},
    {'title': 'CPR Senior', 'color': 'green', 'icon': 'heart'},
  ];

  static final List<Map<String, dynamic>> assignedCourses = [
    {
      'id': 'crs-1',
      'title': 'Patient Empathy & Communication',
      'dueLabel': 'Due in 3 days',
      'description': 'Advanced techniques for navigating challenging elder communication scenarios...',
      'progress': 0.65,
      'progressText': 'Progress: 65%',
      'lessonsText': '4/6 Lessons',
      'imageUrl': 'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?w=600',
    },
    {
      'id': 'crs-2',
      'title': 'Emergency Response Protocols',
      'dueLabel': 'Mandatory',
      'description': 'Updated 2024 standards for cardiac and respiratory critical care response in home...',
      'progress': 0.12,
      'progressText': 'Progress: 12%',
      'lessonsText': '1/8 Lessons',
      'imageUrl': 'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=600',
    },
  ];

  static final List<Map<String, dynamic>> completedTraining = [
    {'title': 'Ethics in Caregiving', 'date': 'Completed June 12'},
    {'title': 'Medication Management', 'date': 'Completed May 28'},
    {'title': 'Nutrition Basics', 'date': 'Completed May 15'},
  ];

  static final List<Map<String, dynamic>> trainingCourses = assignedCourses;

  static final Map<String, dynamic> courseDetailData = {
    'badges': ['ADVANCED CARE', 'CPD ACCREDITED'],
    'title': 'Post-Operative Geriatric Support',
    'description':
        'Comprehensive methodologies for managing mobility recovery, medication adherence, and psychological well-being for elderly patients following major surgical procedures.',
    'duration': '4h 30m',
    'modulesCount': '6 Lessons',
    'credits': '2.5 CEUs',
    'curriculumCompletedCount': '4/6 Complete',
    'curriculum': [
      {
        'index': 1,
        'title': '1. Introduction to Post-Op Vital Signs',
        'subtitle': '15 mins • Completed Oct 12',
        'status': 'completed',
      },
      {
        'index': 2,
        'title': '2. Pain Management Protocols',
        'subtitle': '45 mins • Completed Oct 14',
        'status': 'completed',
      },
      {
        'index': 3,
        'title': '3. Assisted Ambulation Techniques',
        'subtitle': '60 mins • Continue Learning',
        'status': 'in_progress',
        'progress': 0.65,
      },
      {
        'index': 4,
        'title': '4. Nutritional Support & Hydration',
        'subtitle': '30 mins • Locked',
        'status': 'locked',
      },
      {
        'index': 5,
        'title': '5. Psychological Well-being after Surgery',
        'subtitle': '45 mins • Locked',
        'status': 'locked',
      },
    ],
    'courseProgress': {
      'percentage': 67,
      'modulesPassed': '4 of 6',
      'avgQuizScore': '92%',
      'estCompletion': '~1.5 hrs left',
    },
    'instructor': {
      'name': 'Dr. Elena Rodriguez',
      'title': 'Chief of Geriatric Care',
      'avatarUrl': 'https://images.unsplash.com/photo-1594824813637-a2f0293027b4?w=400',
    },
    'resources': [
      {'title': 'Support Handbook (PDF)', 'type': 'pdf'},
      {'title': 'Video Lectures (12)', 'type': 'video'},
      {'title': 'Final Exam Practice', 'type': 'quiz'},
    ],
  };

  // --- SETTINGS & PRIVACY FIXTURES ---
  static final Map<String, dynamic> privacySettings = {
    'visibilityToFamilies': true,
    'activityLogging': true,
    'dataSharing': 'Limited Access',
    'permissions': [
      {'title': 'Location Services', 'subtitle': 'Required for clock-in/out verification', 'status': 'ALWAYS', 'icon': 'location'},
      {'title': 'Camera Access', 'subtitle': 'For scanning medication barcodes', 'status': 'WHILE USING', 'icon': 'camera'},
      {'title': 'Push Notifications', 'subtitle': 'Critical alerts and task reminders', 'status': 'ENABLED', 'icon': 'bell'},
    ],
    'twoFactorConfigured': false,
    'recentActivity': [
      {'title': 'Successful Login', 'subtitle': 'Chrome on MacBook Pro • San Francisco, CA', 'status': 'Just Now', 'type': 'success'},
      {'title': 'App Session Started', 'subtitle': 'Caregiver App (iOS) • Oakland, CA', 'status': '2h ago', 'type': 'neutral'},
      {'title': 'Failed Login Attempt', 'subtitle': 'Edge on Windows • London, UK (VPN detected)', 'status': 'Oct 24, 08:12 PM', 'type': 'warning'},
    ],
    'devices': [
      {'name': 'MacBook Pro 14"', 'isCurrent': true, 'lastActive': 'CURRENT DEVICE'},
      {'name': 'iPhone 15 Pro', 'isCurrent': false, 'lastActive': 'Last active: 2 hours ago'},
      {'name': 'Clinic iPad Station', 'isCurrent': false, 'lastActive': 'Last active: 5 days ago'},
    ],
  };

  static final Map<String, dynamic> aboutAppInfo = {
    'title': 'Caregiver Workspace',
    'tagline': 'Empathetic Precision for Modern Care Management.',
    'version': 'VERSION 2.4.0 (STABLE)',
    'buildNumber': '2024.08.31.WS-31',
    'organization': {
      'name': 'Lumina Healthcare Systems Inc.',
      'description': 'Dedicated to elevating the standard of elder care through intuitive technology and human-centered design.',
      'badge': 'Licensed Global Provider',
    },
    'links': [
      {'title': 'Terms & Conditions', 'subtitle': 'Last updated July 2024'},
      {'title': 'Privacy Policy', 'subtitle': 'How we protect your data'},
      {'title': 'Contact Support', 'subtitle': '24/7 dedicated caregiver assistance'},
    ],
  };
}
