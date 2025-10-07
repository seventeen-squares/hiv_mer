import '../utils/constants.dart';

/// User profile model for storing user role and preferences
class UserProfile {
  /// Selected user role
  final UserRole role;

  /// Custom role text (when role is UserRole.other)
  final String? customRoleText;

  /// Date when role was selected or last updated
  final DateTime selectionDate;

  const UserProfile({
    required this.role,
    this.customRoleText,
    required this.selectionDate,
  });

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      role: _roleFromString(json['role'] as String?),
      customRoleText: json['customRoleText'] as String?,
      selectionDate: json['selectionDate'] != null
          ? DateTime.parse(json['selectionDate'] as String)
          : DateTime.now(),
    );
  }

  /// Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'role': role.toString().split('.').last,
      'customRoleText': customRoleText,
      'selectionDate': selectionDate.toIso8601String(),
    };
  }

  /// Parse role from string
  static UserRole _roleFromString(String? roleStr) {
    if (roleStr == null) return UserRole.other;

    switch (roleStr.toLowerCase()) {
      case 'nurse':
        return UserRole.nurse;
      case 'doctor':
        return UserRole.doctor;
      case 'dataclerk':
        return UserRole.dataClerk;
      case 'programmanager':
        return UserRole.programManager;
      case 'pharmacist':
        return UserRole.pharmacist;
      case 'communityhealthworker':
        return UserRole.communityHealthWorker;
      case 'other':
      default:
        return UserRole.other;
    }
  }

  /// Get display text for the role
  String get roleDisplayText {
    if (role == UserRole.other &&
        customRoleText != null &&
        customRoleText!.isNotEmpty) {
      return customRoleText!;
    }
    return roleLabels[role] ?? 'Other';
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    UserRole? role,
    String? customRoleText,
    DateTime? selectionDate,
  }) {
    return UserProfile(
      role: role ?? this.role,
      customRoleText: customRoleText ?? this.customRoleText,
      selectionDate: selectionDate ?? this.selectionDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.role == role &&
        other.customRoleText == customRoleText;
  }

  @override
  int get hashCode => Object.hash(role, customRoleText);

  @override
  String toString() {
    return 'UserProfile(role: $roleDisplayText, date: $selectionDate)';
  }
}
