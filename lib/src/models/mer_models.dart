class MERIndicator {
  final String code;
  final String name;
  final String definition;
  final String numerator;
  final String denominator;
  final List<String> disaggregations;
  final String frequency;
  final String notes;
  final String source;
  final String programArea;

  const MERIndicator({
    required this.code,
    required this.name,
    required this.definition,
    required this.numerator,
    required this.denominator,
    required this.disaggregations,
    required this.frequency,
    required this.notes,
    required this.source,
    required this.programArea,
  });

  factory MERIndicator.fromJson(Map<String, dynamic> json) {
    return MERIndicator(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      definition: json['definition'] ?? '',
      numerator: json['numerator'] ?? '',
      denominator: json['denominator'] ?? '',
      disaggregations: List<String>.from(json['disaggregations'] ?? []),
      frequency: json['frequency'] ?? '',
      notes: json['notes'] ?? '',
      source: json['source'] ?? '',
      programArea: json['programArea'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'definition': definition,
      'numerator': numerator,
      'denominator': denominator,
      'disaggregations': disaggregations,
      'frequency': frequency,
      'notes': notes,
      'source': source,
      'programArea': programArea,
    };
  }
}

class ProgramArea {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;

  const ProgramArea({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  factory ProgramArea.fromJson(Map<String, dynamic> json) {
    return ProgramArea(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

class KeyFact {
  final String title;
  final String value;
  final String description;
  final String trend;
  final String? subtitle;

  const KeyFact({
    required this.title,
    required this.value,
    required this.description,
    required this.trend,
    this.subtitle,
  });

  factory KeyFact.fromJson(Map<String, dynamic> json) {
    return KeyFact(
      title: json['title'] ?? '',
      value: json['value'] ?? '',
      description: json['description'] ?? '',
      trend: json['trend'] ?? '',
      subtitle: json['subtitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'description': description,
      'trend': trend,
      'subtitle': subtitle,
    };
  }
}
