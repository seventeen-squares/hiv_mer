import 'package:flutter/material.dart';
import '../models/data_element.dart';
import '../services/data_element_service.dart';
import '../utils/constants.dart';
import 'data_element_detail_screen.dart';

/// Screen showing all data element categories in an accordion layout
/// with data elements displayed in a grid under each category
class DataElementsScreen extends StatefulWidget {
  static const routeName = '/data-elements';

  const DataElementsScreen({super.key});

  @override
  State<DataElementsScreen> createState() => _DataElementsScreenState();
}

class _DataElementsScreenState extends State<DataElementsScreen> {
  final _dataElementService = DataElementService.instance;
  List<DataElementCategory> _categories = [];
  Map<String, List<DataElement>> _elementsByCategory = {};
  bool _isLoading = true;
  String? _error;
  String? _expandedCategoryId;

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

      // Get categories and data elements
      final categories = _dataElementService.getAllCategories();
      final elementsByCategory = <String, List<DataElement>>{};

      for (final category in categories) {
        elementsByCategory[category.id] =
            _dataElementService.getDataElementsByCategory(category.id);
      }

      setState(() {
        _categories = categories;
        _elementsByCategory = elementsByCategory;
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
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
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
    final isExpanded = _expandedCategoryId == category.id;
    final elements = _elementsByCategory[category.id] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? saGovernmentGreen : Colors.grey.shade200,
          width: isExpanded ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Category Header (Accordion trigger)
          InkWell(
            onTap: () {
              setState(() {
                _expandedCategoryId = isExpanded ? null : category.id;
              });
            },
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isExpanded ? Radius.zero : const Radius.circular(12),
              bottomRight: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: saGovernmentGreen.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft:
                      isExpanded ? Radius.zero : const Radius.circular(12),
                  bottomRight:
                      isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category.id).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.id),
                      color: _getCategoryColor(category.id),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category.id).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${elements.length}',
                      style: TextStyle(
                        color: _getCategoryColor(category.id),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: saGovernmentGreen,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Data Elements Grid (shown when expanded)
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: elements.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey.shade400),
                          const SizedBox(width: 12),
                          Text(
                            'No data elements in this category',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: elements.map((element) {
                        return _buildDataElementCard(element);
                      }).toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataElementCard(DataElement element) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          DataElementDetailScreen.routeName,
          arguments: element,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
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
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(element.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getCategoryIcon(element.category),
                    color: _getCategoryColor(element.category),
                    size: 18,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(element.status),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                element.shortname,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(DataElementStatus status) {
    Color color;
    String label;

    switch (status) {
      case DataElementStatus.newElement:
        color = const Color(0xFF10B981);
        label = 'NEW';
        break;
      case DataElementStatus.amended:
        color = const Color(0xFF3B82F6);
        label = 'AMD';
        break;
      case DataElementStatus.retained:
        color = const Color(0xFF6B7280);
        label = 'RET';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
