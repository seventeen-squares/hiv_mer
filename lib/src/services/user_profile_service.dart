import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';

/// Service for managing user profile and role selection
/// Uses SharedPreferences for local storage
class UserProfileService {
  // Private constructor for singleton pattern
  UserProfileService._();

  /// Singleton instance
  static final UserProfileService instance = UserProfileService._();

  /// Cached SharedPreferences instance
  SharedPreferences? _prefs;

  /// Get SharedPreferences instance
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Checks if user has completed first-launch role selection
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await _preferences;
    return prefs.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
  }

  /// Saves user profile to SharedPreferences
  /// Returns: true if successful, false otherwise
  Future<bool> saveProfile(UserProfile profile) async {
    try {
      final prefs = await _preferences;
      final jsonString = jsonEncode(profile.toJson());

      // Save profile data
      final success = await prefs.setString(StorageKeys.userProfile, jsonString);
      
      if (success) {
        // Mark onboarding as complete
        await prefs.setBool(StorageKeys.hasCompletedOnboarding, true);
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves saved user profile
  /// Returns: null if no profile exists
  Future<UserProfile?> getProfile() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(StorageKeys.userProfile);

      if (jsonString == null) {
        return null;
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Updates existing profile (for settings screen)
  /// Returns: true if successful, false otherwise
  Future<bool> updateProfile(UserProfile profile) async {
    // Update is the same as save for SharedPreferences
    return saveProfile(profile);
  }

  /// Clears profile (for testing/reset)
  Future<void> clearProfile() async {
    final prefs = await _preferences;
    await prefs.remove(StorageKeys.userProfile);
    await prefs.remove(StorageKeys.hasCompletedOnboarding);
  }

  /// Get display text for current role (convenience method)
  Future<String?> getCurrentRoleDisplayText() async {
    final profile = await getProfile();
    return profile?.roleDisplayText;
  }
}
