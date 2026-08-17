class SupportFixtures {
  static final List<Map<String, dynamic>> supportTopics = [
    {
      'id': 'supp-1',
      'title': 'Ops Hotline & Field Support',
      'description': 'Direct contact with Ops Lead for scheduling, access, or route emergencies.',
      'contact': '+1 (800) 555-CARE',
    },
    {
      'id': 'supp-2',
      'title': 'Clinical Advisory Desk',
      'description': 'On-call Senior Nurse Practitioner for medication or condition consults.',
      'contact': '+1 (800) 555-NURSE',
    },
    {
      'id': 'supp-3',
      'title': 'Equipment & Supplies Requisition',
      'description': 'Request BP cuffs, gloves, dressings, or tablet replacement.',
      'contact': 'supplies@parentcare.com',
    },
  ];

  static final List<Map<String, dynamic>> tickets = [
    {
      'id': 'tck-101',
      'subject': 'GPS Check-In Offset at Evergreen Terrace',
      'category': 'App Technical Issue',
      'status': 'Open',
      'createdAt': 'Yesterday, 02:15 PM',
      'lastUpdate': 'Ops reviewing location radius settings.',
    },
    {
      'id': 'tck-102',
      'subject': 'Replacement Request: Digital Stethoscope',
      'category': 'Equipment',
      'status': 'In Progress',
      'createdAt': 'Aug 02, 2026',
      'lastUpdate': 'Replacement shipped via courier.',
    },
  ];
}
