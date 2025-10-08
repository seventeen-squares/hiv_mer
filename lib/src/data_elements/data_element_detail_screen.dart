import 'package:flutter/material.dart';
import '../models/data_element.dart';
import '../utils/constants.dart';

class DataElementDetailScreen extends StatelessWidget {
  static const routeName = '/data-element-detail';

  const DataElementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final element = ModalRoute.of(context)!.settings.arguments as DataElement;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
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
                    child: Text(
                      element.shortname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                    // Element Name
                    Text(
                      element.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // IDs Card
                    _buildInfoCard(
                      context,
                      children: [
                        _buildInfoRow('Element ID', element.id),
                        const SizedBox(height: 8),
                        _buildInfoRow('Category', element.category),
                        const SizedBox(height: 8),
                        _buildInfoRow('Data Type', element.dataType),
                        const SizedBox(height: 8),
                        _buildInfoRow('Aggregation', element.aggregationType),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Definition Card
                    if (element.definition.isNotEmpty)
                      _buildInfoCard(
                        context,
                        title: 'Definition',
                        children: [
                          Text(
                            element.definition,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ],
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

  Widget _buildInfoCard(
    BuildContext context, {
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}
