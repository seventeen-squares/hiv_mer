import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Service for managing favorite indicators
/// Uses SharedPreferences for local storage
class FavoritesService {
  // Private constructor for singleton pattern
  FavoritesService._();

  /// Singleton instance
  static final FavoritesService instance = FavoritesService._();

  /// Cached SharedPreferences instance
  SharedPreferences? _prefs;

  /// Get SharedPreferences instance
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get list of favorite indicator IDs
  Future<List<String>> getFavoriteIds() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(StorageKeys.favoriteIndicators);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      // If there's an error decoding, return empty list
      return [];
    }
  }

  /// Check if an indicator is favorited
  Future<bool> isFavorite(String indicatorId) async {
    final favorites = await getFavoriteIds();
    return favorites.contains(indicatorId);
  }

  /// Add an indicator to favorites
  /// Returns true if successfully added, false if already exists
  Future<bool> addFavorite(String indicatorId) async {
    final favorites = await getFavoriteIds();
    
    // Check if already favorited
    if (favorites.contains(indicatorId)) {
      return false;
    }

    // Add to list
    favorites.add(indicatorId);

    // Save to preferences
    final prefs = await _preferences;
    final jsonString = jsonEncode(favorites);
    return await prefs.setString(StorageKeys.favoriteIndicators, jsonString);
  }

  /// Remove an indicator from favorites
  /// Returns true if successfully removed, false if not in favorites
  Future<bool> removeFavorite(String indicatorId) async {
    final favorites = await getFavoriteIds();
    
    // Check if in favorites
    if (!favorites.contains(indicatorId)) {
      return false;
    }

    // Remove from list
    favorites.remove(indicatorId);

    // Save to preferences
    final prefs = await _preferences;
    final jsonString = jsonEncode(favorites);
    return await prefs.setString(StorageKeys.favoriteIndicators, jsonString);
  }

  /// Toggle favorite status for an indicator
  /// Returns the new favorite status (true if now favorited, false if unfavorited)
  Future<bool> toggleFavorite(String indicatorId) async {
    final isFav = await isFavorite(indicatorId);
    
    if (isFav) {
      await removeFavorite(indicatorId);
      return false;
    } else {
      await addFavorite(indicatorId);
      return true;
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    final prefs = await _preferences;
    await prefs.remove(StorageKeys.favoriteIndicators);
  }

  /// Get count of favorite indicators
  Future<int> getFavoriteCount() async {
    final favorites = await getFavoriteIds();
    return favorites.length;
  }
}
