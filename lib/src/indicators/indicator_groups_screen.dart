import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_list_by_group_screen.dart';

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
    final groupLower = groupId.toLowerCase();

    // Adolescent Health
    if (groupLower.contains('adolescent')) {
      return Icons.people_alt;
    }
    // ART Categories
    else if (groupLower.contains('art') ||
        groupLower.contains('antiretroviral')) {
      return Icons.medical_services;
    }
    // Central Chronic Medicines
    else if (groupLower.contains('chronic medicine') ||
        groupLower.contains('central chronic')) {
      return Icons.medication_liquid;
    }
    // Child and Nutrition
    else if (groupLower.contains('child') || groupLower.contains('nutrition')) {
      return Icons.child_care;
    }
    // Chronic
    else if (groupLower.contains('chronic')) {
      return Icons.local_pharmacy;
    }
    // Communicable Diseases
    else if (groupLower.contains('communicable')) {
      return Icons.coronavirus;
    }
    // Emergency Medical Services
    else if (groupLower.contains('emergency') || groupLower.contains('ems')) {
      return Icons.emergency;
    }
    // Environmental Health
    else if (groupLower.contains('environmental')) {
      return Icons.eco;
    }
    // Immunisation
    else if (groupLower.contains('epi') ||
        groupLower.contains('immunis') ||
        groupLower.contains('immunization')) {
      return Icons.vaccines;
    }
    // Eye Care
    else if (groupLower.contains('eye')) {
      return Icons.remove_red_eye;
    }
    // HIV
    else if (groupLower.contains('hiv')) {
      return Icons.health_and_safety;
    }
    // Malaria
    else if (groupLower.contains('malaria')) {
      return Icons.bug_report;
    }
    // Inpatient Management
    else if (groupLower.contains('inpatient')) {
      return Icons.local_hospital;
    }
    // PHC
    else if (groupLower.contains('phc') ||
        groupLower.contains('primary health')) {
      return Icons.medical_information;
    }
    // Maternal and Neonatal
    else if (groupLower.contains('maternal') ||
        groupLower.contains('neonatal')) {
      return Icons.pregnant_woman;
    }
    // Mental Health
    else if (groupLower.contains('mental')) {
      return Icons.psychology;
    }
    // Oral Health
    else if (groupLower.contains('oral') || groupLower.contains('dental')) {
      return Icons.mood;
    }
    // Ward Based Outreach Teams
    else if (groupLower.contains('wbot') ||
        groupLower.contains('ward based') ||
        groupLower.contains('outreach')) {
      return Icons.group;
    }
    // Quality
    else if (groupLower.contains('quality')) {
      return Icons.stars;
    }
    // Rehabilitation
    else if (groupLower.contains('rehab')) {
      return Icons.accessible;
    }
    // School Health
    else if (groupLower.contains('school')) {
      return Icons.school;
    }
    // STI
    else if (groupLower.contains('sti') ||
        groupLower.contains('sexually transmitted')) {
      return Icons.warning;
    }
    // TB
    else if (groupLower.contains('tb') || groupLower.contains('tuberculosis')) {
      return Icons.masks;
    }
    // Women's Health
    else if (groupLower.contains('women')) {
      return Icons.female;
    }
    // Default
    return Icons.folder_outlined;
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
      body: Column(
        children: [
          // Custom App Bar with SA branding - compact version
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: const BoxDecoration(
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
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (canPop) const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Indicator Groups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: _groups.length,
                        itemBuilder: (context, index) {
                          final group = _groups[index];
                          return _buildGroupListItem(group);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupListItem(IndicatorGroup group) {
    final indicators = _indicatorsByGroup[group.id] ?? [];
    final color = _getGroupColor(group.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to indicator list by group screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndicatorListByGroupScreen(group: group),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Colored bar on the left
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getGroupIcon(group.id),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Group name and count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${indicators.length} indicator${indicators.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
