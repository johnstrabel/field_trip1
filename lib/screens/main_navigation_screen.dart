// lib/screens/main_navigation_screen.dart - FULL VERSION
// Replace your current main_navigation_screen.dart with this

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'explorer_screen.dart';
import 'profile_screen.dart';
import 'badge_wall_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int? initialIndex;
  
  const MainNavigationScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Use provided initial index or default to Discover (index 1)
    _selectedIndex = widget.initialIndex ?? 1;
  }

  // Keep your exact existing screen order
  final List<Widget> _screens = [
    const ProfileScreen(),      // Index 0 - Profile tab
    const DashboardScreen(),    // Index 1 - Discover tab  
    const ExplorerScreen(),     // Index 2 - Explorer tab
    const BadgeWallScreen(),    // Index 3 - Achievements tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The drawer with all your new screens
      drawer: _buildNavigationDrawer(),
      
      // Keep everything else EXACTLY the same as your current version
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Discover',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.compass_calibration_outlined,
                  activeIcon: Icons.compass_calibration,
                  label: 'Explorer',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.emoji_events_outlined,
                  activeIcon: Icons.emoji_events,
                  label: 'Achievements',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Keep your existing _buildNavItem method exactly as it is
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amethyst100 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.amethyst600 : AppColors.textSecond,
              size: AppDimensions.iconSizeM,
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.amethyst600 : AppColors.textSecond,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COMPLETE navigation drawer with all your screens organized
  Widget _buildNavigationDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.exploreBlue, AppColors.crawlCrimson],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.explore, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Field Trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Explore • Crawl • Sport',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Social Section
          _buildDrawerSection('Social', [
            _buildDrawerItem(Icons.people, 'Friends', '/friends'),
            _buildDrawerItem(Icons.dynamic_feed, 'Activity Feed', '/activity-feed'),
            _buildDrawerItem(Icons.person_search, 'Find Friends', '/friend-search'),
          ]),
          
          // Competition Section
          _buildDrawerSection('Competition', [
            _buildDrawerItem(Icons.leaderboard, 'Leaderboard', '/leaderboard'),
            _buildDrawerItem(Icons.emoji_events, 'Challenges', '/challenges'),
            _buildDrawerItem(Icons.add_circle_outline, 'Create Challenge', '/challenge-create'),
          ]),
          
          // Discovery Section
          _buildDrawerSection('Discovery', [
            _buildDrawerItem(Icons.public, 'Community Hub', '/community-hub'),
            _buildDrawerItem(Icons.route, 'Trip Templates', '/trip-templates'),
            _buildDrawerItem(Icons.analytics, 'Detailed Stats', '/stats'),
          ]),
          
          const Divider(),
          
          // Settings & Utilities
          _buildDrawerItem(Icons.notifications, 'Notifications', '/notifications'),
          _buildDrawerItem(Icons.settings, 'Settings', '/settings'),
          _buildDrawerItem(Icons.help_outline, 'Help & Feedback', '/help'),
          
          const Divider(),
          
          // Development & Testing (you can remove this section later)
          _buildDrawerSection('Development', [
            _buildDrawerItem(Icons.login, 'Welcome Screen', '/welcome'),
            _buildDrawerItem(Icons.account_circle, 'Login', '/login'),
            _buildDrawerItem(Icons.app_registration, 'Register', '/register'),
          ]),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: AppTextStyles.cardSubtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecond,
            ),
          ),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecond),
      title: Text(title, style: AppTextStyles.cardTitle),
      onTap: () {
        Navigator.pop(context); // Close drawer
        _safeNavigate(route);
      },
    );
  }

  // Safe navigation method - handles errors gracefully
  void _safeNavigate(String route) {
    try {
      Navigator.pushNamed(context, route);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation to "$route" failed: ${e.toString()}'),
          backgroundColor: AppColors.warning,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}