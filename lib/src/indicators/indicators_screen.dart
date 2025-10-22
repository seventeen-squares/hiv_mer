import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_detail_screen.dart';

class IndicatorsScreen extends StatefulWidget {
  static const routeName = '/indicators';

  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  final _indicatorService = SAIndicatorService.instance;
  List<IndicatorGroup> _groups = [];
  Map<String, List<SAIndicator>> _indicatorsByGroup = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Ensure indicators are loaded
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }

      // Get groups and indicators
      final groups = _indicatorService.getAllGroups();
      final indicatorsByGroup = <String, List<SAIndicator>>{};

      for (final group in groups) {
        indicatorsByGroup[group.id] =
            _indicatorService.getIndicatorsByGroup(group.id);
      }

      setState(() {
        _groups = groups;
        _indicatorsByGroup = indicatorsByGroup;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Expanded(
                    child: Text(
                      'SA INDICATOR GROUPS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading indicators',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _groups.length,
                          itemBuilder: (context, index) {
                            final group = _groups[index];
                            final indicators =
                                _indicatorsByGroup[group.id] ?? [];
                            return _buildGroupSection(group, indicators);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(
      IndicatorGroup group, List<SAIndicator> indicators) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Group Header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: saGovernmentGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (group.subGroups.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          group.subGroups.join(' • '),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${indicators.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Indicators List
          if (indicators.isNotEmpty)
            Column(
              children: indicators.asMap().entries.map((entry) {
                final index = entry.key;
                final indicator = entry.value;
                return Column(
                  children: [
                    if (index > 0)
                      Divider(height: 1, color: Colors.grey.shade200),
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: _buildStatusBadge(indicator.status),
                      title: Text(
                        indicator.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            indicator.shortname,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                indicator.frequency,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.label,
                                  size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                indicator.indicatorId,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          IndicatorDetailScreen.routeName,
                          arguments: indicator,
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            )
          else
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade400),
                  const SizedBox(width: 12),
                  Text(
                    'No indicators in this group',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(IndicatorStatus status) {
    Color color;
    String label;

    switch (status) {
      case IndicatorStatus.newIndicator:
        color = const Color(0xFF10B981);
        label = 'NEW';
        break;
      case IndicatorStatus.amended:
        color = const Color(0xFF3B82F6);
        label = 'AMD';
        break;
      case IndicatorStatus.retainedWithNew:
        color = const Color(0xFFF59E0B);
        label = 'RET+';
        break;
      case IndicatorStatus.retainedWithoutNew:
        color = const Color(0xFF6B7280);
        label = 'RET';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
