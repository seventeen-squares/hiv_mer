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
  final bool showGroup;

  const StandardIndicatorCard({
    super.key,
    required this.indicator,
    this.onTap,
    this.showGroup = true,
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
        onTap: onTap ??
            () {
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
                  const Spacer(),
                  _buildStatusBadge(indicator.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  if (showGroup) _buildMetaTag(Icons.category_outlined, groupName),
                  _buildMetaTag(Icons.pie_chart, indicator.factorType),
                  _buildMetaTag(Icons.calendar_today_outlined, indicator.frequency),
                ],
              ),

              if (indicator.definition.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  indicator.definition,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
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

  Widget _buildMetaTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        onTap: onTap ??
            () {
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

class CompactIndicatorCard extends StatefulWidget {
  final SAIndicator indicator;
  final VoidCallback onTap;

  const CompactIndicatorCard({
    super.key,
    required this.indicator,
    required this.onTap,
  });

  @override
  State<CompactIndicatorCard> createState() => _CompactIndicatorCardState();
}

class _CompactIndicatorCardState extends State<CompactIndicatorCard> {
  bool _isExpanded = false;

  String _getLevel() {
    final lower = widget.indicator.name.toLowerCase() + widget.indicator.definition.toLowerCase();
    if (lower.contains('outcome') || lower.contains('retention') || lower.contains('suppress') || lower.contains('cure')) {
      return 'Outcome';
    } else if (lower.contains('start') || lower.contains('initiat') || lower.contains('screen') || lower.contains('test')) {
      return 'Process';
    } else {
      return 'Output';
    }
  }

  bool _isAnnualised() {
    return widget.indicator.frequency.toLowerCase() == 'annually';
  }

  @override
  Widget build(BuildContext context) {
    final level = _getLevel();
    final isAnnualised = _isAnnualised();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.indicator.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  // Chip Row
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      _buildChipText(level, Colors.purple.shade700),
                      _buildDot(),
                      _buildChipText(widget.indicator.frequency, Colors.blue.shade700),
                      _buildDot(),
                      _buildChipText(widget.indicator.factorType.isEmpty ? 'Count' : widget.indicator.factorType, Colors.orange.shade800),
                      if (isAnnualised) ...[
                        _buildDot(),
                        _buildChipText('Annualised', Colors.teal.shade700),
                      ],
                       _buildDot(),
                      _buildStatusText(widget.indicator.status),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.indicator.definition.isEmpty 
                        ? 'No definition available.' 
                        : widget.indicator.definition,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // N/D Summary Toggle
          if (widget.indicator.numerator.isNotEmpty || (widget.indicator.denominator != null && widget.indicator.denominator!.isNotEmpty))
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.functions, 
                    size: 14, 
                    color: Colors.grey.shade500
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Numerator / Denominator details',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded Content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                 padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.indicator.numerator.isNotEmpty) ...[
                      _buildFormulaSection('Numerator', widget.indicator.numerator),
                      const SizedBox(height: 8),
                    ],
                    if (widget.indicator.denominator != null && widget.indicator.denominator != 'None') ...[
                      _buildFormulaSection('Denominator', widget.indicator.denominator!),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text('•', style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
    );
  }

  Widget _buildChipText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildStatusText(IndicatorStatus status) {
     Color color;
    String text;

    switch (status) {
      case IndicatorStatus.newIndicator:
        color = const Color(0xFF10B981);
        text = 'New';
        break;
      case IndicatorStatus.amended:
        color = const Color(0xFFF59E0B);
        text = 'Amended';
        break;
      case IndicatorStatus.retainedWithNew:
        color = const Color(0xFF3B82F6);
        text = 'Retained+';
        break;
      case IndicatorStatus.retainedWithoutNew:
        color = const Color(0xFF6B7280);
        text = 'Retained';
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
    }
    
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildFormulaSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
