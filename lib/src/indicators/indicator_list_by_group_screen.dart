import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_detail_screen.dart';

/// Screen showing indicators for a specific group
class IndicatorListByGroupScreen extends StatefulWidget {
  final IndicatorGroup group;
  final String? subGroup;

  const IndicatorListByGroupScreen({
    super.key,
    required this.group,
    this.subGroup,
  });

  @override
  State<IndicatorListByGroupScreen> createState() =>
      _IndicatorListByGroupScreenState();
}

class _IndicatorListByGroupScreenState
    extends State<IndicatorListByGroupScreen> {
  final _indicatorService = SAIndicatorService.instance;
  final _searchController = TextEditingController();
  List<SAIndicator> _indicators = [];
  List<SAIndicator> _filteredIndicators = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIndicators();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIndicators = _indicators;
      } else {
        _filteredIndicators = _indicators.where((indicator) {
          return indicator.name.toLowerCase().contains(query) ||
              indicator.shortname.toLowerCase().contains(query) ||
              indicator.indicatorId.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Color _getGroupColor() {
    final groupLower = widget.group.id.toLowerCase();

    // Match colors from indicator_groups_screen.dart
    if (groupLower.contains('adolescent')) return const Color(0xFF5DADE2);
    if (groupLower.contains('art baseline')) return const Color(0xFFA1887F);
    if (groupLower.contains('art monthly')) return const Color(0xFFE91E63);
    if (groupLower.contains('art outcome')) return const Color(0xFF827717);
    if (groupLower.contains('art') || groupLower.contains('antiretroviral'))
      return const Color(0xFFA1887F);
    if (groupLower.contains('chronic medicine') ||
        groupLower.contains('central chronic')) return const Color(0xFF00897B);
    if (groupLower.contains('child') || groupLower.contains('nutrition'))
      return const Color(0xFF81D4FA);
    if (groupLower.contains('chronic')) return const Color(0xFFFFEB3B);
    if (groupLower.contains('communicable')) return const Color(0xFFFF7043);
    if (groupLower.contains('emergency') || groupLower.contains('ems'))
      return const Color(0xFF424242);
    if (groupLower.contains('environmental')) return const Color(0xFFCDDC39);
    if (groupLower.contains('epi') ||
        groupLower.contains('immunis') ||
        groupLower.contains('immunization')) return const Color(0xFFF44336);
    if (groupLower.contains('eye')) return const Color(0xFFF8BBD0);
    if (groupLower.contains('hiv')) return const Color(0xFF7986CB);
    if (groupLower.contains('malaria')) return const Color(0xFF66BB6A);
    if (groupLower.contains('inpatient') ||
        groupLower.contains('management inpatient'))
      return const Color(0xFFE91E63);
    if (groupLower.contains('phc') || groupLower.contains('primary health'))
      return const Color(0xFF00BCD4);
    if (groupLower.contains('maternal') || groupLower.contains('neonatal'))
      return const Color(0xFFFF9800);
    if (groupLower.contains('mental')) return const Color(0xFFAED581);
    if (groupLower.contains('oral') || groupLower.contains('dental'))
      return const Color(0xFFD4E157);
    if (groupLower.contains('wbot') ||
        groupLower.contains('ward based') ||
        groupLower.contains('outreach')) return const Color(0xFF9E9E9E);
    if (groupLower.contains('quality')) return const Color(0xFF7E57C2);
    if (groupLower.contains('rehab')) return const Color(0xFFB39DDB);
    if (groupLower.contains('school')) return const Color(0xFFC62828);
    if (groupLower.contains('sti') ||
        groupLower.contains('sexually transmitted'))
      return const Color(0xFFBCAAA4);
    if (groupLower.contains('tb') && groupLower.contains('monthly'))
      return const Color(0xFF00BCD4);
    if (groupLower.contains('tb') && groupLower.contains('quarterly'))
      return const Color(0xFF8D6E63);
    if (groupLower.contains('tb') || groupLower.contains('tuberculosis'))
      return const Color(0xFF00BCD4);
    if (groupLower.contains('women')) return const Color(0xFFE57373);

    return saGovernmentGreen;
  }

  IconData _getGroupIcon() {
    final groupLower = widget.group.id.toLowerCase();

    if (groupLower.contains('adolescent')) return Icons.people_alt;
    if (groupLower.contains('art') || groupLower.contains('antiretroviral'))
      return Icons.medical_services;
    if (groupLower.contains('chronic medicine') ||
        groupLower.contains('central chronic')) return Icons.medication_liquid;
    if (groupLower.contains('child') || groupLower.contains('nutrition'))
      return Icons.child_care;
    if (groupLower.contains('chronic')) return Icons.local_pharmacy;
    if (groupLower.contains('communicable')) return Icons.coronavirus;
    if (groupLower.contains('emergency') || groupLower.contains('ems'))
      return Icons.emergency;
    if (groupLower.contains('environmental')) return Icons.eco;
    if (groupLower.contains('epi') ||
        groupLower.contains('immunis') ||
        groupLower.contains('immunization')) return Icons.vaccines;
    if (groupLower.contains('eye')) return Icons.remove_red_eye;
    if (groupLower.contains('hiv')) return Icons.health_and_safety;
    if (groupLower.contains('malaria')) return Icons.bug_report;
    if (groupLower.contains('inpatient')) return Icons.local_hospital;
    if (groupLower.contains('phc') || groupLower.contains('primary health'))
      return Icons.medical_information;
    if (groupLower.contains('maternal') || groupLower.contains('neonatal'))
      return Icons.pregnant_woman;
    if (groupLower.contains('mental')) return Icons.psychology;
    if (groupLower.contains('oral') || groupLower.contains('dental'))
      return Icons.mood;
    if (groupLower.contains('wbot') ||
        groupLower.contains('ward based') ||
        groupLower.contains('outreach')) return Icons.group;
    if (groupLower.contains('quality')) return Icons.stars;
    if (groupLower.contains('rehab')) return Icons.accessible;
    if (groupLower.contains('school')) return Icons.school;
    if (groupLower.contains('sti') ||
        groupLower.contains('sexually transmitted')) return Icons.warning;
    if (groupLower.contains('tb') || groupLower.contains('tuberculosis'))
      return Icons.masks;
    if (groupLower.contains('women')) return Icons.female;

    return Icons.folder_outlined;
  }

  String _getGroupDescription() {
    // Group descriptions based on common NIDS indicator groups
    final descriptions = {
      'art_baseline':
          'Baseline indicators for clients starting antiretroviral therapy (ART), including demographics, CD4 counts, TB screening, and cotrimoxazole prevention therapy status.',
      'art_monthly':
          'Monthly reporting indicators for ART program monitoring, tracking new starts and clients remaining on treatment.',
      'art_outcome':
          'Treatment outcome indicators measuring retention in care, viral load suppression, regimen switches, and treatment outcomes for ART clients.',
      'child_and_nutrition':
          'Indicators for child health and nutrition programs including vitamin A supplementation, deworming, exclusive breastfeeding, malnutrition, and childhood illnesses.',
      'communicable_diseases':
          'Indicators for monitoring and reporting on communicable diseases and disease surveillance activities.',
      'dr-tb_quarterly':
          'Quarterly reporting indicators for drug-resistant tuberculosis (DR-TB) treatment and outcomes.',
      'ds-tb_quarterly':
          'Quarterly reporting indicators for drug-sensitive tuberculosis (DS-TB) treatment and outcomes.',
      'ems':
          'Emergency Medical Services indicators monitoring response times, transport, and emergency care delivery.',
      'environmental_&_port_health':
          'Environmental health and port health services indicators including water quality, food safety, waste management, and disease vector control.',
      'epi':
          'Expanded Programme on Immunisation (EPI) indicators tracking vaccination coverage and immunisation services.',
      'eye_care':
          'Eye care service indicators monitoring screening, treatment, and referrals for vision and eye health.',
      'hiv':
          'HIV prevention, testing, and care indicators including HIV testing services, prevention interventions, and pre-exposure prophylaxis (PrEP).',
      'inpatient_management':
          'Hospital inpatient management indicators tracking admissions, length of stay, and inpatient care quality.',
      'management_phc':
          'Primary Health Care (PHC) management indicators for facility operations and service delivery.',
      'maternal_and_neonatal':
          'Maternal and neonatal health indicators covering antenatal care, delivery services, postnatal care, and newborn health.',
      'mental_health':
          'Mental health service indicators monitoring access to mental health care and treatment outcomes.',
      'non-communicable_disease':
          'Non-communicable disease (NCD) indicators for diabetes, hypertension, and chronic disease management.',
      'oral_health':
          'Oral health service indicators tracking dental care access and oral health outcomes.',
      'quality':
          'Quality improvement and patient safety indicators measuring healthcare quality standards.',
      'rehabilitation':
          'Rehabilitation services indicators for physical therapy, occupational therapy, and disability services.',
      'school_health':
          'School health program indicators monitoring health screening and interventions in educational settings.',
      'sti':
          'Sexually transmitted infection (STI) indicators for testing, treatment, and syndromic management.',
      'tb_monthly':
          'Monthly tuberculosis program indicators tracking TB screening, testing, and treatment initiation.',
      'viral_hepatitis':
          'Viral hepatitis indicators for hepatitis B and C testing, prevention, and treatment.',
      'wbphcot':
          'Ward-Based Primary Healthcare Outreach Team (WBPHCOT) indicators monitoring community-based healthcare services.',
      'women\'s_health':
          'Women\'s health indicators including family planning, cervical cancer screening, and reproductive health services.',
    };

    return descriptions[widget.group.id] ??
        'A collection of health indicators for monitoring and reporting on ${widget.group.name} services.';
  }

  Future<void> _loadIndicators() async {
    try {
      // Ensure indicators are loaded
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }

      // Get indicators for this group
      final indicators =
          _indicatorService.getIndicatorsByGroup(widget.group.id);

      setState(() {
        _indicators = indicators;
        _filteredIndicators = indicators;
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
    final displayTitle = widget.subGroup ?? widget.group.name;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar - compact version with group color
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              color: _getGroupColor(),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _searchController.text.isEmpty
                            ? '${_indicators.length} indicator${_indicators.length != 1 ? 's' : ''}'
                            : '${_filteredIndicators.length} of ${_indicators.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Description Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
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
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: saGovernmentGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'About this indicator group',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: saGovernmentGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getGroupDescription(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search indicators in this group...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(
                    Icons.search,
                    color: saGovernmentGreen,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade400),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                    : _filteredIndicators.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchController.text.isEmpty
                                        ? Icons.inventory_2_outlined
                                        : Icons.search_off,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isEmpty
                                        ? 'No indicators found in this group'
                                        : 'No indicators match your search',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try different keywords or clear the search',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _filteredIndicators.length,
                            itemBuilder: (context, index) {
                              final indicator = _filteredIndicators[index];
                              return _buildIndicatorCard(indicator);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(SAIndicator indicator) {
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
        onTap: () {
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
                  _buildStatusBadge(indicator.status),
                  const SizedBox(width: 12),
                  // Expanded(
                  // child: Text(
                  //   indicator.indicatorId,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.grey.shade600,
                  //   ),
                  // ),
                  // ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (indicator.shortname.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  indicator.shortname,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    indicator.frequency,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.science_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    indicator.factorType,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
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

  Widget _buildStatusBadge(IndicatorStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case IndicatorStatus.newIndicator:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'NEW';
        break;
      case IndicatorStatus.amended:
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1E40AF);
        label = 'AMENDED';
        break;
      case IndicatorStatus.retainedWithNew:
        bgColor = const Color(0xFFFED7AA);
        textColor = const Color(0xFF9A3412);
        label = 'RETAINED+';
        break;
      case IndicatorStatus.retainedWithoutNew:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        label = 'RETAINED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
