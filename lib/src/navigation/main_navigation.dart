import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home_screen.dart';
import '../indicators/indicator_groups_screen.dart';
import '../data_elements/data_elements_screen.dart';
import '../search/search_screen.dart';
import '../settings/settings_controller.dart';
import '../more/help_screen.dart';
import '../more/acronyms_screen.dart';
import '../more/background_info_screen.dart';
import '../more/about_screen.dart';
import '../utils/constants.dart';

/// Main navigation wrapper with bottom navigation bar
class MainNavigation extends StatefulWidget {
  static const routeName = '/main';

  final SettingsController settingsController;

  const MainNavigation({
    super.key,
    required this.settingsController,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();

  /// Helper method to switch tabs from child widgets
  static void switchToTab(BuildContext context, int tabIndex) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    state?._switchTab(tabIndex);
  }

  /// Tab indices for navigation
  static const int homeTab = 0;
  static const int indicatorsTab = 1;
  static const int dataElementsTab = 2;
  static const int searchTab = 3;
  static const int moreTab = 4;
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Use PageController to preserve state when switching tabs
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // If More tab is tapped, show menu instead of switching
    if (index == MainNavigation.moreTab) {
      _showMoreMenu(context);
    } else {
      _switchTab(index);
    }
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(HelpScreen.routeName);
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.short_text,
                title: 'Acronyms',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AcronymsScreen.routeName);
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                title: 'Background Info',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushNamed(BackgroundInfoScreen.routeName);
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.menu_book_outlined,
                title: 'Resources',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/resources');
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.feedback_outlined,
                title: 'Provide Feedback',
                onTap: () {
                  Navigator.pop(context);
                  // Open feedback form URL
                  // You'll need to add url_launcher package to pubspec.yaml
                  // and import 'package:url_launcher/url_launcher.dart';
                  final Uri feedbackUrl =
                      Uri.parse('https://forms.gle/JwC1mRZ5jLGCK9PE8');
                  launchUrl(feedbackUrl, mode: LaunchMode.externalApplication);
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                context,
                icon: Icons.share_outlined,
                title: 'Share application',
                onTap: () {
                  Navigator.pop(context);
                  // Open feedback form URL
                  // You'll need to add url_launcher package to pubspec.yaml
                  // and import 'package:url_launcher/url_launcher.dart';
                  final Uri shareUrl = Uri.parse(
                      'https://1drv.ms/f/c/4486554405894af5/EidajSEhjHtCq6EkGOHCkk8BX-wG7dYWmaK2WxrR7EdzAA?e=dehaKN');
                  launchUrl(shareUrl, mode: LaunchMode.externalApplication);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: saGovernmentGreen, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe to change page
        children: [
          const HomeScreen(),
          const IndicatorGroupsScreen(),
          const DataElementsScreen(),
          const SearchScreen(),
          // Placeholder for More tab (will show menu instead)
          const Center(child: Text('More')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: saGovernmentGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedFontSize: 10,
        unselectedFontSize: 9,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment),
            label: 'Indicators',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Data Elements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
