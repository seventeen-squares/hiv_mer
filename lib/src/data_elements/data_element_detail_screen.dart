import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/data_element.dart';
import '../services/favorites_service.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double scrollSpeed;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.scrollSpeed = 50.0,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _textWidth = 0;
  double _containerWidth = 0;
  bool _needsScrolling = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8), // Adjust for desired speed
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureTextAndStartAnimation();
    });
  }

  void _measureTextAndStartAnimation() {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    setState(() {
      _textWidth = textPainter.size.width;
      _needsScrolling = _textWidth > _containerWidth;
    });

    if (_needsScrolling && _containerWidth > 0) {
      // Calculate duration based on text width and desired speed
      final duration = Duration(
        milliseconds:
            ((_textWidth + _containerWidth) / widget.scrollSpeed * 1000)
                .round(),
      );

      _animationController.duration = duration;

      // Create animation that goes from 0 to full text width + container width
      _animation = Tween<double>(
        begin: 0.0,
        end: _textWidth + 100, // Add some padding for smooth transition
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ));

      // Start animation after a brief delay, then repeat
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _animationController.repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;

        if (!_needsScrolling || _containerWidth == 0) {
          // If text fits, just show it normally
          return Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return ClipRect(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-_animation.value, 0),
                child: Row(
                  children: [
                    // First instance of text
                    Text(
                      widget.text,
                      style: widget.style,
                      maxLines: 1,
                    ),
                    // Add spacing
                    SizedBox(width: _containerWidth * 0.5),
                    // Second instance for seamless loop
                    Text(
                      widget.text,
                      style: widget.style,
                      maxLines: 1,
                    ),
                    // Extra spacing to ensure smooth transition
                    SizedBox(width: _containerWidth * 0.5),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

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
          content: Text(
              newStatus ? 'Added to Favourites' : 'Removed from Favourites'),
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
    final categoryColor = _getCategoryColor(element.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar - compact with scrollable title
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              color: categoryColor,
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
                  child: MarqueeText(
                    text: element.shortname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    scrollSpeed: 30.0, // Adjust speed as needed
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
                        ? 'Remove from Favourites'
                        : 'Add to Favourites',
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
                      fontSize: 16,
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
                            fontSize: 14,
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
                fontSize: 13,
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
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }
}
