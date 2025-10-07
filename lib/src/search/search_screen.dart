import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sa_indicator.dart';
import '../models/indicator_group.dart';
import '../services/sa_indicator_service.dart';
import '../indicators/indicator_detail_screen.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<SAIndicator> _searchResults = [];
  bool _isLoading = true;
  bool _hasSearched = false;
  bool _isSearching = false;
  Timer? _debounceTimer;

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
        _searchResults = [];
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
        _searchResults = _indicatorService.searchIndicators(query);
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
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: saGovernmentGreen,
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
                          'SEARCH INDICATORS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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
                            'Search indicators (e.g., ART, TB, viral load)',
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
                                  color:
                                      AppColors.getTertiaryTextColor(context),
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
                  : _isSearching
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('• Search by indicator ID (e.g., NIDS-RF-001)',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text('• Search by name (e.g., ART Initiations)',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 4),
                Text('• Search by keywords (e.g., viral load, TB)',
                    style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
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

          // Browse by Group
          const Text(
            'Browse by Indicator Group',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),

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
            size: 24,
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
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey.shade400),
        onTap: () {
          _searchController.text = group.name;
          _searchFocusNode.requestFocus();
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
                    child: Text(
                      indicator.indicatorId,
                      style: TextStyle(
                        color: saGovernmentGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(indicator.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (indicator.shortname.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  indicator.shortname,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                indicator.definition,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
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
                  Icon(Icons.science_outlined,
                      size: 16, color: Colors.grey.shade500),
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
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
