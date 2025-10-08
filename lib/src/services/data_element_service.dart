import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/data_element.dart';

/// Service for managing Data Element data
/// Loads and provides access to data elements from bundled JSON assets
class DataElementService {
  // Private constructor for singleton pattern
  DataElementService._();

  /// Singleton instance
  static final DataElementService instance = DataElementService._();

  /// Cached list of all data elements
  List<DataElement>? _dataElements;

  /// Cached list of all categories
  List<DataElementCategory>? _categories;

  /// Whether data has been loaded
  bool get isLoaded => _dataElements != null && _categories != null;

  /// Loads all data elements and categories from assets
  /// Throws: FormatException if JSON is malformed
  Future<void> loadDataElements() async {
    try {
      // Load data elements JSON
      final elementsJson =
          await rootBundle.loadString('assets/data/data_elements.json');
      final elementsList = jsonDecode(elementsJson) as List<dynamic>;
      _dataElements = elementsList
          .map((json) => DataElement.fromJson(json as Map<String, dynamic>))
          .toList();

      // Load categories JSON
      final categoriesJson = await rootBundle
          .loadString('assets/data/data_element_categories.json');
      final categoriesList = jsonDecode(categoriesJson) as List<dynamic>;
      _categories = categoriesList
          .map((json) =>
              DataElementCategory.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort categories by display order
      _categories!.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    } catch (e) {
      throw FormatException('Failed to load data element data: $e');
    }
  }

  /// Returns all data element categories sorted by displayOrder
  List<DataElementCategory> getAllCategories() {
    if (_categories == null) {
      throw StateError(
          'Data elements not loaded. Call loadDataElements() first.');
    }
    return List.unmodifiable(_categories!);
  }

  /// Returns data elements for a specific category
  List<DataElement> getDataElementsByCategory(String categoryId) {
    if (_dataElements == null) {
      throw StateError(
          'Data elements not loaded. Call loadDataElements() first.');
    }

    final filtered =
        _dataElements!.where((element) => element.category == categoryId).toList();
    return filtered;
  }

  /// Returns all data elements
  List<DataElement> getAllDataElements() {
    if (_dataElements == null) {
      throw StateError(
          'Data elements not loaded. Call loadDataElements() first.');
    }
    return List.unmodifiable(_dataElements!);
  }

  /// Searches data elements by name, shortname, or definition
  List<DataElement> searchDataElements(String query) {
    if (_dataElements == null) {
      throw StateError(
          'Data elements not loaded. Call loadDataElements() first.');
    }

    final lowerQuery = query.toLowerCase();
    return _dataElements!.where((element) {
      return element.name.toLowerCase().contains(lowerQuery) ||
          element.shortname.toLowerCase().contains(lowerQuery) ||
          element.definition.toLowerCase().contains(lowerQuery) ||
          element.id.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Returns a single data element by its ID
  DataElement? getDataElementById(String id) {
    if (_dataElements == null) {
      throw StateError(
          'Data elements not loaded. Call loadDataElements() first.');
    }

    try {
      return _dataElements!.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Returns total count of data elements
  Map<String, int> getStatistics() {
    if (_dataElements == null || _categories == null) {
      return {'dataElements': 0, 'categories': 0};
    }

    return {
      'dataElements': _dataElements!.length,
      'categories': _categories!.length,
    };
  }
}
