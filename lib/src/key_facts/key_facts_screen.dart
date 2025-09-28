import 'package:flutter/material.dart';
import '../models/mer_models.dart';
import '../services/mer_data_service.dart';
import '../utils/app_colors.dart';

class KeyFactsScreen extends StatefulWidget {
  static const routeName = '/key-facts';

  const KeyFactsScreen({super.key});

  @override
  State<KeyFactsScreen> createState() => _KeyFactsScreenState();
}

class _KeyFactsScreenState extends State<KeyFactsScreen> {
  final MERDataService _dataService = MERDataService();
  List<KeyFact> _keyFacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKeyFacts();
  }

  Future<void> _loadKeyFacts() async {
    await _dataService.loadData();
    setState(() {
      _keyFacts = _dataService.keyFacts;
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
                    Colors.blue.shade600,
                    Colors.blue.shade400,
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
                      'KEY FACTS',
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
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Introduction Card
                          Card(
                            elevation: 4,
                            color: AppColors.getCardColor(context),
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.getPrimaryColor(context),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'PEPFAR MER OVERVIEW',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getPrimaryTextColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'The President\'s Emergency Plan for AIDS Relief (PEPFAR) Monitoring, Evaluation, and Reporting (MER) indicators provide essential data on HIV prevention, care, and treatment services globally.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.getSecondaryTextColor(context),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Key Statistics Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: _keyFacts.length,
                            itemBuilder: (context, index) {
                              final fact = _keyFacts[index];
                              return _buildKeyFactCard(fact, index);
                            },
                          ),

                          const SizedBox(height: 24),

                          // Additional Information
                          Card(
                            elevation: 4,
                            color: AppColors.getCardColor(context),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timeline,
                                        color: AppColors.getProgramColor('tx', isDark: Theme.of(context).brightness == Brightness.dark),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'PEPFAR GOALS',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.getPrimaryTextColor(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildGoalItem('Achieve epidemic control',
                                      'Control HIV transmission in PEPFAR-supported countries'),
                                  _buildGoalItem('95-95-95 Targets',
                                      '95% diagnosed, 95% on treatment, 95% virally suppressed'),
                                  _buildGoalItem('Zero Discrimination',
                                      'Eliminate stigma and discrimination'),
                                ],
                              ),
                            ),
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

  Widget _buildKeyFactCard(KeyFact fact, int index) {
    final colors = [
      [Colors.blue.shade600, Colors.blue.shade400],
      [Colors.green.shade600, Colors.green.shade400],
      [Colors.purple.shade600, Colors.purple.shade400],
      [Colors.orange.shade600, Colors.orange.shade400],
    ];

    final cardColors = colors[index % colors.length];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardColors,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fact.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fact.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            if (fact.subtitle != null)
              Text(
                fact.subtitle!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getTrendIcon(fact.trend),
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _getTrendText(fact.trend),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.getProgramColor('tx', isDark: Theme.of(context).brightness == Brightness.dark),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      case 'stable':
      default:
        return Icons.trending_flat;
    }
  }

  String _getTrendText(String trend) {
    switch (trend.toLowerCase()) {
      case 'up':
        return 'Increasing';
      case 'down':
        return 'Decreasing';
      case 'stable':
      default:
        return 'Stable';
    }
  }
}
