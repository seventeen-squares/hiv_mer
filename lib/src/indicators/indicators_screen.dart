import 'package:flutter/material.dart';
import '../models/mer_models.dart';
import '../services/mer_data_service.dart';
import 'indicator_detail_screen.dart';

class IndicatorsScreen extends StatefulWidget {
  static const routeName = '/indicators';

  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  final MERDataService _dataService = MERDataService();
  List<ProgramArea> _programAreas = [];
  Map<String, List<MERIndicator>> _indicatorsByProgram = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dataService.loadData();
    setState(() {
      _programAreas = _dataService.programAreas;
      for (final program in _programAreas) {
        _indicatorsByProgram[program.id] =
            _dataService.getIndicatorsByProgramArea(program.id);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade600,
                    Colors.purple.shade400,
                  ],
                ),
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
                  const Expanded(
                    child: Text(
                      'INDICATORS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _programAreas.length,
                      itemBuilder: (context, index) {
                        final program = _programAreas[index];
                        final indicators =
                            _indicatorsByProgram[program.id] ?? [];
                        return _buildProgramSection(program, indicators);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramSection(
      ProgramArea program, List<MERIndicator> indicators) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        children: [
          // Program Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getProgramColor(program.color),
                  _getProgramColor(program.color).withOpacity(0.8)
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getProgramIcon(program.icon),
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        program.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${indicators.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Indicators List
          if (indicators.isNotEmpty)
            Column(
              children: indicators.asMap().entries.map((entry) {
                final index = entry.key;
                final indicator = entry.value;
                return Column(
                  children: [
                    if (index > 0) const Divider(height: 1),
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getProgramColor(program.color),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          indicator.code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        indicator.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            indicator.definition,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                indicator.frequency,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          IndicatorDetailScreen.routeName,
                          arguments: indicator,
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No indicators available',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgramColor(String color) {
    switch (color.toLowerCase()) {
      case 'blue':
        return Colors.blue.shade600;
      case 'green':
        return Colors.green.shade600;
      case 'pink':
        return Colors.pink.shade600;
      case 'orange':
        return Colors.orange.shade600;
      case 'purple':
        return Colors.purple.shade600;
      case 'teal':
        return Colors.teal.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getProgramIcon(String icon) {
    switch (icon.toLowerCase()) {
      case 'medical_services':
        return Icons.medical_services;
      case 'medication':
        return Icons.medication;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'air':
        return Icons.air;
      case 'group':
        return Icons.group;
      case 'child_care':
        return Icons.child_care;
      default:
        return Icons.info;
    }
  }
}
