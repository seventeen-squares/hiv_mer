import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data_element.dart';
import '../services/data_element_service.dart';
import '../utils/constants.dart';
import '../widgets/standard_cards.dart';


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
                            return StandardDataElementCard(dataElement: element);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }


}
