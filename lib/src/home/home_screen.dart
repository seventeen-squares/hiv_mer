import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/sa_indicator_service.dart';
import '../navigation/main_navigation.dart';
import '../notifications/notifications_screen.dart';
import 'widgets/nids_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/navigation_card.dart';
import 'widgets/summary_card.dart';
import '../utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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

      setState(() {
        _statistics = stats;
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: saGovernmentGreen,
        body: Column(
          children: [
            // Status bar spacer with green background
            SizedBox(height: MediaQuery.of(context).padding.top),

            // Scrollable content with header and search bar
            Expanded(
              child: Container(
                color: saGovernmentGreen,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // White header card with rounded bottom corners (now scrollable)
                      const NIDSHeader(),

                      // Light background for rest of content
                      Container(
                        color: const Color(0xFFF8FAFC),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // Search Bar
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: HomeSearchBar(),
                            ),

                            // Navigation Cards Grid
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                                children: [
                                  NavigationCard(
                                    icon: Icons.folder_outlined,
                                    title: 'Indicators',
                                    onTap: () {
                                      // Switch to indicators tab in bottom nav
                                      MainNavigation.switchToTab(context,
                                          MainNavigation.indicatorsTab);
                                    },
                                  ),
                                  NavigationCard(
                                    icon: Icons.library_books,
                                    title: 'Data Elements',
                                    onTap: () {
                                      // TODO: Navigate to Help

                                      MainNavigation.switchToTab(context,
                                          MainNavigation.dataElementsTab);
                                    },
                                  ),
                                  NavigationCard(
                                    icon: Icons.menu_book_outlined,
                                    title: 'Resources',
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/resources');
                                    },
                                  ),
                                  NavigationCard(
                                    icon: Icons.notifications_outlined,
                                    title: 'Notifications',
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          NotificationsScreen.routeName);
                                    },
                                  ),
                                  NavigationCard(
                                    icon: Icons.favorite_outline,
                                    title: 'Favourites',
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/Favourites');
                                    },
                                  ),
                                  NavigationCard(
                                    icon: Icons.settings_outlined,
                                    title: 'Settings',
                                    onTap: () {
                                      // Navigate to settings page
                                      Navigator.of(context)
                                          .pushNamed('/settings');
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Summary Cards
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SummaryCard(
                                      title: 'Total Indicators',
                                      count: _statistics?['indicators'] ?? 0,
                                      backgroundColor:
                                          const Color(0xFF8B7355), // Warm brown
                                      onTap: () {
                                        // Switch to indicators tab in bottom nav
                                        MainNavigation.switchToTab(context,
                                            MainNavigation.indicatorsTab);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: SummaryCard(
                                      title: 'Total Data Elements',
                                      count: _statistics?['dataElements'] ?? 0,
                                      backgroundColor:
                                          const Color(0xFFF97316), // Orange
                                      onTap: () {
                                        // Switch to data elements tab in bottom nav
                                        MainNavigation.switchToTab(context,
                                            MainNavigation.dataElementsTab);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Development Notice
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 24, bottom: 16),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                border: Border.all(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue.shade600,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please note that this application is in active development.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Open feedback form URL
                                      // You'll need to add url_launcher package to pubspec.yaml
                                      // and import 'package:url_launcher/url_launcher.dart';
                                      final Uri feedbackUrl = Uri.parse(
                                          'https://forms.gle/JwC1mRZ5jLGCK9PE8');
                                      launchUrl(feedbackUrl,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade600,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Click here to provide feedback',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height:
                                    100), // Extra space for bottom navigation
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
