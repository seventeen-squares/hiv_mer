import 'package:flutter/material.dart';
import '../models/mer_models.dart';
import '../services/mer_data_service.dart';
import '../indicators/indicator_detail_screen.dart';
import '../utils/app_colors.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MERDataService _dataService = MERDataService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<MERIndicator> _searchResults = [];
  bool _isLoading = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _dataService.loadData();
    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _hasSearched = query.isNotEmpty;
      _searchResults = _dataService.searchIndicators(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.shade600,
                    Colors.indigo.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          'QUICK SEARCH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.getSearchBarColor(context),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Theme.of(context).brightness == Brightness.dark
                          ? Border.all(color: AppColors.getBorderColor(context))
                          : null,
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText:
                            'Search indicators (e.g., TX_CURR, HIV Testing)',
                        hintStyle: TextStyle(
                          color: AppColors.getTertiaryTextColor(context),
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.getTertiaryTextColor(context),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: _clearSearch,
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.getTertiaryTextColor(context),
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.getPrimaryTextColor(context),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchFocusNode.unfocus(),
                    ),
                  ),
                ],
              ),
            ),

            // Search Results
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildSearchContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    if (!_hasSearched) {
      return _buildSearchSuggestions();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    final popularSearches = [
      'TX_CURR',
      'HTS_TST',
      'TX_NEW',
      'PMTCT_STAT',
      'TB_STAT'
    ];
    final recentPrograms = _dataService.programAreas.take(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Tips
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: Colors.amber.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'Search Tips',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• Search by indicator code (e.g., TX_CURR)'),
                  const Text(
                      '• Search by indicator name (e.g., Current on ART)'),
                  const Text('• Search by keywords (e.g., HIV testing)'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches
                .map((search) => _buildSearchChip(search))
                .toList(),
          ),

          const SizedBox(height: 24),

          // Browse by Program Area
          const Text(
            'Browse by Program Area',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...recentPrograms
              .map((program) => _buildProgramAreaTile(program))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String searchTerm) {
    return ActionChip(
      label: Text(searchTerm),
      onPressed: () {
        _searchController.text = searchTerm;
        _searchFocusNode.unfocus();
      },
      backgroundColor: Colors.indigo.shade50,
      labelStyle: TextStyle(color: Colors.indigo.shade700),
    );
  }

  Widget _buildProgramAreaTile(ProgramArea program) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getProgramColor(program.color),
          child: Icon(
            _getProgramIcon(program.icon),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          program.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(program.description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _searchController.text = program.id;
          _searchFocusNode.unfocus();
        },
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No indicators found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final indicator = _searchResults[index];
        return _buildIndicatorCard(indicator);
      },
    );
  }

  Widget _buildIndicatorCard(MERIndicator indicator) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            IndicatorDetailScreen.routeName,
            arguments: indicator,
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getProgramColor(indicator.programArea),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      indicator.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    indicator.programArea,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                indicator.definition,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    indicator.frequency,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.category, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    '${indicator.disaggregations.length} disaggregations',
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

  Color _getProgramColor(String program) {
    switch (program.toLowerCase()) {
      case 'hts':
        return Colors.blue.shade600;
      case 'tx':
        return Colors.green.shade600;
      case 'pmtct':
        return Colors.pink.shade600;
      case 'tb':
        return Colors.orange.shade600;
      case 'kp':
        return Colors.purple.shade600;
      case 'ovc':
        return Colors.teal.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getProgramIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'medical_services':
        return Icons.medical_services;
      case 'medication':
        return Icons.medication;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'air':
        return Icons.air;
      case 'group':
        return Icons.group;
      case 'child_care':
        return Icons.child_care;
      default:
        return Icons.info;
    }
  }
}
