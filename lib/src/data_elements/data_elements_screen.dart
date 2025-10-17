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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String categoryId) {
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
                    'Data Elements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                                'Error loading data elements',
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
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return _buildCategoryCard(category);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(DataElementCategory category) {
    final categoryColor = _getCategoryColor(category.id);
    final categoryIcon = _getCategoryIcon(category.id);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Icon - fixed alignment
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              // Category Name - fixed height for alignment
              SizedBox(
                height: 36, // Fixed height to accommodate 2 lines
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Element Count Badge - fixed alignment at bottom
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.elementCount} elements',
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
