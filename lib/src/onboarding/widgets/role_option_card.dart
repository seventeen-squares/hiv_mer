import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Individual role selection card widget
/// 
/// Displays a role option with icon and label
/// Shows selected state with green highlight
class RoleOptionCard extends StatelessWidget {
  final UserRole role;
  final String? customLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleOptionCard({
    super.key,
    required this.role,
    this.customLabel,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.nurse:
        return Icons.medical_services;
      case UserRole.doctor:
        return Icons.local_hospital;
      case UserRole.dataClerk:
        return Icons.assessment;
      case UserRole.programManager:
        return Icons.manage_accounts;
      case UserRole.pharmacist:
        return Icons.medication;
      case UserRole.communityHealthWorker:
        return Icons.group;
      case UserRole.other:
        return Icons.person;
    }
  }

  String _getRoleLabel(UserRole role) {
    if (customLabel != null && role == UserRole.other) {
      return customLabel!;
    }
    
    switch (role) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected 
            ? saGovernmentGreen.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? saGovernmentGreen 
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? saGovernmentGreen 
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getRoleIcon(role),
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _getRoleLabel(role),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected 
                        ? saGovernmentGreen 
                        : const Color(0xFF1F2937),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: saGovernmentGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
