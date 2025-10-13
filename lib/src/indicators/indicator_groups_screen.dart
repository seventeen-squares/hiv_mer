import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_detail_screen.dart';

/// Screen showing all indicator groups in an accordion layout
/// with indicators displayed in a grid under each group
class IndicatorGroupsScreen extends StatefulWidget {
  static const routeName = '/indicator-groups';

  const IndicatorGroupsScreen({super.key});

  @override
  State<IndicatorGroupsScreen> createState() => _IndicatorGroupsScreenState();
}

class _IndicatorGroupsScreenState extends State<IndicatorGroupsScreen> {
  final _indicatorService = SAIndicatorService.instance;
  List<IndicatorGroup> _groups = [];
  Map<String, List<SAIndicator>> _indicatorsByGroup = {};
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
    final groupLower = groupId.toLowerCase();

    // Adolescent Health - Blue
    if (groupLower.contains('adolescent')) {
      return const Color(0xFF5DADE2);
    }
    // ART Categories - Browns/Pinks
    else if (groupLower.contains('art baseline')) {
      return const Color(0xFFA1887F);
    } else if (groupLower.contains('art monthly')) {
      return const Color(0xFFE91E63);
    } else if (groupLower.contains('art outcome')) {
      return const Color(0xFF827717);
    } else if (groupLower.contains('art') ||
        groupLower.contains('antiretroviral')) {
      return const Color(0xFFA1887F);
    }
    // Central Chronic Medicines - Dark Green
    else if (groupLower.contains('chronic medicine') ||
        groupLower.contains('central chronic')) {
      return const Color(0xFF00897B);
    }
    // Child and Nutrition - Light Blue
    else if (groupLower.contains('child') || groupLower.contains('nutrition')) {
      return const Color(0xFF81D4FA);
    }
    // Chronic - Yellow
    else if (groupLower.contains('chronic')) {
      return const Color(0xFFFFEB3B);
    }
    // Communicable Diseases - Orange
    else if (groupLower.contains('communicable')) {
      return const Color(0xFFFF7043);
    }
    // Emergency Medical Services - Dark Gray
    else if (groupLower.contains('emergency') || groupLower.contains('ems')) {
      return const Color(0xFF424242);
    }
    // Environmental Health - Yellow/Green
    else if (groupLower.contains('environmental')) {
      return const Color(0xFFCDDC39);
    }
    // Expanded Programme on Immunisation - Red
    else if (groupLower.contains('epi') ||
        groupLower.contains('immunis') ||
        groupLower.contains('immunization')) {
      return const Color(0xFFF44336);
    }
    // Eye Care - Light Pink
    else if (groupLower.contains('eye')) {
      return const Color(0xFFF8BBD0);
    }
    // HIV - Purple
    else if (groupLower.contains('hiv')) {
      return const Color(0xFF7986CB);
    }
    // Malaria - Green
    else if (groupLower.contains('malaria')) {
      return const Color(0xFF66BB6A);
    }
    // Management Inpatients - Magenta/Pink
    else if (groupLower.contains('inpatient') ||
        groupLower.contains('management inpatient')) {
      return const Color(0xFFE91E63);
    }
    // Management PHC - Cyan
    else if (groupLower.contains('phc') ||
        groupLower.contains('primary health')) {
      return const Color(0xFF00BCD4);
    }
    // Maternal and Neonatal - Orange
    else if (groupLower.contains('maternal') ||
        groupLower.contains('neonatal')) {
      return const Color(0xFFFF9800);
    }
    // Mental Health - Light Green
    else if (groupLower.contains('mental')) {
      return const Color(0xFFAED581);
    }
    // Oral Health - Light Olive
    else if (groupLower.contains('oral') || groupLower.contains('dental')) {
      return const Color(0xFFD4E157);
    }
    // PHC Ward Based Outreach Teams - Gray
    else if (groupLower.contains('wbot') ||
        groupLower.contains('ward based') ||
        groupLower.contains('outreach')) {
      return const Color(0xFF9E9E9E);
    }
    // Quality - Purple
    else if (groupLower.contains('quality')) {
      return const Color(0xFF7E57C2);
    }
    // Rehabilitation - Light Purple
    else if (groupLower.contains('rehab')) {
      return const Color(0xFFB39DDB);
    }
    // School Health - Dark Red
    else if (groupLower.contains('school')) {
      return const Color(0xFFC62828);
    }
    // Sexually Transmitted Infections - Brown/Tan
    else if (groupLower.contains('sti') ||
        groupLower.contains('sexually transmitted')) {
      return const Color(0xFFBCAAA4);
    }
    // TB Monthly - Teal
    else if (groupLower.contains('tb') && groupLower.contains('monthly')) {
      return const Color(0xFF00BCD4);
    }
    // TB Quarterly - Brown
    else if (groupLower.contains('tb') && groupLower.contains('quarterly')) {
      return const Color(0xFF8D6E63);
    }
    // TB General - Teal
    else if (groupLower.contains('tb') || groupLower.contains('tuberculosis')) {
      return const Color(0xFF00BCD4);
    }
    // Women's Health - Pink
    else if (groupLower.contains('women')) {
      return const Color(0xFFE57373);
    }
    // Default
    return saGovernmentGreen;
  }

  @override
  Widget build(BuildContext context) {
    // Check if we can pop (i.e., if we're in a navigation stack)
    final canPop = Navigator.of(context).canPop();

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
                  if (canPop)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  if (canPop) const SizedBox(width: 8),
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
    final indicators = _indicatorsByGroup[group.id] ?? [];

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
          // Group Header (Accordion trigger)
          InkWell(
            onTap: () {
              setState(() {
                _expandedGroupId = isExpanded ? null : group.id;
              });
            },
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isExpanded ? Radius.zero : const Radius.circular(12),
              bottomRight: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: saGovernmentGreen.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft:
                      isExpanded ? Radius.zero : const Radius.circular(12),
                  bottomRight:
                      isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getGroupColor(group.id).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getGroupIcon(group.id),
                      color: _getGroupColor(group.id),
                      size: 22,
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
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: saGovernmentGreen,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Indicators Grid (shown when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: indicators.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade400),
                          const SizedBox(width: 12),
                          Text(
                            'No indicators in this group',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: indicators.map((indicator) {
                        return _buildIndicatorCard(indicator);
                      }).toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(SAIndicator indicator) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          IndicatorDetailScreen.routeName,
          arguments: indicator,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
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
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getGroupColor(indicator.groupId).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getGroupIcon(indicator.groupId),
                    color: _getGroupColor(indicator.groupId),
                    size: 18,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                indicator.shortname,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
