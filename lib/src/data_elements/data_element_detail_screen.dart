import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/data_element.dart';
import '../services/favorites_service.dart';
import '../utils/constants.dart';

class DataElementDetailScreen extends StatefulWidget {
  static const routeName = '/data-element-detail';

  const DataElementDetailScreen({super.key});

  @override
  State<DataElementDetailScreen> createState() =>
      _DataElementDetailScreenState();
}

class _DataElementDetailScreenState extends State<DataElementDetailScreen> {
  final _favoritesService = FavoritesService.instance;
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final element = ModalRoute.of(context)!.settings.arguments as DataElement;
    // Use same favorites service with 'de-' prefix to distinguish data elements
    final isFav = await _favoritesService.isFavorite('de-${element.id}');
    setState(() {
      _isFavorite = isFav;
      _isLoadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite(DataElement element) async {
    // Use same favorites service with 'de-' prefix to distinguish data elements
    final newStatus =
        await _favoritesService.toggleFavorite('de-${element.id}');
    setState(() {
      _isFavorite = newStatus;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(newStatus ? 'Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareDataElement(BuildContext context, DataElement element) {
    final buffer = StringBuffer();

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('NIDS DATA ELEMENT INFORMATION');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    buffer.writeln('📊 ${element.name}');
    if (element.shortname.isNotEmpty && element.shortname != element.name) {
      buffer.writeln('Short name: ${element.shortname}');
    }
    buffer.writeln();

    buffer.writeln('🆔 IDENTIFIERS');
    buffer.writeln('Element ID: ${element.id}');
    buffer.writeln('Category: ${element.category}');
    buffer.writeln();

    if (element.definition.isNotEmpty) {
      buffer.writeln('📝 DEFINITION');
      buffer.writeln(element.definition);
      buffer.writeln();
    }

    buffer.writeln('ℹ️ METADATA');
    buffer.writeln('Data Type: ${element.dataType}');
    buffer.writeln('Aggregation: ${element.aggregationType}');
    buffer.writeln('Status: ${element.status.toString().split('.').last}');
    buffer.writeln();

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Source: National Indicator Data Set (NIDS)');
    buffer.writeln('Department of Health, South Africa');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    Share.share(
      buffer.toString(),
      subject: 'NIDS Data Element: ${element.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final element = ModalRoute.of(context)!.settings.arguments as DataElement;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar - compact with scrollable title
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: saGovernmentGreen,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        element.shortname,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _shareDataElement(context, element),
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Share data element',
                  ),
                  const SizedBox(width: 12),
                  if (_isLoadingFavorite)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () => _toggleFavorite(element),
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: _isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Element Name
                    Text(
                      element.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // IDs Card
                    _buildInfoCard(
                      context,
                      children: [
                        _buildInfoRow('Element ID', element.id),
                        const SizedBox(height: 8),
                        _buildInfoRow('Category', element.category),
                        const SizedBox(height: 8),
                        _buildInfoRow('Data Type', element.dataType),
                        const SizedBox(height: 8),
                        _buildInfoRow('Aggregation', element.aggregationType),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Definition Card
                    if (element.definition.isNotEmpty)
                      _buildInfoCard(
                        context,
                        title: 'Definition',
                        children: [
                          Text(
                            element.definition,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    String? title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}
