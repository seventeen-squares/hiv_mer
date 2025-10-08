import 'package:flutter/material.dart';

/// Reusable summary card widget for displaying statistics
/// Shows indicator and data element counts
class SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
