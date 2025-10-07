import 'package:flutter/material.dart';

import 'settings_controller.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../onboarding/role_selection_screen.dart';
import '../utils/constants.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _userProfileService = UserProfileService.instance;
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userProfileService.getProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getRoleDisplayText() {
    if (_userProfile == null) {
      return 'Not set';
    }

    if (_userProfile!.role == UserRole.other &&
        _userProfile!.customRoleText != null) {
      return _userProfile!.customRoleText!;
    }

    switch (_userProfile!.role) {
      case UserRole.nurse:
        return 'Nurse';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.dataClerk:
        return 'Data Clerk';
      case UserRole.programManager:
        return 'Program Manager';
      case UserRole.pharmacist:
        return 'Pharmacist';
      case UserRole.communityHealthWorker:
        return 'Community Health Worker';
      case UserRole.other:
        return 'Other';
    }
  }

  Future<void> _navigateToRoleSelection() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoleSelectionScreen(
          currentRole: _userProfile?.role,
          currentCustomRole: _userProfile?.customRoleText,
        ),
      ),
    );

    // If role was updated (result == true), show confirmation and reload profile
    if (result == true && mounted) {
      await _loadUserProfile();
      _showRoleUpdateConfirmation();
    }
  }

  void _showRoleUpdateConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Role Updated'),
        content:
            Text('Your role has been updated to ${_getRoleDisplayText()}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // User Role Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'User Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: saGovernmentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: saGovernmentGreen,
                      size: 22,
                    ),
                  ),
                  title: const Text('User Role'),
                  subtitle: Text(_getRoleDisplayText()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _navigateToRoleSelection,
                ),
                const Divider(height: 1),

                // App Settings Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: saGovernmentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.palette,
                      color: saGovernmentGreen,
                      size: 22,
                    ),
                  ),
                  title: const Text('Theme'),
                  subtitle:
                      Text(_getThemeModeText(widget.controller.themeMode)),
                  trailing: DropdownButton<ThemeMode>(
                    value: widget.controller.themeMode,
                    onChanged: widget.controller.updateThemeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
