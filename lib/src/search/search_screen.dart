import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sa_indicator.dart';
import '../models/data_element.dart';
import '../models/indicator_group.dart';
import '../services/sa_indicator_service.dart';
import '../services/data_element_service.dart';
import '../indicators/indicator_list_by_group_screen.dart';
import '../widgets/standard_cards.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _indicatorService = SAIndicatorService.instance;
  final _dataElementService = DataElementService.instance;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<SAIndicator> _indicatorResults = [];
  List<DataElement> _dataElementResults = [];
  bool _isLoading = true;
  bool _hasSearched = false;
  bool _isSearching = false;
  Timer? _debounceTimer;
  
  String _selectedFilter = 'All'; // All, Indicators, Data Elements
  String _selectedSort = 'Relevance'; // Relevance, A-Z, Updated

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }
      if (!_dataElementService.isLoaded) {
        await _dataElementService.loadDataElements();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _hasSearched = false;
        _indicatorResults = [];
        _dataElementResults = [];
        _isSearching = false;
      });
      return;
    }

    // Show searching indicator
    setState(() {
      _isSearching = true;
    });

    // Debounce search by 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _hasSearched = true;
        _indicatorResults = _indicatorService.searchIndicators(query);
        _dataElementResults = _dataElementService.searchDataElements(query);
        _isSearching = false;
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Remove SafeArea to eliminate white space
          // Search Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            decoration: const BoxDecoration(
              color: saGovernmentGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEARCH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

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
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: AppColors.getTertiaryTextColor(context),
                        fontSize: 13,
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
                      fontSize: 13,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchFocusNode.unfocus(),
                  ),
                ),

                const SizedBox(height: 16),

                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 7),
                      _buildFilterChip('Indicators'),
                      const SizedBox(width: 7),
                      _buildFilterChip('Data Elements'),
                      const SizedBox(width: 10),
                      Container(width: 1, height: 24, color: Colors.white24),
                      const SizedBox(width: 10),
                      _buildSortChip(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSearchContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (!_hasSearched) {
      return _buildSearchSuggestions();
    }

    if (_indicatorResults.isEmpty && _dataElementResults.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    final popularSearches = ['ART', 'viral load', 'TB', 'PMTCT', 'retention'];
    final groups = _indicatorService.getAllGroups().take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Tips
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                    Icon(Icons.lightbulb_outline, color: saGovernmentGreen),
                    const SizedBox(width: 8),
                    const Text(
                      'Search Tips',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('• Search indicators and data elements',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text('• Search by ID, name, or keywords',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text('• Results show both types separately',
                    style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: popularSearches
                .map((search) => _buildSearchChip(search))
                .toList(),
          ),

          const SizedBox(height: 24),

          // Browse by Group
          const Text(
            'Browse by Indicator Group',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),

          ...groups.map((group) => _buildGroupTile(group)).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String searchTerm) {
    return ActionChip(
      label: Text(searchTerm),
      onPressed: () {
        _searchController.text = searchTerm;
        _searchFocusNode.requestFocus();
      },
      backgroundColor: saGovernmentGreen.withOpacity(0.1),
      labelStyle:
          TextStyle(color: saGovernmentGreen, fontWeight: FontWeight.w600),
      side: BorderSide(color: saGovernmentGreen.withOpacity(0.3)),
    );
  }

  Widget _buildGroupTile(IndicatorGroup group) {
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: saGovernmentGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.folder_outlined,
            color: saGovernmentGreen,
            size: 16,
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        subtitle: Text(
          '${group.indicatorCount} indicators',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey.shade400),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => IndicatorListByGroupScreen(group: group),
            ),
          );
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    var indicators = List<SAIndicator>.from(_indicatorResults);
    var dataElements = List<DataElement>.from(_dataElementResults);

    // Filter
    if (_selectedFilter == 'Indicators') {
      dataElements = [];
    } else if (_selectedFilter == 'Data Elements') {
      indicators = [];
    }

    // Sort
    if (_selectedSort == 'A-Z') {
      indicators.sort((a, b) => a.name.compareTo(b.name));
      dataElements.sort((a, b) => a.name.compareTo(b.name));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: saGovernmentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: saGovernmentGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Found ${indicators.length} indicator${indicators.length != 1 ? 's' : ''} and ${dataElements.length} data element${dataElements.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: saGovernmentGreen,
                  ),
                ),
              ],
            ),
          ),

          // Indicators Section
          if (indicators.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Indicators (${indicators.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(indicators.length, (index) {
              final indicator = indicators[index];
              return StandardIndicatorCard(indicator: indicator);
            }),
          ],

          // Data Elements Section
          if (dataElements.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Data Elements (${dataElements.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(dataElements.length, (index) {
              final dataElement = dataElements[index];
              return StandardDataElementCard(dataElement: dataElement);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.white.withOpacity(0.1),
      selectedColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? saGovernmentGreen : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      checkmarkColor: saGovernmentGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildSortChip() {
    return PopupMenuButton<String>(
      initialValue: _selectedSort,
      onSelected: (value) {
        setState(() {
          _selectedSort = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              _selectedSort,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Relevance', child: Text('Relevance')),
        const PopupMenuItem(value: 'A-Z', child: Text('A-Z')),
        const PopupMenuItem(value: 'Updated', child: Text('Updated')),
      ],
    );
  }
}
