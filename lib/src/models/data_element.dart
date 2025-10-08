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

  DataElement({
    required this.id,
    required this.name,
    required this.shortname,
    required this.definition,
    required this.category,
    required this.dataType,
    required this.aggregationType,
    required this.status,
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
  final int elementCount;
  final int displayOrder;

  DataElementCategory({
    required this.id,
    required this.name,
    required this.elementCount,
    required this.displayOrder,
  });

  factory DataElementCategory.fromJson(Map<String, dynamic> json) {
    return DataElementCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      elementCount: json['elementCount'] as int? ?? 0,
      displayOrder: json['displayOrder'] as int? ?? 999,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'elementCount': elementCount,
      'displayOrder': displayOrder,
    };
  }
}
