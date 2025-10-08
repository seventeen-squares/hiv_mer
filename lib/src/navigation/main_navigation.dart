import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../indicators/indicator_groups_screen.dart';
import '../data_elements/data_elements_screen.dart';
import '../settings/settings_view.dart';
import '../settings/settings_controller.dart';
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
  static const int settingsTab = 3;
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
    _switchTab(index);
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
          SettingsView(controller: widget.settingsController),
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
        selectedFontSize: 14,
        unselectedFontSize: 12,
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
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
