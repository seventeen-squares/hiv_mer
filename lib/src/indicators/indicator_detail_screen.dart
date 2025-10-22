import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/sa_indicator.dart';
import '../services/favorites_service.dart';
import '../utils/app_colors.dart';

class IndicatorDetailScreen extends StatefulWidget {
  static const routeName = '/indicator-detail';

  const IndicatorDetailScreen({super.key});

  @override
  State<IndicatorDetailScreen> createState() => _IndicatorDetailScreenState();
}

class _IndicatorDetailScreenState extends State<IndicatorDetailScreen> {
  final _favoritesService = FavoritesService.instance;
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  Color _getGroupColor(String groupId) {
    final groupLower = groupId.toLowerCase();

    // Adolescent Health - Blue
    if (groupLower.contains('adolescent')) {
      return const Color(0xFF5DADE2);
    }
    // ART Categories - Browns/Pinks
    else if (groupLower.contains('art baseline')) {
      return const Color(0xFFA1887F);
    } else if (groupLower.contains('art monthly')) {
      return const Color(0xFFE91E63);
    } else if (groupLower.contains('art outcome')) {
      return const Color(0xFF827717);
    } else if (groupLower.contains('art') ||
        groupLower.contains('antiretroviral')) {
      return const Color(0xFFA1887F);
    }
    // Central Chronic Medicines - Dark Green
    else if (groupLower.contains('chronic medicine') ||
        groupLower.contains('central chronic')) {
      return const Color(0xFF00897B);
    }
    // Child and Nutrition - Light Blue
    else if (groupLower.contains('child') || groupLower.contains('nutrition')) {
      return const Color(0xFF81D4FA);
    }
    // Chronic - Yellow
    else if (groupLower.contains('chronic')) {
      return const Color(0xFFFFEB3B);
    }
    // Communicable Diseases - Orange
    else if (groupLower.contains('communicable')) {
      return const Color(0xFFFF7043);
    }
    // Emergency Medical Services - Dark Gray
    else if (groupLower.contains('emergency') || groupLower.contains('ems')) {
      return const Color(0xFF424242);
    }
    // Environmental Health - Yellow/Green
    else if (groupLower.contains('environmental')) {
      return const Color(0xFFCDDC39);
    }
    // Expanded Programme on Immunisation - Red
    else if (groupLower.contains('epi') ||
        groupLower.contains('immunis') ||
        groupLower.contains('immunization')) {
      return const Color(0xFFF44336);
    }
    // Eye Care - Light Pink
    else if (groupLower.contains('eye')) {
      return const Color(0xFFF8BBD0);
    }
    // HIV - Purple
    else if (groupLower.contains('hiv')) {
      return const Color(0xFF7986CB);
    }
    // Malaria - Green
    else if (groupLower.contains('malaria')) {
      return const Color(0xFF66BB6A);
    }
    // Management Inpatients - Magenta/Pink
    else if (groupLower.contains('inpatient') ||
        groupLower.contains('management inpatient')) {
      return const Color(0xFFE91E63);
    }
    // Management PHC - Cyan
    else if (groupLower.contains('phc') ||
        groupLower.contains('primary health')) {
      return const Color(0xFF00BCD4);
    }
    // Maternal and Neonatal - Orange
    else if (groupLower.contains('maternal') ||
        groupLower.contains('neonatal')) {
      return const Color(0xFFFF9800);
    }
    // Mental Health - Light Green
    else if (groupLower.contains('mental')) {
      return const Color(0xFFAED581);
    }
    // Oral Health - Light Olive
    else if (groupLower.contains('oral') || groupLower.contains('dental')) {
      return const Color(0xFFD4E157);
    }
    // PHC Ward Based Outreach Teams - Gray
    else if (groupLower.contains('wbot') ||
        groupLower.contains('ward based') ||
        groupLower.contains('outreach')) {
      return const Color(0xFF9E9E9E);
    }
    // Quality - Purple
    else if (groupLower.contains('quality')) {
      return const Color(0xFF7E57C2);
    }
    // Rehabilitation - Light Purple
    else if (groupLower.contains('rehab')) {
      return const Color(0xFFB39DDB);
    }
    // School Health - Dark Red
    else if (groupLower.contains('school')) {
      return const Color(0xFFC62828);
    }
    // Sexually Transmitted Infections - Brown/Tan
    else if (groupLower.contains('sti') ||
        groupLower.contains('sexually transmitted')) {
      return const Color(0xFFBCAAA4);
    }
    // TB Monthly - Teal
    else if (groupLower.contains('tb') && groupLower.contains('monthly')) {
      return const Color(0xFF00BCD4);
    }
    // TB Quarterly - Brown
    else if (groupLower.contains('tb') && groupLower.contains('quarterly')) {
      return const Color(0xFF8D6E63);
    }
    // TB General - Teal
    else if (groupLower.contains('tb') || groupLower.contains('tuberculosis')) {
      return const Color(0xFF00BCD4);
    }
    // Women's Health - Pink
    else if (groupLower.contains('women')) {
      return const Color(0xFFE57373);
    }
    // Default
    return const Color(0xFF007A4D); // saGovernmentGreen
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final indicator = ModalRoute.of(context)!.settings.arguments as SAIndicator;
    final isFav = await _favoritesService.isFavorite(indicator.indicatorId);
    setState(() {
      _isFavorite = isFav;
      _isLoadingFavorite = false;
    });
  }

