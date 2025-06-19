// lib/screens/main_navigation_screen.dart

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

  // Reordered screens: Profile, Discover, Explorer, Achievements
  final List<Widget> _screens = [
    const ProfileScreen(),      // Index 0 - Profile tab
    const DashboardScreen(),    // Index 1 - Discover tab  
    const ExplorerScreen(),     // Index 2 - Explorer tab (default)
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
                // New order: Profile, Discover, Explorer, Achievements
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
}