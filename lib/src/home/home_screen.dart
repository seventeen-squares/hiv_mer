import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sa_indicator_service.dart';
import 'widgets/nids_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/navigation_card.dart';
import 'widgets/summary_card.dart';
import 'widgets/recent_updates_section.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _indicatorService = SAIndicatorService.instance;
  bool _isLoading = true;
  Map<String, int>? _statistics;
  List<Map<String, String>> _recentUpdates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load indicator data if not already loaded
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }

      // Get statistics
      final stats = _indicatorService.getStatistics();

      // Load recent updates
      final updatesJson =
          await rootBundle.loadString('assets/data/recent_updates.json');
      final updatesList = jsonDecode(updatesJson) as List<dynamic>;
      final updates = updatesList
          .map((json) => Map<String, String>.from(json as Map))
          .toList();

      setState(() {
        _statistics = stats;
        _recentUpdates = updates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NIDS Header with SA branding
              const NIDSHeader(),

              const SizedBox(height: 24),

              // Search Bar
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: HomeSearchBar(),
              ),

              const SizedBox(height: 24),

              // Navigation Cards Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    NavigationCard(
                      icon: Icons.help_outline,
                      title: 'Help/Support',
                      onTap: () {
                        // TODO: Navigate to Help
                      },
                    ),
                    NavigationCard(
                      icon: Icons.library_books,
                      title: 'Resource Center',
                      onTap: () {
                        // TODO: Navigate to Resources
                      },
                    ),
                    NavigationCard(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        // TODO: Navigate to Notifications
                      },
                    ),
                    NavigationCard(
                      icon: Icons.favorite_outline,
                      title: 'Favorites',
                      onTap: () {
                        // TODO: Navigate to Favorites
                      },
                    ),
                    NavigationCard(
                      icon: Icons.feedback_outlined,
                      title: 'Feedback',
                      onTap: () {
                        // TODO: Navigate to Feedback
                      },
                    ),
                    NavigationCard(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        // TODO: Navigate to About
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Total Indicators',
                        count: _statistics?['indicators'] ?? 0,
                        backgroundColor: const Color(0xFF8B7355), // Warm brown
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Total Data Elements',
                        count: _statistics?['dataElements'] ?? 0,
                        backgroundColor: const Color(0xFFF97316), // Orange
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Updates Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RecentUpdatesSection(
                  updates: _recentUpdates,
                ),
              ),

              const SizedBox(height: 100), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}
