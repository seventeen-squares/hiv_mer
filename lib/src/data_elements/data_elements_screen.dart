import 'package:flutter/material.dart';
import '../models/data_element.dart';
import '../services/data_element_service.dart';
import '../utils/constants.dart';
import 'data_element_list_screen.dart';

/// Screen showing all data element categories as clickable cards
class DataElementsScreen extends StatefulWidget {
  static const routeName = '/data-elements';

  const DataElementsScreen({super.key});

  @override
  State<DataElementsScreen> createState() => _DataElementsScreenState();
}

class _DataElementsScreenState extends State<DataElementsScreen> {
  final _dataElementService = DataElementService.instance;
  List<DataElementCategory> _categories = [];
  List<DataElementCategory> _filteredCategories = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String? _selectedFilter;

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

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterCategories();
    });
  }

  void _filterCategories() {
    if (_categories.isEmpty) return;

    setState(() {
      _filteredCategories = _categories.where((category) {
        final matchesSearch = category.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            category.id.toLowerCase().contains(_searchQuery.toLowerCase());
            
        if (!matchesSearch) return false;

        if (_selectedFilter != null) {
          // Filter logic based on chips (e.g., frequency, tool)
          // Since category object doesn't have these, we'd need to check elements inside
           final elements = _dataElementService.getDataElementsByCategory(category.id);
           
           if (_selectedFilter == 'Monthly') {
             return elements.any((e) => e.frequency.toLowerCase().contains('month'));
           } else if (_selectedFilter == 'Quarterly') {
             return elements.any((e) => e.frequency.toLowerCase().contains('quarter'));
           } else if (_selectedFilter!.startsWith('Tool:')) {
             final tool = _selectedFilter!.substring(5).trim().toLowerCase();
             return elements.any((e) => e.tools.toLowerCase().contains(tool));
           }
        }
        
        return true;
      }).toList();
    });
  }

  Future<void> _loadData() async {
    try {
      // Ensure data elements are loaded
      if (!_dataElementService.isLoaded) {
        await _dataElementService.loadDataElements();
      }

      // Get categories
      final categories = _dataElementService.getAllCategories();

      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Helper to get aggregated metrics for a category
  Map<String, String> _getCategoryMetrics(String categoryId) {
    final elements = _dataElementService.getDataElementsByCategory(categoryId);
    
    if (elements.isEmpty) {
      return {'tool': 'Unknown', 'collectionPoint': 'Unknown'};
    }

    // Calculate most common tool
    final tools = <String, int>{};
    final collectionPoints = <String, int>{};

    for (var element in elements) {
      // Tools
      if (element.tools.isNotEmpty && element.tools != 'None') {
        final toolList = element.tools.split(RegExp(r'[,;]')).map((e) => e.trim()).where((e) => e.isNotEmpty);
        for (var tool in toolList) {
          tools[tool] = (tools[tool] ?? 0) + 1;
        }
      }

      // Collection Points
      if (element.collectionPoints.isNotEmpty && element.collectionPoints != 'None') {
         final cpList = element.collectionPoints.split(RegExp(r'[,;]')).map((e) => e.trim()).where((e) => e.isNotEmpty);
        for (var cp in cpList) {
          collectionPoints[cp] = (collectionPoints[cp] ?? 0) + 1;
        }
      }
    }

    String topTool = '';
    if (tools.isNotEmpty) {
      final sortedTools = tools.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      topTool = sortedTools.first.key;
    }

    String topCP = '';
    if (collectionPoints.isNotEmpty) {
       final sortedCP = collectionPoints.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
       topCP = sortedCP.first.key;
    }

    return {
      'tool': topTool.isEmpty ? 'Multiple tools' : topTool, 
      'collectionPoint': topCP.isEmpty ? 'Facility' : topCP
    };
  }

  IconData _getCategoryIcon(DataElementCategory category) {
    // Try to get icon from JSON mapping first
    if (category.icon != null) {
      final iconName = category.icon!;
      
      // Direct mapping for icons in the JSON
      switch (iconName) {
        case 'health_and_safety_outlined': return Icons.health_and_safety_outlined;
        case 'medication_outlined': return Icons.medication_outlined;
        case 'child_care_outlined': return Icons.child_care; // No outlined variant
        case 'biotech_outlined': return Icons.biotech; // No outlined variant
        case 'emergency_outlined': return Icons.emergency_outlined;
        case 'eco_outlined': return Icons.eco_outlined;
        case 'vaccines_outlined': return Icons.vaccines; // No outlined variant
        case 'visibility_outlined': return Icons.visibility_outlined;
        case 'hotel_outlined': return Icons.hotel_outlined;
        case 'dashboard_outlined': return Icons.dashboard_outlined;
        case 'pregnant_woman_outlined': return Icons.pregnant_woman; // No outlined variant
        case 'psychology_outlined': return Icons.psychology_outlined;
        case 'monitor_heart_outlined': return Icons.monitor_heart_outlined;
        case 'emoji_emotions_outlined': return Icons.emoji_emotions_outlined;
        case 'check_circle_outline': return Icons.check_circle_outline;
        case 'accessible_forward_outlined': return Icons.accessible_forward_outlined;
        case 'dirty_lens_outlined': return Icons.dirty_lens; // No outlined variant
        case 'school_outlined': return Icons.school_outlined;
        case 'masks_outlined': return Icons.masks_outlined;
        case 'groups_outlined': return Icons.groups_outlined;
      }
    }

    // Fallback to ID-based logic
    final categoryId = category.id;
    if (categoryId.contains('ART') || categoryId.contains('art')) {
      return Icons.medication;
    } else if (categoryId.contains('TB') || categoryId.contains('tb')) {
      return Icons.masks;
    } else if (categoryId.contains('HIV') || categoryId.contains('hiv')) {
      return Icons.health_and_safety;
    } else if (categoryId.contains('MCH') || categoryId.contains('maternal')) {
      return Icons.child_care;
    } else if (categoryId.contains('IMMUNIZATION') ||
        categoryId.contains('immunization')) {
      return Icons.vaccines;
    } else if (categoryId.contains('COMMUNICABLE') ||
        categoryId.contains('disease')) {
      return Icons.people;
    } else if (categoryId.contains('CHRONIC') ||
        categoryId.contains('chronic')) {
      return Icons.local_pharmacy;
    } else if (categoryId.contains('NUTRITION') ||
        categoryId.contains('nutrition')) {
      return Icons.restaurant;
    }
    return Icons.dataset;
  }

  Color _getCategoryColor(String categoryId) {
    final categoryLower = categoryId.toLowerCase();

    // Use the same color scheme as indicators
    if (categoryLower.contains('adolescent')) {
      return const Color(0xFF5DADE2);
    } else if (categoryLower.contains('art baseline')) {
      return const Color(0xFFA1887F);
    } else if (categoryLower.contains('art monthly')) {
      return const Color(0xFFE91E63);
    } else if (categoryLower.contains('art outcome')) {
      return const Color(0xFF827717);
    } else if (categoryLower.contains('art')) {
      return const Color(0xFFA1887F);
    } else if (categoryLower.contains('chronic medicine') ||
        categoryLower.contains('central chronic')) {
      return const Color(0xFF00897B);
    } else if (categoryLower.contains('child') ||
        categoryLower.contains('nutrition')) {
      return const Color(0xFF81D4FA);
    } else if (categoryLower.contains('chronic')) {
      return const Color(0xFFFFEB3B);
    } else if (categoryLower.contains('communicable')) {
      return const Color(0xFFFF7043);
    } else if (categoryLower.contains('emergency') ||
        categoryLower.contains('ems')) {
      return const Color(0xFF424242);
    } else if (categoryLower.contains('environmental')) {
      return const Color(0xFFCDDC39);
    } else if (categoryLower.contains('epi') ||
        categoryLower.contains('immunis') ||
        categoryLower.contains('immunization')) {
      return const Color(0xFFF44336);
    } else if (categoryLower.contains('eye')) {
      return const Color(0xFFF8BBD0);
    } else if (categoryLower.contains('hiv')) {
      return const Color(0xFF7986CB);
    } else if (categoryLower.contains('malaria')) {
      return const Color(0xFF66BB6A);
    } else if (categoryLower.contains('inpatient') ||
        categoryLower.contains('management inpatient')) {
      return const Color(0xFFE91E63);
    } else if (categoryLower.contains('phc') ||
        categoryLower.contains('primary health')) {
      return const Color(0xFF00BCD4);
    } else if (categoryLower.contains('maternal') ||
        categoryLower.contains('neonatal') ||
        categoryLower.contains('mch')) {
      return const Color(0xFFFF9800);
    } else if (categoryLower.contains('mental')) {
      return const Color(0xFFAED581);
    } else if (categoryLower.contains('oral') ||
        categoryLower.contains('dental')) {
      return const Color(0xFFD4E157);
    } else if (categoryLower.contains('wbot') ||
        categoryLower.contains('ward based') ||
        categoryLower.contains('outreach')) {
      return const Color(0xFF9E9E9E);
    } else if (categoryLower.contains('quality')) {
      return const Color(0xFF7E57C2);
    } else if (categoryLower.contains('rehab')) {
      return const Color(0xFFB39DDB);
    } else if (categoryLower.contains('school')) {
      return const Color(0xFFC62828);
    } else if (categoryLower.contains('sti') ||
        categoryLower.contains('sexually transmitted')) {
      return const Color(0xFFBCAAA4);
    } else if (categoryLower.contains('tb') &&
        categoryLower.contains('monthly')) {
      return const Color(0xFF00BCD4);
    } else if (categoryLower.contains('tb') &&
        categoryLower.contains('quarterly')) {
      return const Color(0xFF8D6E63);
    } else if (categoryLower.contains('tb')) {
      return const Color(0xFF00BCD4);
    } else if (categoryLower.contains('women')) {
      return const Color(0xFFE57373);
    }
    return const Color(0xFFFF6B35); // Default orange for data elements
  }

  @override
  Widget build(BuildContext context) {
    // Check if we can pop (i.e., if we're in a navigation stack)
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 8.0,
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
                    'Data Elements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 IconButton(
                  onPressed: () => _showHelpDialog(context),
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.question_mark,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  tooltip: 'What are data elements?',
                ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search data elements...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: saGovernmentGreen, width: 2),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Monthly'),
                const SizedBox(width: 8),
                _buildFilterChip('Quarterly'),
                const SizedBox(width: 8),
                _buildFilterChip('Tool: TIER.Net'),
                const SizedBox(width: 8),
                _buildFilterChip('Tool: Register'),
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
                                'Error loading data elements',
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
                    : _filteredCategories.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  'No categories found matching filters',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0, // Square-ish cards
                        ),
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];
                          return _buildCategoryCard(category);
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label || (label == 'All' && _selectedFilter == null);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (label == 'All') {
            _selectedFilter = null;
          } else {
            _selectedFilter = selected ? label : null;
          }
          _filterCategories();
        });
      },
      backgroundColor: Colors.white,
      selectedColor: saGovernmentGreen.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? saGovernmentGreen : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? saGovernmentGreen : Colors.grey.shade300,
        ),
      ),
      showCheckmark: false,
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: saGovernmentGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.data_usage, color: saGovernmentGreen),
            ),
            const SizedBox(width: 12),
            const Text('What are Data Elements?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Data elements are the raw counts used to build indicators.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'For example, "Number of new ART patients" is a data element that feeds into broader indicators like "ART Retention".',
            ),
            SizedBox(height: 12),
            Text(
              'Tap a group to see elements, definitions, where collected, and tools used.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: saGovernmentGreen)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(DataElementCategory category) {
    final categoryColor = _getCategoryColor(category.id);
    final categoryIcon = _getCategoryIcon(category);
    final metrics = _getCategoryMetrics(category.id);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            DataElementListScreen.routeName,
            arguments: {
              'categoryId': category.id,
              'categoryName': category.name,
              'categoryColor': categoryColor,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Color Panel (Reduced height)
              Container(
                height: 48, // Reduced height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 24,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Name
                    SizedBox(
                      height: 36, // Fixed height for 2 lines
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Metrics Row (Combined)
                    Row(
                      children: [
                        // Count Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            '${category.elementCount}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Dot separator
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Tool info
                        Expanded(
                          child: Text(
                            (metrics['tool'] != null && metrics['tool'] != 'Multiple tools') 
                                ? metrics['tool']!.replaceAll('MULTIPLE TOOLS', 'Multiple')
                                : metrics['collectionPoint'] ?? 'Facility',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
