import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_list_by_group_screen.dart';

/// Screen showing all indicator groups in a card grid layout
/// Matches the NIDS design with expandable sections and subgroup cards
class IndicatorGroupsScreen extends StatefulWidget {
  static const routeName = '/indicator-groups';

  const IndicatorGroupsScreen({super.key});

  @override
  State<IndicatorGroupsScreen> createState() => _IndicatorGroupsScreenState();
}

class _IndicatorGroupsScreenState extends State<IndicatorGroupsScreen> {
  final _indicatorService = SAIndicatorService.instance;
  List<IndicatorGroup> _groups = [];
  bool _isLoading = true;
  String? _error;
  String? _expandedGroupId;

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

      // Get groups
      final groups = _indicatorService.getAllGroups();

      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getGroupIcon(String groupId) {
    if (groupId.contains('art') || groupId.contains('antiretroviral')) {
      return Icons.medication;
    } else if (groupId.contains('tb') || groupId.contains('tuberculosis')) {
      return Icons.masks;
    } else if (groupId.contains('hiv')) {
      return Icons.health_and_safety;
    } else if (groupId.contains('child') || groupId.contains('nutrition')) {
      return Icons.child_care;
    } else if (groupId.contains('immunis') || groupId.contains('epi')) {
      return Icons.vaccines;
    } else if (groupId.contains('communicable') ||
        groupId.contains('disease')) {
      return Icons.people;
    } else if (groupId.contains('chronic') || groupId.contains('medicine')) {
      return Icons.local_pharmacy;
    } else if (groupId.contains('eye')) {
      return Icons.visibility;
    } else if (groupId.contains('facility')) {
      return Icons.local_hospital;
    } else if (groupId.contains('campaign')) {
      return Icons.campaign;
    } else if (groupId.contains('site')) {
      return Icons.location_on;
    }
    return Icons.folder;
  }

  Color _getGroupColor(String groupId) {
    if (groupId.contains('art') || groupId.contains('antiretroviral')) {
      return const Color(0xFFF59E0B);
    } else if (groupId.contains('tb') || groupId.contains('tuberculosis')) {
      return const Color(0xFF10B981);
    } else if (groupId.contains('hiv')) {
      return const Color(0xFF8B5CF6);
    } else if (groupId.contains('child') || groupId.contains('nutrition')) {
      return const Color(0xFF06B6D4);
    } else if (groupId.contains('immunis') || groupId.contains('epi')) {
      return const Color(0xFFEC4899);
    } else if (groupId.contains('communicable') ||
        groupId.contains('disease')) {
      return const Color(0xFF10B981);
    } else if (groupId.contains('chronic') || groupId.contains('medicine')) {
      return const Color(0xFF3B82F6);
    } else if (groupId.contains('eye')) {
      return const Color(0xFF8B5CF6);
    }
    return saGovernmentGreen;
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
                      'Indicator Groups',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Add help/info dialog
                    },
                    icon: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.white,
                        size: 20,
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
                                  'Error loading indicator groups',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
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
                            return _buildGroupCard(group);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupCard(IndicatorGroup group) {
    final isExpanded = _expandedGroupId == group.id;
    final hasSubGroups = group.subGroups.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? saGovernmentGreen : Colors.grey.shade200,
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (hasSubGroups) {
                setState(() {
                  _expandedGroupId = isExpanded ? null : group.id;
                });
              } else {
                // Navigate directly to indicator list if no subgroups
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        IndicatorListByGroupScreen(group: group),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getGroupColor(group.id).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getGroupIcon(group.id),
                      color: _getGroupColor(group.id),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  if (hasSubGroups)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: saGovernmentGreen,
                      size: 24,
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),

          // Subgroups Grid
          if (isExpanded && hasSubGroups) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: group.subGroups.map((subGroup) {
                  return _buildSubGroupCard(group, subGroup);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubGroupCard(IndicatorGroup group, String subGroup) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IndicatorListByGroupScreen(
              group: group,
              subGroup: subGroup,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getGroupColor(group.id).withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getGroupColor(group.id).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _getGroupIcon(group.id),
              color: _getGroupColor(group.id),
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              subGroup,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
