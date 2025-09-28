import 'package:flutter/material.dart';
import '../models/mer_models.dart';
import '../utils/app_colors.dart';

class IndicatorDetailScreen extends StatelessWidget {
  static const routeName = '/indicator-detail';

  const IndicatorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final indicator =
        ModalRoute.of(context)!.settings.arguments as MERIndicator;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getProgramColor(indicator.programArea),
                    _getProgramColor(indicator.programArea).withOpacity(0.8),
                  ],
                ),
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
                          indicator.code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          indicator.programArea,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getPrimaryTextColor(context),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Definition Section
                    _buildSection(
                      context,
                      title: 'DEFINITION',
                      content: indicator.definition,
                      icon: Icons.info_outline,
                    ),

                    const SizedBox(height: 20),

                    // Numerator & Denominator
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            title: 'NUMERATOR',
                            content: indicator.numerator,
                            color: Colors.green.shade600,
                            icon: Icons.add,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            title: 'DENOMINATOR',
                            content: indicator.denominator,
                            color: Colors.blue.shade600,
                            icon: Icons.all_inclusive,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Disaggregations
                    _buildSection(
                      context,
                      title: 'DISAGGREGATIONS',
                      content: null,
                      icon: Icons.category,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: indicator.disaggregations
                            .map(
                              (disagg) => Chip(
                                label: Text(
                                  disagg,
                                  style: TextStyle(
                                    color: AppColors.getChipTextColor(context),
                                  ),
                                ),
                                backgroundColor:
                                    AppColors.getChipBackgroundColor(context),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Reporting Details
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildDetailRow(context, 'Reporting Frequency',
                                indicator.frequency, Icons.schedule),
                            const Divider(),
                            _buildDetailRow(context, 'Program Area',
                                indicator.programArea, Icons.medical_services),
                            const Divider(),
                            _buildDetailRow(context, 'Source', indicator.source,
                                Icons.source),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Notes Section
                    if (indicator.notes.isNotEmpty)
                      _buildSection(
                        context,
                        title: 'NOTES & CLARIFICATIONS',
                        content: indicator.notes,
                        icon: Icons.note_outlined,
                      ),
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
    String? content,
    required IconData icon,
    Widget? child,
  }) {
    return Card(
      elevation: 2,
      color: AppColors.getCardColor(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.getTertiaryTextColor(context)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.getPrimaryTextColor(context),
                  height: 1.5,
                ),
              ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getPrimaryTextColor(context),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.getTertiaryTextColor(context), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgramColor(String program) {
    switch (program.toLowerCase()) {
      case 'hts':
        return Colors.blue.shade600;
      case 'tx':
        return Colors.green.shade600;
      case 'pmtct':
        return Colors.pink.shade600;
      case 'tb':
        return Colors.orange.shade600;
      case 'kp':
        return Colors.purple.shade600;
      case 'ovc':
        return Colors.teal.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
