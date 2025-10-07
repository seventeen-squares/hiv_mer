import 'package:flutter/material.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import '../home/home_screen.dart';
import 'widgets/role_option_card.dart';

/// Role selection screen shown on first launch or when updating role
///
/// Allows user to select their professional role from predefined options
/// or enter a custom role if "Other" is selected
class RoleSelectionScreen extends StatefulWidget {
  static const routeName = '/role-selection';

  final UserRole? currentRole;
  final String? currentCustomRole;

  const RoleSelectionScreen({
    super.key,
    this.currentRole,
    this.currentCustomRole,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final _userProfileService = UserProfileService.instance;
  final _customRoleController = TextEditingController();

  UserRole? _selectedRole;
  bool _showCustomRoleField = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.currentRole;
    _showCustomRoleField = widget.currentRole == UserRole.other;
    if (widget.currentCustomRole != null) {
      _customRoleController.text = widget.currentCustomRole!;
    }
  }

  @override
  void dispose() {
    _customRoleController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.currentRole != null;

  bool get _canConfirm {
    if (_selectedRole == null) return false;
    if (_selectedRole == UserRole.other &&
        _customRoleController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _handleConfirm() async {
    if (!_canConfirm || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = UserProfile(
        role: _selectedRole!,
        customRoleText: _selectedRole == UserRole.other
            ? _customRoleController.text.trim()
            : null,
        selectionDate: DateTime.now(),
      );

      if (_isEditing) {
        await _userProfileService.updateProfile(profile);
        if (mounted) {
          Navigator.of(context).pop(true); // Return to Settings
        }
      } else {
        await _userProfileService.saveProfile(profile);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to save role. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
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
      backgroundColor: Colors.grey.shade50,
      appBar: _isEditing
          ? AppBar(
              title: const Text('Update Role'),
              backgroundColor: saGovernmentGreen,
              foregroundColor: Colors.white,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEditing) ...[
                const SizedBox(height: 24),
                const Text(
                  'Welcome to NIDS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'To help us serve you better, please select your professional role.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                const SizedBox(height: 16),
              ],
              const Text(
                'Select Your Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              // Role options
              ...UserRole.values
                  .map((role) => RoleOptionCard(
                        role: role,
                        customLabel:
                            _selectedRole == role && role == UserRole.other
                                ? _customRoleController.text.trim().isEmpty
                                    ? null
                                    : _customRoleController.text.trim()
                                : null,
                        isSelected: _selectedRole == role,
                        onTap: () {
                          setState(() {
                            _selectedRole = role;
                            _showCustomRoleField = role == UserRole.other;
                          });
                        },
                      ))
                  .toList(),

              // Custom role text field
              if (_showCustomRoleField) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please specify your role:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customRoleController,
                        decoration: InputDecoration(
                          hintText: 'Enter your role',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: saGovernmentGreen, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(
                              () {}); // Rebuild to update confirm button state
                        },
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canConfirm && !_isSaving ? _handleConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: saGovernmentGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _isEditing ? 'Update Role' : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
