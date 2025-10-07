import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// NIDS header widget displaying South African branding
/// Shows coat of arms, department branding, app title, and version
class NIDSHeader extends StatelessWidget {
  const NIDSHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Coat of arms and health text
          Row(
            children: [
              // Placeholder for SA coat of arms
              // TODO: Replace with actual image when available
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: saGovernmentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: saGovernmentGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'health',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Department: Health',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    'REPUBLIC OF SOUTH AFRICA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // App title
          const Text(
            appName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 8),

          // Version number
          Text(
            appVersion,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: saGovernmentGreen,
            ),
          ),
        ],
      ),
    );
  }
}
