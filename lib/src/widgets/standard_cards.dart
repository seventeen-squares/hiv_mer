import 'package:flutter/material.dart';
import '../models/sa_indicator.dart';
import '../models/data_element.dart';
import '../services/sa_indicator_service.dart';
import '../indicators/indicator_detail_screen.dart';
import '../data_elements/data_element_detail_screen.dart';
import '../utils/constants.dart';

/// Standardized card widget for indicators
/// Uses the design from search_screen.dart as the standard across the app
class StandardIndicatorCard extends StatelessWidget {
  final SAIndicator indicator;
  final VoidCallback? onTap;

  const StandardIndicatorCard({
    super.key,
    required this.indicator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorService = SAIndicatorService.instance;
    final group = indicatorService.getGroupById(indicator.groupId);
    final groupName = group?.name ?? indicator.groupId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.of(context).pushNamed(
            IndicatorDetailScreen.routeName,
            arguments: indicator,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: saGovernmentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: saGovernmentGreen.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_outlined,
                            size: 14, color: saGovernmentGreen),
                        const SizedBox(width: 4),
                        Text(
                          'INDICATOR',
                          style: TextStyle(
                            color: saGovernmentGreen,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      indicator.indicatorId,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(indicator.status),
                ],
              ),
              const SizedBox(height: 8),
              // Programme Group
              Row(
                children: [
                  Icon(Icons.category_outlined,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      groupName,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (indicator.shortname.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  indicator.shortname,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
              if (indicator.definition.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  indicator.definition,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(IndicatorStatus status) {
    Color badgeColor;
    String statusText;

    switch (status) {
      case IndicatorStatus.newIndicator:
        badgeColor = Colors.green;
        statusText = 'NEW';
        break;
      case IndicatorStatus.amended:
        badgeColor = Colors.orange;
        statusText = 'AMENDED';
        break;
      case IndicatorStatus.retainedWithNew:
        badgeColor = Colors.blue;
        statusText = 'RETAINED (NEW)';
        break;
      case IndicatorStatus.retainedWithoutNew:
        badgeColor = Colors.grey;
        statusText = 'RETAINED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Standardized card widget for data elements
/// Uses the design from search_screen.dart as the standard across the app
class StandardDataElementCard extends StatelessWidget {
  final DataElement dataElement;
  final VoidCallback? onTap;

  const StandardDataElementCard({
    super.key,
    required this.dataElement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.of(context).pushNamed(
            DataElementDetailScreen.routeName,
            arguments: dataElement,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.description, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          'DATA ELEMENT',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildDataElementStatusBadge(dataElement.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                dataElement.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (dataElement.shortname.isNotEmpty &&
                  dataElement.shortname != dataElement.name) ...[
                const SizedBox(height: 4),
                Text(
                  dataElement.shortname,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
              if (dataElement.definition.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  dataElement.definition,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 11,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              // Data Element metadata row
              Row(
                children: [
                  Icon(Icons.category_outlined,
                      size: 12, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    dataElement.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.data_usage, size: 12, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    dataElement.dataType,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataElementStatusBadge(DataElementStatus status) {
    Color badgeColor;
    String statusText;

    switch (status) {
      case DataElementStatus.newElement:
        badgeColor = Colors.green;
        statusText = 'NEW';
        break;
      case DataElementStatus.amended:
        badgeColor = Colors.orange;
        statusText = 'AMENDED';
        break;
      case DataElementStatus.retained:
        badgeColor = Colors.grey;
        statusText = 'RETAINED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}