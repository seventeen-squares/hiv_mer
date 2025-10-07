import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/sa_indicator.dart';
import '../models/indicator_group.dart';

/// Service for managing South African national indicator data
/// Loads and provides access to indicators from bundled JSON assets
class SAIndicatorService {
  // Private constructor for singleton pattern
  SAIndicatorService._();
  
  /// Singleton instance
  static final SAIndicatorService instance = SAIndicatorService._();

  /// Cached list of all indicators
  List<SAIndicator>? _indicators;

  /// Cached list of all groups
  List<IndicatorGroup>? _groups;

  /// Whether data has been loaded
  bool get isLoaded => _indicators != null && _groups != null;

  /// Loads all indicators and groups from assets
  /// Throws: FormatException if JSON is malformed
  /// Performance: Must complete in < 2 seconds
  Future<void> loadIndicators() async {
    try {
      // Load indicators JSON
      final indicatorsJson = await rootBundle.loadString('assets/data/sa_indicators.json');
      final indicatorsList = jsonDecode(indicatorsJson) as List<dynamic>;
      _indicators = indicatorsList
          .map((json) => SAIndicator.fromJson(json as Map<String, dynamic>))
          .toList();

      // Load groups JSON
      final groupsJson = await rootBundle.loadString('assets/data/indicator_groups.json');
      final groupsList = jsonDecode(groupsJson) as List<dynamic>;
      _groups = groupsList
          .map((json) => IndicatorGroup.fromJson(json as Map<String, dynamic>))
          .toList();

      // Sort groups by display order
      _groups!.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    } catch (e) {
      throw FormatException('Failed to load indicator data: $e');
    }
  }

  /// Returns all indicator groups sorted by displayOrder
  List<IndicatorGroup> getAllGroups() {
    if (_groups == null) {
      throw StateError('Indicators not loaded. Call loadIndicators() first.');
    }
    return List.unmodifiable(_groups!);
  }

  /// Returns indicators for a specific group, sorted by sortOrder
  List<SAIndicator> getIndicatorsByGroup(String groupId) {
    if (_indicators == null) {
      throw StateError('Indicators not loaded. Call loadIndicators() first.');
    }

    final filtered = _indicators!
        .where((indicator) => indicator.groupId == groupId)
        .toList();

    // Sort by sortOrder
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return filtered;
  }

  /// Searches indicators by name, shortname, indicatorId, or definition
  /// Performance: Must return in < 500ms
  List<SAIndicator> searchIndicators(String query) {
    if (_indicators == null) {
      throw StateError('Indicators not loaded. Call loadIndicators() first.');
    }

    if (query.isEmpty) {
      return [];
    }

    final lowerQuery = query.toLowerCase();
    final results = <SAIndicator>[];
    final exactMatches = <SAIndicator>[];
    final nameMatches = <SAIndicator>[];
    final otherMatches = <SAIndicator>[];

    for (final indicator in _indicators!) {
      // Check for exact ID match (highest priority)
      if (indicator.indicatorId.toLowerCase() == lowerQuery) {
        exactMatches.add(indicator);
        continue;
      }

      // Check for partial ID match or name/shortname match
      if (indicator.indicatorId.toLowerCase().contains(lowerQuery)) {
        exactMatches.add(indicator);
        continue;
      }

      if (indicator.name.toLowerCase().contains(lowerQuery) ||
          indicator.shortname.toLowerCase().contains(lowerQuery)) {
        nameMatches.add(indicator);
        continue;
      }

      // Check definition
      if (indicator.definition.toLowerCase().contains(lowerQuery)) {
        otherMatches.add(indicator);
      }
    }

    // Combine results in priority order
    results.addAll(exactMatches);
    results.addAll(nameMatches);
    results.addAll(otherMatches);

    return results;
  }

  /// Returns a single indicator by its indicatorId
  SAIndicator? getIndicatorById(String indicatorId) {
    if (_indicators == null) {
      throw StateError('Indicators not loaded. Call loadIndicators() first.');
    }

    try {
      return _indicators!.firstWhere(
        (indicator) => indicator.indicatorId == indicatorId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Returns total count of indicators and data elements
  /// Returns map with keys: 'indicators' and 'dataElements'
  Map<String, int> getStatistics() {
    if (_indicators == null || _groups == null) {
      throw StateError('Indicators not loaded. Call loadIndicators() first.');
    }

    // For now, data elements count is a placeholder (multiply indicators by ~2)
    // This should be updated when actual data element data is available
    final indicatorCount = _indicators!.length;
    final dataElementCount = indicatorCount * 2; // Approximate

    return {
      'indicators': indicatorCount,
      'dataElements': dataElementCount,
    };
  }

  /// Clears cached data (useful for testing)
  void clearCache() {
    _indicators = null;
    _groups = null;
  }
}
