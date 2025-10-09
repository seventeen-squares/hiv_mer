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
    if (categoryId.contains('ART')) {
      return const Color(0xFFF59E0B);
    } else if (categoryId.contains('TB')) {
      return const Color(0xFF10B981);
    } else if (categoryId.contains('HIV')) {
      return const Color(0xFF8B5CF6);
    } else if (categoryId.contains('MCH')) {
      return const Color(0xFF06B6D4);
    } else if (categoryId.contains('IMMUNIZATION')) {
      return const Color(0xFFEC4899);
    } else if (categoryId.contains('COMMUNICABLE')) {
      return const Color(0xFF10B981);
    } else if (categoryId.contains('CHRONIC')) {
      return const Color(0xFF3B82F6);
    } else if (categoryId.contains('NUTRITION')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFFFF6B35); // Orange for data elements
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
            // Custom App Bar
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
                      'Data Elements',
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Icon
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
              const SizedBox(height: 10),
              // Category Name
              Flexible(
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              // Element Count Badge
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
