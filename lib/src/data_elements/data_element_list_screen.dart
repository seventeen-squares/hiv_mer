import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data_element.dart';
import '../services/data_element_service.dart';
import '../utils/constants.dart';
import 'data_element_detail_screen.dart';

/// Screen showing a list of data elements for a specific category
class DataElementListScreen extends StatefulWidget {
  static const routeName = '/data-element-list';

  const DataElementListScreen({super.key});

  @override
  State<DataElementListScreen> createState() => _DataElementListScreenState();
}

class _DataElementListScreenState extends State<DataElementListScreen> {
  final _dataElementService = DataElementService.instance;
  List<DataElement> _dataElements = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'] as String;

    try {
      // Ensure data elements are loaded
      if (!_dataElementService.isLoaded) {
        await _dataElementService.loadDataElements();
      }

      final elements =
          _dataElementService.getDataElementsByCategory(categoryId);

      setState(() {
        _dataElements = elements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data elements: $e')),
        );
      }
    }
  }

  Color _getStatusColor(DataElementStatus status) {
    switch (status) {
      case DataElementStatus.newElement:
        return const Color(0xFF10B981);
      case DataElementStatus.amended:
        return const Color(0xFFF59E0B);
      case DataElementStatus.retained:
        return const Color(0xFF3B82F6);
    }
  }

  String _getStatusText(DataElementStatus status) {
    switch (status) {
      case DataElementStatus.newElement:
        return 'NEW';
      case DataElementStatus.amended:
        return 'AMENDED';
      case DataElementStatus.retained:
        return 'RETAINED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final categoryName = args['categoryName'] as String;
    final categoryColor = args['categoryColor'] as Color?;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            // Custom App Bar with category color
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              decoration: BoxDecoration(
                color: categoryColor ?? saGovernmentGreen,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_dataElements.length} data elements',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
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
                  : _dataElements.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dataset_outlined,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Data Elements',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No data elements found in this category',
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
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _dataElements.length,
                          itemBuilder: (context, index) {
                            final element = _dataElements[index];
                            return _buildDataElementCard(
                                element, categoryColor);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataElementCard(DataElement element, Color? categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              DataElementDetailScreen.routeName,
              arguments: element,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with ID and Status
                Row(
                  children: [
                    // Data Element Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (categoryColor ?? saGovernmentGreen)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.data_object,
                        color: categoryColor ?? saGovernmentGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            element.id,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            element.category,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(element.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(element.status),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(element.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Data Element Name
                Text(
                  element.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                // Data Type
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      element.dataType,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (element.aggregationType.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.functions,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        element.aggregationType,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
