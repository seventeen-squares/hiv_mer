/// App-wide constants for NIDS application
library;

import 'package:flutter/material.dart';

/// User role enumeration for role selection
enum UserRole {
  nurse,
  doctor,
  dataClerk,
  programManager,
  pharmacist,
  communityHealthWorker,
  other,
}

/// Human-readable labels for user roles
const Map<UserRole, String> roleLabels = {
  UserRole.nurse: 'Nurse',
  UserRole.doctor: 'Doctor',
  UserRole.dataClerk: 'Data Clerk',
  UserRole.programManager: 'Program Manager',
  UserRole.pharmacist: 'Pharmacist',
  UserRole.communityHealthWorker: 'Community Health Worker',
  UserRole.other: 'Other',
};

/// South African government green color (primary brand color)
/// TODO: Update with official hex value from Department of Health branding guidelines
/// Current value is approximation pending official confirmation
const Color saGovernmentGreen = Color(0xFF007A4D);

/// Material color swatch for SA government green (for theme usage)
const MaterialColor saGovernmentGreenSwatch = MaterialColor(
  0xFF007A4D,
  <int, Color>{
    50: Color(0xFFE0F2EC),
    100: Color(0xFFB3DFD0),
    200: Color(0xFF80CAB1),
    300: Color(0xFF4DB492),
    400: Color(0xFF26A47A),
    500: Color(0xFF007A4D), // Primary color
    600: Color(0xFF007246),
    700: Color(0xFF00673D),
    800: Color(0xFF005D35),
    900: Color(0xFF004A25),
  },
);

/// App version format constant
/// Format: v.YYYY.MM (e.g., v.2025.10)
String getVersionFormat(DateTime releaseDate) {
  return 'v.${releaseDate.year}.${releaseDate.month.toString().padLeft(2, '0')}';
}

/// Current app version
const String appVersion = 'v.2025.10';

/// App name constant
const String appName = 'National Indicator Data Set (NIDS)';

/// Department branding text
const String departmentBranding =
    'Department: Health\nREPUBLIC OF SOUTH AFRICA';

/// Storage keys for SharedPreferences
class StorageKeys {
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String userProfile = 'user_profile';
  static const String favoriteIndicators = 'favorite_indicators';
}
