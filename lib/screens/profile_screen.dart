// lib/screens/profile_screen.dart - Complete version with navigation wiring

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trip.dart' as model;
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<model.Trip>('trips').listenable(),
        builder: (context, Box<model.Trip> tripBox, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<model.Badge>('badges').listenable(),
            builder: (context, Box<model.Badge> badgeBox, _) {
              final trips = tripBox.values.toList();
              final badges = badgeBox.values.toList();
              final completedTrips = trips.where((t) => t.completed).length;
              final completionRate = trips.isEmpty ? 0.0 : (completedTrips / trips.length) * 100;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Profile Section
                    _buildHeroSection(context, trips, badges),
                    
                    const SizedBox(height: AppDimensions.spaceL),
                    
                    // Stats Grid (2x2)
                    _buildStatsGrid(trips, badges, completedTrips, completionRate),
                    
                    const SizedBox(height: AppDimensions.spaceL),
                    
                    // Trip Type Breakdown
                    _buildTripTypeBreakdown(trips),
                    
                    const SizedBox(height: AppDimensions.spaceL),
                    
                    // Social Section - UPDATED WITH NAVIGATION
                    _buildSocialSection(context),
                    
                    const SizedBox(height: AppDimensions.spaceL),
                    
                    // Quick Actions
                    _buildQuickActions(context),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, List<model.Trip> trips, List<model.Badge> badges) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.amethyst600,
            AppColors.amethyst600.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.amethyst600.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Status
          Stack(
            children: [
              Container(
                width: AppDimensions.avatarSize,
                height: AppDimensions.avatarSize,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.onlineGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          // Name and Title
          Text(
            'Explorer',
            style: AppTextStyles.heroTitle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceM,
              vertical: AppDimensions.spaceXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.onlineBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.onlineGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceXS),
                Text(
                  'Online & Exploring',
                  style: TextStyle(
                    color: AppColors.onlineGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Quick Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HeroStat(
                value: '${trips.length}',
                label: 'Total Trips',
              ),
              Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
              _HeroStat(
                value: '${badges.length}',
                label: 'Badges Earned',
              ),
              Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
              _HeroStat(
                value: 'Level ${_calculateLevel(trips.length, badges.length)}',
                label: 'Explorer Level',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<model.Trip> trips, List<model.Badge> badges, int completedTrips, double completionRate) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.check_circle,
                  title: 'Completed',
                  value: '$completedTrips',
                  subtitle: 'Trips finished',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up,
                  title: 'Success Rate',
                  value: '${completionRate.toStringAsFixed(0)}%',
                  subtitle: 'Completion rate',
                  color: AppColors.amethyst600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.explore,
                  title: 'Active Trips',
                  value: '${trips.length - completedTrips}',
                  subtitle: 'In progress',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  icon: Icons.emoji_events,
                  title: 'Achievements',
                  value: '${badges.length}',
                  subtitle: 'Badges collected',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeBreakdown(List<model.Trip> trips) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: AppColors.amethyst600,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  Text(
                    'Trip Types Completed',
                    style: AppTextStyles.cardTitle,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceL),
              ...model.TripType.values.map((type) {
                final typeName = type.toString().split('.').last;
                final count = trips.where((t) => t.type == type && t.completed).length;
                final color = TripTypeHelper.getColor(typeName);
                final icon = TripTypeHelper.getIcon(typeName);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.spaceS),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(
                        child: Text(
                          typeName.toUpperCase(),
                          style: AppTextStyles.cardSubtitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceM,
                          vertical: AppDimensions.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_outlined,
                    color: AppColors.amethyst600,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.spaceS),
                  Text(
                    'Social',
                    style: AppTextStyles.cardTitle,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Text(
                'Connect with friends to share trips and compete on leaderboards.',
                style: AppTextStyles.cardSubtitle,
              ),
              const SizedBox(height: AppDimensions.spaceL),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/friends');
                      },
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Add Friends'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/leaderboard');
                      },
                      icon: const Icon(Icons.leaderboard, size: 18),
                      label: const Text('Leaderboard'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst100,
                      borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: AppColors.amethyst600,
                      size: 20,
                    ),
                  ),
                  title: const Text('View Detailed Stats'),
                  subtitle: const Text('See your complete exploration analytics'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Detailed analytics coming soon!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                  title: const Text('Achievement Gallery'),
                  subtitle: const Text('Browse all your earned badges'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to badge wall - using a simple approach since we can't guarantee DefaultTabController exists
                    Navigator.of(context).pushNamed('/badges');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    ),
                    child: const Icon(
                      Icons.share,
                      color: AppColors.info,
                      size: 20,
                    ),
                  ),
                  title: const Text('Share Profile'),
                  subtitle: const Text('Let friends see your exploration journey'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile sharing coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateLevel(int tripCount, int badgeCount) {
    // Simple level calculation: trips + badges / 5, minimum level 1
    return ((tripCount + badgeCount) / 5).floor() + 1;
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heroTitle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXS),
        Text(
          label,
          style: AppTextStyles.heroSubtitle.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceS),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceS),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.cardSubtitle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              value,
              style: AppTextStyles.statValue.copyWith(
                color: color,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXS),
            Text(
              subtitle,
              style: AppTextStyles.statLabel.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}