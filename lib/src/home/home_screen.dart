import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

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
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.health_and_safety_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PEPFAR MER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Quick Reference Guide',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to settings
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildMenuTile(
                      context,
                      title: 'KEY FACTS',
                      subtitle: 'MER Guidelines Overview',
                      icon: Icons.fact_check_outlined,
                      gradient: [Colors.blue.shade600, Colors.blue.shade400],
                      onTap: () {
                        Navigator.of(context).pushNamed('/key-facts');
                      },
                    ),
                    _buildMenuTile(
                      context,
                      title: 'TARGETS & PROGRESS',
                      subtitle: 'PEPFAR Goals & Progress',
                      icon: Icons.trending_up,
                      gradient: [Colors.green.shade600, Colors.green.shade400],
                      onTap: () {
                        // TODO: Navigate to Targets & Progress
                      },
                    ),
                    _buildMenuTile(
                      context,
                      title: 'INDICATORS',
                      subtitle: 'Browse by Program Area',
                      icon: Icons.analytics_outlined,
                      gradient: [
                        Colors.purple.shade600,
                        Colors.purple.shade400
                      ],
                      onTap: () {
                        Navigator.of(context).pushNamed('/indicators');
                      },
                    ),
                    _buildMenuTile(
                      context,
                      title: 'REGIONS',
                      subtitle: 'Country Profiles',
                      icon: Icons.public,
                      gradient: [
                        Colors.orange.shade600,
                        Colors.orange.shade400
                      ],
                      onTap: () {
                        // TODO: Navigate to Regions
                      },
                    ),
                    _buildMenuTile(
                      context,
                      title: 'COMPARE',
                      subtitle: 'Compare Indicators',
                      icon: Icons.compare_arrows,
                      gradient: [Colors.teal.shade600, Colors.teal.shade400],
                      onTap: () {
                        // TODO: Navigate to Compare
                      },
                    ),
                    _buildMenuTile(
                      context,
                      title: 'QUICK SEARCH',
                      subtitle: 'Find Indicators Fast',
                      icon: Icons.search,
                      gradient: [
                        Colors.indigo.shade600,
                        Colors.indigo.shade400
                      ],
                      onTap: () {
                        Navigator.of(context).pushNamed('/search');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
