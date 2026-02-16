import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../widgets/standard_cards.dart';
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
  bool _isAboutExpanded = false;

  // Filters
  final Set<String> _selectedFilters = {};
  String _currentSort = 'Default';

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
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    final query = _searchController.text.toLowerCase();
    
    // 1. Filter
    var filtered = _indicators.where((indicator) {
      // Text search
      final matchesQuery = query.isEmpty || 
          indicator.name.toLowerCase().contains(query) ||
          indicator.shortname.toLowerCase().contains(query) ||
          indicator.indicatorId.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      // Chip filters
      if (_selectedFilters.isEmpty) return true;

      // Check each selected filter
      // If multiple filters are selected, usually it's OR within category, AND across categories?
      // For simplicity, let's say indicator must match ANY of the selected filters (OR logic) 
      // OR better: specific handling per category. 
      // Let's assume the user selects "Monthly" and "Outcome" -> (Monthly AND Outcome).
      // But if "Monthly" and "Quarterly" -> (Monthly OR Quarterly).
      // Hard to implement complex logic with simple chips. Simple intersection is easiest:
      // Indicator matches IF it has property X where X is in filters.
      // Actually standard pattern is: if any filter in a Category is selected, the item must match one of them.
      
      final levels = <String>{};
      final freqs = <String>{};
      final units = <String>{};
      final statuses = <String>{};
      
      for (final f in _selectedFilters) {
        if (['Input', 'Process', 'Output', 'Outcome', 'Impact'].contains(f)) levels.add(f);
        if (['Monthly', 'Quarterly', 'Annually'].contains(f)) freqs.add(f);
        if (['Count', '%'].contains(f)) units.add(f);
        if (['New', 'Amended', 'Retained', 'Retained+'].contains(f)) statuses.add(f);
      }
      
      bool matchesLevel = levels.isEmpty || levels.contains(_getIndicatorLevel(indicator));
      bool matchesFreq = freqs.isEmpty || freqs.contains(indicator.frequency);
      bool matchesUnit = units.isEmpty || units.contains(indicator.factorType.isEmpty ? 'Count' : indicator.factorType);
      
      String statusStr = 'Unknown';
      if (indicator.status == IndicatorStatus.newIndicator) statusStr = 'New';
      if (indicator.status == IndicatorStatus.amended) statusStr = 'Amended';
      if (indicator.status == IndicatorStatus.retainedWithoutNew) statusStr = 'Retained';
      if (indicator.status == IndicatorStatus.retainedWithNew) statusStr = 'Retained+';
      bool matchesStatus = statuses.isEmpty || statuses.contains(statusStr);
      
      return matchesLevel && matchesFreq && matchesUnit && matchesStatus;
    }).toList();

    // 2. Sort
    switch (_currentSort) {
      case 'A-Z':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Level':
        final order = {'Input': 0, 'Process': 1, 'Output': 2, 'Outcome': 3, 'Impact': 4};
        filtered.sort((a, b) {
          final levelA = _getIndicatorLevel(a);
          final levelB = _getIndicatorLevel(b);
          return (order[levelA] ?? 99).compareTo(order[levelB] ?? 99);
        });
        break;
      case 'Freq':
         final order = {'Monthly': 0, 'Quarterly': 1, 'Annually': 2};
         filtered.sort((a, b) {
           return (order[a.frequency] ?? 99).compareTo(order[b.frequency] ?? 99);
         });
        break;
      case 'Default':
      default:
        filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        break;
    }

    setState(() {
      _filteredIndicators = filtered;
    });
  }

  String _getIndicatorLevel(SAIndicator i) {
    final lower = i.name.toLowerCase() + i.definition.toLowerCase();
    if (lower.contains('outcome') || lower.contains('retention') || lower.contains('suppress') || lower.contains('cure')) {
      return 'Outcome';
    } else if (lower.contains('start') || lower.contains('initiat') || lower.contains('screen') || lower.contains('test')) {
      return 'Process';
    } else {
      return 'Output';
    }
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _searchController.text.isEmpty
                            ? '${_indicators.length} indicators • ${_getGroupSummary()}'
                            : '${_filteredIndicators.length} of ${_indicators.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 9,
                        ),
                      ),
                    ],
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
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // Dynamic About Card
                            _buildAboutCard(context),

                            // Search Bar
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                                    hintText:
                                        'Search indicators in this group...',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: saGovernmentGreen,
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_searchController.text.isNotEmpty)
                                          IconButton(
                                            icon: Icon(Icons.clear,
                                                color: Colors.grey.shade400),
                                            onPressed: () {
                                              _searchController.clear();
                                            },
                                          ),
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.sort, color: Colors.grey.shade600),
                                          onSelected: (value) {
                                            setState(() {
                                              _currentSort = value;
                                            });
                                            _applyFiltersAndSort();
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(value: 'Default', child: Text('Default Order')),
                                            const PopupMenuItem(value: 'A-Z', child: Text('Name (A-Z)')),
                                            const PopupMenuItem(value: 'Level', child: Text('Level (Process→Outcome)')),
                                            const PopupMenuItem(value: 'Freq', child: Text('Frequency')),
                                          ],
                                        ),
                                      ],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            
                            // Filters
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              child: Row(
                                children: [
                                  _buildFilterChip('Process'),
                                  _buildFilterChip('Output'),
                                  _buildFilterChip('Outcome'),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 20, color: Colors.grey.shade300),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Monthly'),
                                  _buildFilterChip('Quarterly'),
                                  _buildFilterChip('Annually'),
                                  const SizedBox(width: 8),
                                   Container(width: 1, height: 20, color: Colors.grey.shade300),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Count'),
                                  _buildFilterChip('%'),
                                  const SizedBox(width: 8),
                                  Container(width: 1, height: 20, color: Colors.grey.shade300),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('New'),
                                  _buildFilterChip('Amended'),
                                  _buildFilterChip('Retained'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Indicators List or Empty State
                            _filteredIndicators.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
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
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        if (_searchController
                                            .text.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Try different keywords or clear the search',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: _filteredIndicators
                                          .map((indicator) =>
                                              CompactIndicatorCard(
                                                indicator: indicator,
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                    IndicatorDetailScreen.routeName,
                                                    arguments: indicator,
                                                  );
                                                },
                                              ))
                                          .toList(),
                                    ),
                                  ),

                            // Bottom padding for better scrolling
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilters.contains(label);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedFilters.add(label);
            } else {
              _selectedFilters.remove(label);
            }
          });
          _applyFiltersAndSort();
        },
        backgroundColor: Colors.white,
        selectedColor: saGovernmentGreen.withOpacity(0.1),
        labelStyle: TextStyle(
          fontSize: 11,
          color: isSelected ? saGovernmentGreen : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? saGovernmentGreen : Colors.grey.shade300,
            width: 1,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header used for toggling
          InkWell(
            onTap: () {
              setState(() {
                _isAboutExpanded = !_isAboutExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: saGovernmentGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'About this indicator group',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: saGovernmentGreen,
                    ),
                  ),
                  const Spacer(),
                  // Summary in header line? No, user asked for header then summary below in collapsed view
                  Icon(
                    _isAboutExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          
          if (!_isAboutExpanded)
            // Collapsed View
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    _getGroupDescription(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _buildAtAGlanceRow(),
                ],
              ),
            )
          else
            // Expanded View
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Overview'),
                  Text(
                    _getGroupDescription(), // Long description
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionTitle('Reporting focus'),
                  ..._getReportingFocus().map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(e, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))),
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 16),
                  
                  _buildSectionTitle('At a glance'),
                  _buildDetailRow('Indicator count', '${_indicators.length}'),
                  _buildDetailRow('Frequency mix', _getFrequencyMix()),
                  _buildDetailRow('Unit/Type mix', _getTypeMix()),
                  _buildDetailRow('Level mix', _getLevelMix()),
                  _buildDetailRow('Annualised', _getAnnualisedCount() > 0 ? 'Yes (${_getAnnualisedCount()})' : 'No'),
                  const SizedBox(height: 16),
                  
                  _buildSectionTitle('Data sources'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getDataSources().map((s) => _buildChip(s, Colors.blue.shade50)).toList(),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Typical users'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getTypicalUsers().map((s) => _buildChip(s, Colors.orange.shade50)).toList(),
                  ),
                  const SizedBox(height: 16),

                  _buildSectionTitle('Notes / interpretation'),
                  Text(
                    _getNotes(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  
                   Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Last updated: ${_getLastUpdated()}', 
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAtAGlanceRow() {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
        children: [
          const TextSpan(text: 'Indicators: ', style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: '${_indicators.length}'),
          TextSpan(text: ' • ', style: TextStyle(color: Colors.grey.shade400)),
          const TextSpan(text: 'Freq: ', style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: _getFrequencySummary()),
          TextSpan(text: ' • ', style: TextStyle(color: Colors.grey.shade400)),
          const TextSpan(text: 'Mostly: ', style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: _getTypeSummary()),
          TextSpan(text: ' • ', style: TextStyle(color: Colors.grey.shade400)),
          const TextSpan(text: 'Levels: ', style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: _getLevelSummary()),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
     return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
      ),
    );
  }

  // --- Helper Data Methods ---

  String _getFrequencySummary() {
    final counts = <String, int>{};
    for (var i in _indicators) {
      counts[i.frequency] = (counts[i.frequency] ?? 0) + 1;
    }
    if (counts.isEmpty) return 'N/A';
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
  
  String _getTypeSummary() {
    final counts = <String, int>{};
    for (var i in _indicators) {
      final type = i.factorType.isEmpty ? 'Count' : i.factorType;
       counts[type] = (counts[type] ?? 0) + 1;
    }
    if (counts.isEmpty) return 'Count';
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
  
  String _getLevelSummary() {
    int outcome = 0;
    int process = 0;
    int output = 0;
    
    for (var i in _indicators) {
      final lower = i.name.toLowerCase() + i.definition.toLowerCase();
      if (lower.contains('outcome') || lower.contains('retention') || lower.contains('suppress') || lower.contains('cure')) {
        outcome++;
      } else if (lower.contains('start') || lower.contains('initiat') || lower.contains('screen') || lower.contains('test')) {
        process++;
      } else {
        output++;
      }
    }
    
    final parts = <String>[];
    if (process > 0) parts.add('Process');
    if (output > 0) parts.add('Output');
    if (outcome > 0) parts.add('Outcome');
    if (parts.isEmpty) return 'Output';
    return parts.join('/');
  }

  String _getGroupSummary() {
    int monthly = 0;
    int quarterly = 0;
    int outcome = 0;
    
    for (var i in _indicators) {
      if (i.frequency == 'Monthly') monthly++;
      if (i.frequency == 'Quarterly') quarterly++;
      
      final lower = i.name.toLowerCase() + i.definition.toLowerCase();
      if (lower.contains('outcome') || lower.contains('retention') || lower.contains('suppress') || lower.contains('cure')) {
        outcome++;
      }
    }
    
    final parts = <String>[];
    if (monthly > 0) parts.add('Monthly $monthly');
    if (quarterly > 0) parts.add('Quarterly $quarterly');
    if (outcome > 0) parts.add('Outcomes $outcome');
    
    if (parts.isEmpty && _indicators.isNotEmpty) return '${_indicators.length} Items';
    if (parts.isEmpty) return 'No indicators';
    
    return parts.join(' | ');
  }
  
  List<String> _getReportingFocus() {
    // Generate derived insights
    final focus = <String>[];
    if (_indicators.any((i) => i.name.toLowerCase().contains('start') || i.name.toLowerCase().contains('initiat'))) {
      focus.add('Monitoring new treatment initiations');
    }
    if (_indicators.any((i) => i.name.toLowerCase().contains('retention') || i.name.toLowerCase().contains('remain'))) {
      focus.add('Tracking patient retention and continuity of care');
    }
     if (_indicators.any((i) => i.name.toLowerCase().contains('suppressed') || i.name.toLowerCase().contains('cured'))) {
      focus.add('Evaluating treatment success and health outcomes');
    }
    if (focus.isEmpty) {
      focus.add('General monitoring of ${widget.group.name} services');
      focus.add('Tracking service delivery volume and coverage');
    }
    return focus;
  }

  String _getFrequencyMix() {
    final counts = <String, int>{};
    for (var i in _indicators) {
      counts[i.frequency] = (counts[i.frequency] ?? 0) + 1;
    }
    if (counts.isEmpty) return 'None';
    return counts.entries.map((e) => '${e.key} (${e.value})').join(' | ');
  }

  String _getTypeMix() {
    final counts = <String, int>{};
    for (var i in _indicators) {
      final type = i.factorType.isEmpty ? 'Count' : i.factorType;
       counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts.entries.map((e) => '${e.key}').join(' / ');
  }
  
  String _getLevelMix() {
    // Rudimentary classification
    int output = 0;
    int outcome = 0;
    int process = 0;
    
    for (var i in _indicators) {
      final lower = i.name.toLowerCase() + i.definition.toLowerCase();
      if (lower.contains('outcome') || lower.contains('retention') || lower.contains('suppress') || lower.contains('cure')) {
        outcome++;
      } else if (lower.contains('start') || lower.contains('initiat') || lower.contains('screen') || lower.contains('test')) {
        process++;
      } else {
        output++;
      }
    }
    
    final parts = <String>[];
    if (process > 0) parts.add('Process');
    if (output > 0) parts.add('Output');
    if (outcome > 0) parts.add('Outcome');
    return parts.join('/');
  }
  
  int _getAnnualisedCount() {
    return _indicators.where((i) => i.frequency.toLowerCase() == 'annually').length;
  }
  
  List<String> _getDataSources() {
    // Inferred based on group
    final group = widget.group.id.toLowerCase();
    if (group.contains('hiv') || group.contains('art')) return ['TIER.Net', 'DHIS2'];
    if (group.contains('tb')) return ['TIER.Net', 'EDRWeb', 'DHIS2'];
    if (group.contains('hospital')) return ['Inpatient Registers', 'DHIS2'];
    return ['Facility Registers', 'DHIS2'];
  }
  
  List<String> _getTypicalUsers() {
     // Inferred based on group
    return ['Facility Manager', 'Information Officer', 'Programme Coordinator'];
  }
  
  String _getNotes() {
    return 'Verify all data against source registers before reporting. Trends should be interpreted with context of service disruptions.';
  }
  
  String _getLastUpdated() {
    return '16 Feb 2026 (v4.0.8)';
  }
}
