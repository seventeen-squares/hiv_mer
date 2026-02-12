/// Model representing a Data Element in the NIDS system
class DataElement {
  final String id;
  final String name;
  final String shortname;
  final String definition;
  final String category;
  final String dataType;
  final String aggregationType;
  final DataElementStatus status;

  // New comprehensive fields from CSV
  final String definitionExtended;
  final String useAndContext;
  final String inclusions;
  final String exclusions;
  final String frequency;
  final String collectedBy;
  final String collectionPoints;
  final String tools;

  DataElement({
    required this.id,
    required this.name,
    required this.shortname,
    required this.definition,
    required this.category,
    required this.dataType,
    required this.aggregationType,
    required this.status,
    this.definitionExtended = '',
    this.useAndContext = '',
    this.inclusions = '',
    this.exclusions = '',
    this.frequency = '',
    this.collectedBy = '',
    this.collectionPoints = '',
    this.tools = '',
  });

  factory DataElement.fromJson(Map<String, dynamic> json) {
    return DataElement(
      id: json['id'] as String,
      name: json['name'] as String,
      shortname: json['shortname'] as String? ?? json['name'] as String,
      definition: json['definition'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      dataType: json['dataType'] as String? ?? 'Number',
      aggregationType: json['aggregationType'] as String? ?? 'Sum',
      status: _parseStatus(json['status'] as String?),
      definitionExtended: json['definitionExtended'] as String? ?? '',
      useAndContext: json['useAndContext'] as String? ?? '',
      inclusions: json['inclusions'] as String? ?? '',
      exclusions: json['exclusions'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      collectedBy: json['collectedBy'] as String? ?? '',
      collectionPoints: json['collectionPoints'] as String? ?? '',
      tools: json['tools'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortname': shortname,
      'definition': definition,
      'category': category,
      'dataType': dataType,
      'aggregationType': aggregationType,
      'status': status.toString().split('.').last,
      'definitionExtended': definitionExtended,
      'useAndContext': useAndContext,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'frequency': frequency,
      'collectedBy': collectedBy,
      'collectionPoints': collectionPoints,
      'tools': tools,
    };
  }

  static DataElementStatus _parseStatus(String? status) {
    if (status == null) return DataElementStatus.retained;
    switch (status.toLowerCase()) {
      case 'new':
        return DataElementStatus.newElement;
      case 'amended':
        return DataElementStatus.amended;
      case 'retained':
        return DataElementStatus.retained;
      default:
        return DataElementStatus.retained;
    }
  }
}

/// Status of a data element (new, amended, or retained)
enum DataElementStatus {
  newElement,
  amended,
  retained,
}

/// Model representing a category of data elements
class DataElementCategory {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final int elementCount;
  final int displayOrder;

  DataElementCategory({
    required this.id,
    required this.name,
    this.description = '',
    this.icon,
    required this.elementCount,
    required this.displayOrder,
  });

  factory DataElementCategory.fromJson(Map<String, dynamic> json) {
    return DataElementCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String?,
      elementCount: json['elementCount'] as int? ?? 0,
      displayOrder: json['displayOrder'] as int? ?? 999,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'elementCount': elementCount,
      'displayOrder': displayOrder,
    };
  }
}
