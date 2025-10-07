import 'package:flutter/material.dart';
import '../models/indicator_group.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../utils/constants.dart';
import 'indicator_detail_screen.dart';

/// Screen showing indicators for a specific group
class IndicatorListByGroupScreen extends StatefulWidget {
  final IndicatorGroup group;
  final String? subGroup;

  const IndicatorListByGroupScreen({
    super.key,
    required this.group,
    this.subGroup,
  });

  @override
  State<IndicatorListByGroupScreen> createState() =>
      _IndicatorListByGroupScreenState();
}

class _IndicatorListByGroupScreenState
    extends State<IndicatorListByGroupScreen> {
  final _indicatorService = SAIndicatorService.instance;
  List<SAIndicator> _indicators = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadIndicators();
  }

  Future<void> _loadIndicators() async {
    try {
      // Ensure indicators are loaded
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }

      // Get indicators for this group
      final indicators =
          _indicatorService.getIndicatorsByGroup(widget.group.id);

      setState(() {
        _indicators = indicators;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.subGroup ?? widget.group.name;

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
                          displayTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_indicators.length} indicators',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
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
                                  'Error loading indicators',
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
                      : _indicators.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inbox,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No indicators found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'This group does not contain any indicators yet.',
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
                              itemCount: _indicators.length,
                              itemBuilder: (context, index) {
                                final indicator = _indicators[index];
                                return _buildIndicatorCard(indicator);
                              },
                            ),
            ),
          ],
        ),
      ),
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
                  _buildStatusBadge(indicator.status),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      indicator.indicatorId,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (indicator.shortname.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  indicator.shortname,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
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
                      size: 14, color: Colors.grey.shade500),
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
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
