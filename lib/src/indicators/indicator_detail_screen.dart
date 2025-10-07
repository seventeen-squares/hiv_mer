import 'package:flutter/material.dart';
import '../models/sa_indicator.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class IndicatorDetailScreen extends StatelessWidget {
  static const routeName = '/indicator-detail';

  const IndicatorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final indicator = ModalRoute.of(context)!.settings.arguments as SAIndicator;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with SA branding
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: saGovernmentGreen,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          indicator.indicatorId,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          indicator.shortname,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Add to favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to favorites'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicator Name
                    Text(
                      indicator.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getPrimaryTextColor(context),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // IDs Card
                    _buildInfoCard(
                      context,
                      children: [
                        _buildInfoRow('Reno/ID', indicator.renoId),
                        const SizedBox(height: 8),
                        _buildInfoRow('Group ID', indicator.groupId),
                        const SizedBox(height: 8),
                        _buildInfoRow('Indicator ID', indicator.indicatorId),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            'Sort Order', indicator.sortOrder.toString()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Definition Section
                    _buildSection(
                      context,
                      title: 'DEFINITION',
                      content: indicator.definition,
                      icon: Icons.info_outline,
                    ),

                    const SizedBox(height: 16),

                    // Numerator Card
                    _buildDetailCard(
                      context,
                      title: 'NUMERATOR',
                      content: indicator.numerator,
                      formula: indicator.numeratorFormula,
                      color: const Color(0xFF10B981),
                      icon: Icons.add_circle_outline,
                    ),

                    const SizedBox(height: 16),

                    // Denominator Card (if present)
                    if (indicator.denominator != null)
                      _buildDetailCard(
                        context,
                        title: 'DENOMINATOR',
                        content: indicator.denominator!,
                        formula: indicator.denominatorFormula,
                        color: const Color(0xFF3B82F6),
                        icon: Icons.calculate_outlined,
                      )
                    else
                      _buildSection(
                        context,
                        title: 'DENOMINATOR',
                        content: 'Not applicable',
                        icon: Icons.remove_circle_outline,
                      ),

                    const SizedBox(height: 16),

                    // Use and Context Section
                    _buildSection(
                      context,
                      title: 'USE AND CONTEXT',
                      content: indicator.useContext,
                      icon: Icons.lightbulb_outline,
                    ),

                    const SizedBox(height: 16),

                    // Metadata Card
                    _buildInfoCard(
                      context,
                      children: [
                        _buildInfoRow('Factor/Type', indicator.factorType),
                        const SizedBox(height: 8),
                        _buildInfoRow('Frequency', indicator.frequency),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                            'Status', _getStatusText(indicator.status)),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: saGovernmentGreen,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.getPrimaryTextColor(context),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String content,
    String? formula,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.getPrimaryTextColor(context),
              height: 1.5,
            ),
          ),
          if (formula != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.functions, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formula,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(IndicatorStatus status) {
    switch (status) {
      case IndicatorStatus.newIndicator:
        return 'NEW';
      case IndicatorStatus.amended:
        return 'AMENDED';
      case IndicatorStatus.retainedWithNew:
        return 'RETAINED WITH NEW';
      case IndicatorStatus.retainedWithoutNew:
        return 'RETAINED WITHOUT NEW';
    }
  }
}
