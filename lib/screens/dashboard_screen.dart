// lib/screens/dashboard_screen.dart - FIXED VERSION
// Fixes drawer connection and Explore Nearby navigation

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'discovery_map_screen.dart'; // FIXED: Import the correct screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  // Mock data for friends activity - replace with real data later
  final List<FriendActivity> _friendActivities = [
    FriendActivity(
      friendName: 'Alex Chen',
      activity: 'completed Central Park Loop',
      timeAgo: '2h ago',
      avatar: Icons.person,
      activityType: 'trip_completed',
    ),
    FriendActivity(
      friendName: 'Maya Rodriguez',
      activity: 'earned Explorer Badge',
      timeAgo: '4h ago',
      avatar: Icons.person_2,
      activityType: 'badge_earned',
    ),
    FriendActivity(
      friendName: 'Sam Johnson',
      activity: 'started a new challenge',
      timeAgo: '6h ago',
      avatar: Icons.person_3,
      activityType: 'challenge_started',
    ),
  ];

  // Mock data for progress - replace with real data later
  final ProgressData _progressData = ProgressData(
    tripsThisWeek: 5,
    totalDistance: 23.7,
    currentStreak: 3,
    badgesEarned: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      // FIXED: Proper AppBar setup for drawer
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // REMOVED: The leading override that was breaking the drawer
        // The hamburger menu should appear automatically when drawer is available
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            // Hero Banner
            _buildHeroBanner(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Discovery Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discover',
                  style: AppTextStyles.sectionTitle,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full discovery/community hub
                    Navigator.pushNamed(context, '/community-hub');
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: AppColors.amethyst600),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            // FIXED: Explore Nearby Card with correct navigation to DiscoveryMapScreen
            _buildExploreNearbyCard(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Friends Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Friends Activity',
                  style: AppTextStyles.sectionTitle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity-feed');
                  },
                  child: Text(
                    'Manage',
                    style: TextStyle(color: AppColors.amethyst600),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            // Friends Activity List
            ..._friendActivities.map((activity) => _buildActivityCard(activity)),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Your Progress Section
            Text(
              'Your Progress',
              style: AppTextStyles.sectionTitle,
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            // Progress Cards Grid
            _buildProgressGrid(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // UPDATED: Quick Actions with Browse Challenges
            Text(
              'Quick Actions',
              style: AppTextStyles.sectionTitle,
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            _buildQuickActionsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.amethyst600,
            AppColors.exploreBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.explore,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          const Text(
            'Ready for your next adventure?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          const Text(
            'Explore nearby locations, track your journey, and compete with friends',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          const Text(
            'Discover new places, track your adventures, and collect badges as you explore the world around you.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // FIXED: Explore Nearby Card with correct navigation to DiscoveryMapScreen
  Widget _buildExploreNearbyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Map Preview Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Stack(
              children: [
                // Map-like background
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade100,
                        Colors.blue.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Location pin
                const Positioned(
                  top: 20,
                  right: 25,
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: AppDimensions.spaceL),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Nearby',
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Discover new locations, find friends, and join challenges near you',
                  style: AppTextStyles.cardSubtitle,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                // FIXED: Open Map button navigates to DiscoveryMapScreen (like AllTrails)
                InkWell(
                  onTap: () {
                    // Navigate to DiscoveryMapScreen - your AllTrails-like page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoveryMapScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceM,
                      vertical: AppDimensions.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst600.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map,
                          color: AppColors.amethyst600,
                          size: 16,
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Text(
                          'Open Map',
                          style: TextStyle(
                            color: AppColors.amethyst600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow indicator
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecond,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(FriendActivity activity) {
    IconData activityIcon;
    Color activityColor;
    
    switch (activity.activityType) {
      case 'trip_completed':
        activityIcon = Icons.check_circle;
        activityColor = AppColors.success;
        break;
      case 'badge_earned':
        activityIcon = Icons.emoji_events;
        activityColor = AppColors.warning;
        break;
      case 'challenge_started':
        activityIcon = Icons.flag;
        activityColor = AppColors.amethyst600;
        break;
      default:
        activityIcon = Icons.info;
        activityColor = AppColors.textSecond;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Friend Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.amethyst600.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.avatar,
              color: AppColors.amethyst600,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spaceM),
          
          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.cardSubtitle,
                    children: [
                      TextSpan(
                        text: activity.friendName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${activity.activity}'),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.timeAgo,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          
          // Activity type indicator
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: activityColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildProgressCard(
            'Trips\nthis week',
            _progressData.tripsThisWeek.toString(),
            Icons.flag,
            AppColors.info,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceM),
        Expanded(
          child: _buildProgressCard(
            'Distance\ntotal',
            '${_progressData.totalDistance}km',
            Icons.straighten,
            AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // UPDATED: Quick Actions with Browse Challenges added
  Widget _buildQuickActionsGrid() {
    return Column(
      children: [
        // Row 1: Create New Trip & Browse Challenges
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Create New Trip',
                'Plan your next adventure',
                Icons.add_location_alt,
                AppColors.amethyst600,
                () {
                  Navigator.pushNamed(context, '/trip-create');
                },
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: _buildQuickActionCard(
                'Browse Challenges',
                'Join competitions',
                Icons.emoji_events,
                AppColors.warning,
                () {
                  // Navigate to challenges
                  Navigator.pushNamed(context, '/challenges');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        // Row 2: View Leaderboard & Find Friends
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'View Leaderboard',
                'See how you rank',
                Icons.leaderboard,
                AppColors.info,
                () {
                  Navigator.pushNamed(context, '/leaderboard');
                },
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: _buildQuickActionCard(
                'Find Friends',
                'Connect with others',
                Icons.people,
                AppColors.success,
                () {
                  Navigator.pushNamed(context, '/friend-search');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              subtitle,
              style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Icon(
              Icons.arrow_forward,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class FriendActivity {
  final String friendName;
  final String activity;
  final String timeAgo;
  final IconData avatar;
  final String activityType;

  FriendActivity({
    required this.friendName,
    required this.activity,
    required this.timeAgo,
    required this.avatar,
    required this.activityType,
  });
}

class ProgressData {
  final int tripsThisWeek;
  final double totalDistance;
  final int currentStreak;
  final int badgesEarned;

  ProgressData({
    required this.tripsThisWeek,
    required this.totalDistance,
    required this.currentStreak,
    required this.badgesEarned,
  });
}