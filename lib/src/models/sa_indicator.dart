/// South African National Health Indicator model
/// Represents an indicator from the National Indicator Data Set (NIDS)
class SAIndicator {
  /// Reno/ID field - unique identifier in the NIDS system
  final String renoId;

  /// Group ID - links to IndicatorGroup
  final String groupId;

  /// Indicator ID - unique indicator identifier
  final String indicatorId;

  /// Sort order within the group
  final int sortOrder;

  /// Full indicator name
  final String name;

  /// Abbreviated/short name
  final String shortname;

  /// Numerator description
  final String numerator;

  /// Optional numerator formula
  final String? numeratorFormula;

  /// Denominator description (nullable for some indicators)
  final String? denominator;

  /// Optional denominator formula
  final String? denominatorFormula;

  /// Full definition text
  final String definition;

  /// Use and Context guidance
  final String useContext;

  /// Factor/Type classification
  final String factorType;

  /// Reporting frequency (Monthly, Quarterly, etc.)
  final String frequency;

  /// Indicator status (NEW, AMENDED, RETAINED_WITH_NEW, RETAINED_WITHOUT_NEW)
  final IndicatorStatus status;

  const SAIndicator({
    required this.renoId,
    required this.groupId,
    required this.indicatorId,
    required this.sortOrder,
    required this.name,
    required this.shortname,
    required this.numerator,
    this.numeratorFormula,
    this.denominator,
    this.denominatorFormula,
    required this.definition,
    required this.useContext,
    required this.factorType,
    required this.frequency,
    required this.status,
  });

  /// Create SAIndicator from JSON
  factory SAIndicator.fromJson(Map<String, dynamic> json) {
    return SAIndicator(
      renoId: json['renoId'] as String? ?? '',
      groupId: json['groupId'] as String? ?? '',
      indicatorId: json['indicatorId'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      shortname: json['shortname'] as String? ?? '',
      numerator: json['numerator'] as String? ?? '',
      numeratorFormula: json['numeratorFormula'] as String?,
      denominator: json['denominator'] as String?,
      denominatorFormula: json['denominatorFormula'] as String?,
      definition: json['definition'] as String? ?? '',
      useContext: json['useContext'] as String? ?? '',
      factorType: json['factorType'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      status: _statusFromString(json['status'] as String?),
    );
  }

  /// Convert SAIndicator to JSON
  Map<String, dynamic> toJson() {
    return {
      'renoId': renoId,
      'groupId': groupId,
      'indicatorId': indicatorId,
      'sortOrder': sortOrder,
      'name': name,
      'shortname': shortname,
      'numerator': numerator,
      'numeratorFormula': numeratorFormula,
      'denominator': denominator,
      'denominatorFormula': denominatorFormula,
      'definition': definition,
      'useContext': useContext,
      'factorType': factorType,
      'frequency': frequency,
      'status': status.toString().split('.').last,
    };
  }

  /// Parse status from string
  static IndicatorStatus _statusFromString(String? status) {
    if (status == null) return IndicatorStatus.retainedWithoutNew;
    
    switch (status.toLowerCase()) {
      case 'new':
      case 'newindicator':
        return IndicatorStatus.newIndicator;
      case 'amended':
        return IndicatorStatus.amended;
      case 'retained_with_new':
      case 'retainedwithnew':
        return IndicatorStatus.retainedWithNew;
      case 'retained_without_new':
      case 'retainedwithoutnew':
      default:
        return IndicatorStatus.retainedWithoutNew;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SAIndicator &&
        other.renoId == renoId &&
        other.indicatorId == indicatorId;
  }

  @override
  int get hashCode => Object.hash(renoId, indicatorId);

  @override
  String toString() {
    return 'SAIndicator(renoId: $renoId, indicatorId: $indicatorId, name: $name)';
  }
}

/// Indicator status enum
enum IndicatorStatus {
  /// New indicator
  newIndicator,

  /// Amended indicator
  amended,

  /// Retained with new data elements
  retainedWithNew,

  /// Retained without new data elements
  retainedWithoutNew,
}
