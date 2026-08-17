class ProtocolCategory {
  final String id;
  final String title;
  final String description;
  final int count;

  const ProtocolCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.count,
  });

  factory ProtocolCategory.fromJson(Map<String, dynamic> json) {
    return ProtocolCategory(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class ProtocolSummary {
  final String id;
  final String categoryId;
  final String title;
  final String summaryText;
  final String lastUpdated;

  const ProtocolSummary({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summaryText,
    required this.lastUpdated,
  });

  factory ProtocolSummary.fromJson(Map<String, dynamic> json) {
    return ProtocolSummary(
      id: json['id'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summaryText: json['summaryText'] as String? ?? '',
      lastUpdated: json['lastUpdated'] as String? ?? '',
    );
  }
}

class ProtocolDetail {
  final ProtocolSummary summary;
  final List<String> clinicalSteps;
  final List<String> contraindications;
  final String emergencyEscalationCriteria;

  const ProtocolDetail({
    required this.summary,
    required this.clinicalSteps,
    required this.contraindications,
    required this.emergencyEscalationCriteria,
  });

  factory ProtocolDetail.fromJson(Map<String, dynamic> json) {
    return ProtocolDetail(
      summary: ProtocolSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      clinicalSteps: (json['clinicalSteps'] as List?)?.map((e) => e.toString()).toList() ?? [],
      contraindications: (json['contraindications'] as List?)?.map((e) => e.toString()).toList() ?? [],
      emergencyEscalationCriteria: json['emergencyEscalationCriteria'] as String? ?? '',
    );
  }
}
