/// Indicator Group model for organizing SA national health indicators
/// Groups indicators by reporting category (e.g., Routine Facility Health Services, TB Quarterly)
class IndicatorGroup {
  /// Unique group identifier
  final String id;

  /// Display name of the group
  final String name;

  /// Sort order for displaying groups
  final int displayOrder;

  /// Sub-categories within this group
  final List<String> subGroups;

  /// Total number of indicators in this group
  final int indicatorCount;

  const IndicatorGroup({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.subGroups,
    required this.indicatorCount,
  });

  /// Create IndicatorGroup from JSON
  factory IndicatorGroup.fromJson(Map<String, dynamic> json) {
    return IndicatorGroup(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 0,
      subGroups: (json['subGroups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      indicatorCount: json['indicatorCount'] as int? ?? 0,
    );
  }

  /// Convert IndicatorGroup to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayOrder': displayOrder,
      'subGroups': subGroups,
      'indicatorCount': indicatorCount,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IndicatorGroup && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'IndicatorGroup(id: $id, name: $name, indicatorCount: $indicatorCount)';
  }
}
