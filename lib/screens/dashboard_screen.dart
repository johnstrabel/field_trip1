// lib/screens/dashboard_screen.dart - Complete version with navigation wiring

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';
import 'map_trip_creation_screen.dart';

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
      appBar: AppBar(
        title: const Text('Discover'), // Changed from 'Dashboard' to 'Discover'
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          children: [
            // Hero Banner (updated to remove action buttons)
            _buildHeroBanner(),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Discovery Section Header - UPDATED WITH NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discover',
                  style: AppTextStyles.sectionTitle,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/map-discover');
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.amethyst600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceM),
            
            // Discovery Card (keeping your existing implementation)
            _buildDiscoveryCard(),
           
            const SizedBox(height: AppDimensions.spaceL),
            
            // Friends Activity Section - UPDATED WITH NAVIGATION
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Friends Activity',
                      style: AppTextStyles.sectionTitle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/friends');
                      },
                      child: Text(
                        'Manage',
                        style: TextStyle(
                          color: AppColors.amethyst600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceM),
                _buildFriendsActivity(),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Progress Snapshot Section (updated with header)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                _buildProgressSnapshot(),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spaceL),
            
            // Quick Actions Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                _buildQuickActions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.amethyst600,
            AppColors.amethyst600,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Icon(
            Icons.explore,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            'Ready for your next adventure?',
            style: AppTextStyles.heroTitle.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            'Explore nearby locations, track your journey, and compete with friends',
            style: AppTextStyles.heroSubtitle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          // Additional motivational text (replacing the buttons)
          Text(
            'Discover new places, track your adventures, and collect badges as you explore the world around you.',
            style: AppTextStyles.heroSubtitle.copyWith(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/map-discover');
      },
      child: Container(
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
            // Map Preview (placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Stack(
                children: [
                  // Map-like pattern
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
                  // Path line
                  CustomPaint(
                    size: const Size(80, 80),
                    painter: _MapPathPainter(),
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
            
            // Trip info
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceM,
                      vertical: AppDimensions.spaceS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst100,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.explore,
                          color: AppColors.amethyst600,
                          size: 16,
                        ),
                        const SizedBox(width: AppDimensions.spaceXS),
                        Text(
                          'Open Map',
                          style: TextStyle(
                            color: AppColors.amethyst600,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecond,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsActivity() {
    if (_friendActivities.isEmpty) {
      return _buildEmptyFriendsActivity();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: _friendActivities.asMap().entries.map((entry) {
          int index = entry.key;
          FriendActivity activity = entry.value;
          bool isLast = index == _friendActivities.length - 1;
          
          return Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              border: isLast ? null : Border(
                bottom: BorderSide(
                  color: AppColors.stroke,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.amethyst100,
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
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        activity.timeAgo,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                
                // Activity type icon
                Icon(
                  _getActivityIcon(activity.activityType),
                  color: _getActivityColor(activity.activityType),
                  size: 20,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyFriendsActivity() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: AppColors.textSecond,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            'No friend activity yet',
            style: AppTextStyles.cardTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            'Add friends to see their latest adventures and achievements',
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSnapshot() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          // Progress stats grid
          Row(
            children: [
              Expanded(
                child: _ProgressStatCard(
                  icon: Icons.map,
                  title: 'Trips',
                  value: '${_progressData.tripsThisWeek}',
                  subtitle: 'this week',
                  color: AppColors.amethyst600,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _ProgressStatCard(
                  icon: Icons.straighten,
                  title: 'Distance',
                  value: '${_progressData.totalDistance}km',
                  subtitle: 'total',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          Row(
            children: [
              Expanded(
                child: _ProgressStatCard(
                  icon: Icons.local_fire_department,
                  title: 'Streak',
                  value: '${_progressData.currentStreak}',
                  subtitle: 'days',
                  color: AppColors.challengeCrimson,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _ProgressStatCard(
                  icon: Icons.emoji_events,
                  title: 'Badges',
                  value: '${_progressData.badgesEarned}',
                  subtitle: 'earned',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          _QuickActionTile(
            icon: Icons.add_location,
            title: 'Create New Trip',
            subtitle: 'Plan your next adventure',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapTripCreationScreen(),
                ),
              );
            },
          ),
          
          const Divider(),
          
          _QuickActionTile(
            icon: Icons.leaderboard,
            title: 'View Leaderboard',
            subtitle: 'See how you rank',
            onTap: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
          ),
          
          const Divider(),
          
          _QuickActionTile(
            icon: Icons.people,
            title: 'Find Friends',
            subtitle: 'Connect with other explorers',
            onTap: () {
              Navigator.pushNamed(context, '/friends');
            },
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'trip_completed':
        return Icons.check_circle;
      case 'badge_earned':
        return Icons.emoji_events;
      case 'challenge_started':
        return Icons.flag;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String activityType) {
    switch (activityType) {
      case 'trip_completed':
        return AppColors.success;
      case 'badge_earned':
        return AppColors.challengeCrimson;
      case 'challenge_started':
        return AppColors.info;
      default:
        return AppColors.textSecond;
    }
  }
}

// Helper Widgets
class _ProgressStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _ProgressStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceS),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceM),
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                borderRadius: BorderRadius.circular(AppDimensions.spaceM),
              ),
              child: Icon(
                icon,
                color: AppColors.amethyst600,
                size: 24,
              ),
            ),
            
            const SizedBox(width: AppDimensions.spaceL),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(subtitle, style: AppTextStyles.cardSubtitle),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecond,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.2,
      size.width * 0.8, size.height * 0.6,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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