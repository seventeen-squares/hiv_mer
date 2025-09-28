import '../models/mer_models.dart';

class MERDataService {
  static final MERDataService _instance = MERDataService._internal();
  factory MERDataService() => _instance;
  MERDataService._internal();

  List<MERIndicator> _indicators = [];
  List<ProgramArea> _programAreas = [];
  List<KeyFact> _keyFacts = [];

  // Mock data - in a real app this would come from JSON files in assets
  static const _mockIndicators = [
    {
      'code': 'TX_CURR',
      'name': 'Current on ART',
      'definition':
          'Number of adults and children currently receiving antiretroviral therapy (ART)',
      'numerator': 'Number of adults and children currently on treatment',
      'denominator': 'Not applicable',
      'disaggregations': ['Age/Sex', 'Key Populations'],
      'frequency': 'Quarterly',
      'notes':
          'Includes all patients with documented evidence of ART dispensed',
      'source': 'PEPFAR MER 2.6 (2024)',
      'programArea': 'TX'
    },
    {
      'code': 'HTS_TST',
      'name': 'HIV Testing Services',
      'definition':
          'Number of individuals who received HIV testing services (HTS) and received their test results',
      'numerator': 'Individuals tested for HIV and received results',
      'denominator': 'Not applicable',
      'disaggregations': ['Age/Sex', 'Entry Point', 'Test Result'],
      'frequency': 'Quarterly',
      'notes':
          'Exclude recency testing. Include only those who received test results',
      'source': 'PEPFAR MER 2.6 (2024)',
      'programArea': 'HTS'
    },
    {
      'code': 'TX_NEW',
      'name': 'New on ART',
      'definition':
          'Number of adults and children newly enrolled on antiretroviral therapy (ART)',
      'numerator': 'Adults and children newly enrolled on ART',
      'denominator': 'Not applicable',
      'disaggregations': ['Age/Sex', 'Key Populations'],
      'frequency': 'Quarterly',
      'notes': 'Newly enrolled means starting ART for the first time',
      'source': 'PEPFAR MER 2.6 (2024)',
      'programArea': 'TX'
    },
    {
      'code': 'PMTCT_STAT',
      'name': 'PMTCT HIV Status',
      'definition':
          'Number of pregnant women with known HIV status at first antenatal care visit',
      'numerator': 'Pregnant women with known HIV status at first ANC visit',
      'denominator': 'Total pregnant women attending first ANC visit',
      'disaggregations': ['Age', 'HIV Status'],
      'frequency': 'Quarterly',
      'notes': 'Include both HIV positive and negative women',
      'source': 'PEPFAR MER 2.6 (2024)',
      'programArea': 'PMTCT'
    },
    {
      'code': 'TB_STAT',
      'name': 'TB Screening Status',
      'definition':
          'Number of HIV-positive patients on antiretroviral therapy (ART) screened for TB',
      'numerator': 'HIV+ patients on ART screened for TB',
      'denominator': 'Not applicable',
      'disaggregations': ['Age/Sex', 'Screen Result'],
      'frequency': 'Quarterly',
      'notes': 'TB screening should occur at every clinical encounter',
      'source': 'PEPFAR MER 2.6 (2024)',
      'programArea': 'TB'
    }
  ];

  static const _mockProgramAreas = [
    {
      'id': 'HTS',
      'name': 'HIV Testing Services',
      'description': 'HIV testing and counseling services',
      'icon': 'medical_services',
      'color': 'blue'
    },
    {
      'id': 'TX',
      'name': 'Treatment',
      'description': 'HIV treatment and care services',
      'icon': 'medication',
      'color': 'green'
    },
    {
      'id': 'PMTCT',
      'name': 'PMTCT',
      'description': 'Prevention of mother-to-child transmission',
      'icon': 'pregnant_woman',
      'color': 'pink'
    },
    {
      'id': 'TB',
      'name': 'TB/HIV',
      'description': 'TB and HIV coinfection services',
      'icon': 'air',
      'color': 'orange'
    },
    {
      'id': 'KP',
      'name': 'Key Populations',
      'description': 'Services for key populations',
      'icon': 'group',
      'color': 'purple'
    },
    {
      'id': 'OVC',
      'name': 'OVC',
      'description': 'Orphans and vulnerable children',
      'icon': 'child_care',
      'color': 'teal'
    }
  ];

  static const _mockKeyFacts = [
    {
      'title': 'Global PEPFAR Sites',
      'value': '55,000+',
      'description': 'PEPFAR-supported service delivery sites globally',
      'trend': 'stable',
      'subtitle': 'Across 50+ countries'
    },
    {
      'title': 'People on ART',
      'value': '20.1M',
      'description': 'People receiving life-saving antiretroviral treatment',
      'trend': 'up',
      'subtitle': 'As of FY2023'
    },
    {
      'title': 'HIV Tests Conducted',
      'value': '69.3M',
      'description': 'HIV testing services provided annually',
      'trend': 'stable',
      'subtitle': 'FY2023 results'
    },
    {
      'title': 'PMTCT Coverage',
      'value': '95%',
      'description': 'Pregnant women knowing their HIV status',
      'trend': 'up',
      'subtitle': 'Target achieved in key countries'
    }
  ];

  Future<void> loadData() async {
    // In a real app, you would load from JSON files in assets
    // For now, we'll use mock data
    _indicators =
        _mockIndicators.map((json) => MERIndicator.fromJson(json)).toList();
    _programAreas =
        _mockProgramAreas.map((json) => ProgramArea.fromJson(json)).toList();
    _keyFacts = _mockKeyFacts.map((json) => KeyFact.fromJson(json)).toList();
  }

  List<MERIndicator> get indicators => _indicators;
  List<ProgramArea> get programAreas => _programAreas;
  List<KeyFact> get keyFacts => _keyFacts;

  List<MERIndicator> searchIndicators(String query) {
    if (query.isEmpty) return _indicators;

    return _indicators.where((indicator) {
      return indicator.code.toLowerCase().contains(query.toLowerCase()) ||
          indicator.name.toLowerCase().contains(query.toLowerCase()) ||
          indicator.definition.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<MERIndicator> getIndicatorsByProgramArea(String programAreaId) {
    return _indicators
        .where((indicator) => indicator.programArea == programAreaId)
        .toList();
  }

  MERIndicator? getIndicatorByCode(String code) {
    try {
      return _indicators.firstWhere(
          (indicator) => indicator.code.toLowerCase() == code.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}