  Future<void> _toggleFavorite(SAIndicator indicator) async {
    final newStatus =
        await _favoritesService.toggleFavorite(indicator.indicatorId);
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

  String _formatIndicatorForShare(SAIndicator indicator) {
    final buffer = StringBuffer();

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('NIDS INDICATOR INFORMATION');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    buffer.writeln('📊 ${indicator.name}');
    if (indicator.shortname.isNotEmpty &&
        indicator.shortname != indicator.name) {
      buffer.writeln('Short name: ${indicator.shortname}');
    }
    buffer.writeln();

    buffer.writeln('🆔 IDENTIFIERS');
    buffer.writeln('Indicator ID: ${indicator.indicatorId}');
    if (indicator.renoId.isNotEmpty) {
      buffer.writeln('Reno/ID: ${indicator.renoId}');
    }
    buffer.writeln('Group ID: ${indicator.groupId}');
    buffer.writeln();

    buffer.writeln('📝 DEFINITION');
    buffer.writeln(indicator.definition);
    buffer.writeln();

    buffer.writeln('🔢 CALCULATION');
    buffer.writeln('Numerator: ${indicator.numerator}');
    if (indicator.numeratorFormula != null) {
      buffer.writeln('Formula: ${indicator.numeratorFormula}');
    }
    buffer.writeln();
    buffer.writeln('Denominator: ${indicator.denominator}');
    if (indicator.denominatorFormula != null) {
      buffer.writeln('Formula: ${indicator.denominatorFormula}');
    }
    buffer.writeln();

    if (indicator.useContext.isNotEmpty) {
      buffer.writeln('💡 USE AND CONTEXT');
      buffer.writeln(indicator.useContext);
      buffer.writeln();
    }

    buffer.writeln('ℹ️ METADATA');
    buffer.writeln('Factor/Type: ${indicator.factorType}');
    buffer.writeln('Frequency: ${indicator.frequency}');
    buffer.writeln('Status: ${indicator.status.toString().split('.').last}');
    buffer.writeln();

    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Source: National Indicator Data Set (NIDS)');
    buffer.writeln('Department of Health, South Africa');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return buffer.toString();
  }

  void _shareIndicator(BuildContext context, SAIndicator indicator) {
    final text = _formatIndicatorForShare(indicator);
    Share.share(
      text,
      subject: 'NIDS Indicator: ${indicator.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final indicator = ModalRoute.of(context)!.settings.arguments as SAIndicator;
    final groupColor = _getGroupColor(indicator.groupId);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar with SA branding - compact with scrollable title
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              color: groupColor,
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
                      indicator.shortname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _shareIndicator(context, indicator),
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Share indicator',
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
                    onPressed: () => _toggleFavorite(indicator),
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
                  // Indicator Name
                  Text(
                    indicator.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

                  // IDs Card
                  _buildInfoCard(
                    context,
                    children: [
                      _buildInfoRow('Reno/ID', indicator.renoId),
                      const SizedBox(height: 8),
                      _buildInfoRow('Group ID', indicator.groupId),
                      const SizedBox(height: 8),
                      _buildInfoRow('Indicator ID', indicator.indicatorId),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          'Sort Order', indicator.sortOrder.toString()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Definition Section
                  _buildSection(
                    context,
                    title: 'DEFINITION',
                    content: indicator.definition,
                    icon: Icons.info_outline,
                    iconColor: groupColor,
                  ),

                  const SizedBox(height: 16),

                  // Numerator Card
                  _buildDetailCard(
                    context,
                    title: 'NUMERATOR',
                    content: indicator.numerator,
                    formula: indicator.numeratorFormula,
                    color: const Color(0xFF10B981),
                    icon: Icons.add_circle_outline,
                  ),

                  const SizedBox(height: 16),

                  // Denominator Card (if present)
                  if (indicator.denominator != null)
                    _buildDetailCard(
                      context,
                      title: 'DENOMINATOR',
                      content: indicator.denominator!,
                      formula: indicator.denominatorFormula,
                      color: const Color(0xFF3B82F6),
                      icon: Icons.calculate_outlined,
                    )
                  else
                    _buildSection(
                      context,
                      title: 'DENOMINATOR',
                      content: 'Not applicable',
                      icon: Icons.remove_circle_outline,
                      iconColor: groupColor,
                    ),

                  const SizedBox(height: 16),

                  // Use and Context Section
                  _buildSection(
                    context,
                    title: 'USE AND CONTEXT',
                    content: indicator.useContext,
                    icon: Icons.lightbulb_outline,
                    iconColor: groupColor,
                  ),

                  const SizedBox(height: 16),

                  // Metadata Card
                  _buildInfoCard(
                    context,
                    children: [
                      _buildInfoRow('Factor/Type', indicator.factorType),
                      const SizedBox(height: 8),
                      _buildInfoRow('Frequency', indicator.frequency),
                      const SizedBox(height: 8),
                      _buildInfoRow('Status', _getStatusText(indicator.status)),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
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
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getPrimaryTextColor(context),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required String content,
    String? formula,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getPrimaryTextColor(context),
              height: 1.5,
            ),
          ),
          if (formula != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.functions, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formula,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required List<Widget> children}) {
    return Container(
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
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(IndicatorStatus status) {
    switch (status) {
      case IndicatorStatus.newIndicator:
        return 'NEW';
      case IndicatorStatus.amended:
        return 'AMENDED';
      case IndicatorStatus.retainedWithNew:
        return 'RETAINED WITH NEW';
      case IndicatorStatus.retainedWithoutNew:
        return 'RETAINED WITHOUT NEW';
    }
  }
}
