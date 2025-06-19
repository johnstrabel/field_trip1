// lib/screens/friend_profile_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendProfileScreen extends StatefulWidget {
  final FriendProfile friend;

  const FriendProfileScreen({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  _FriendProfileScreenState createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isFollowing = widget.friend.isFollowing;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 320,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.amethyst600,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share Profile'),
                        onTap: () {
                          Navigator.pop(context);
                          _shareProfile();
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.block),
                        title: const Text('Block User'),
                        onTap: () {
                          Navigator.pop(context);
                          _blockUser();
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.report),
                        title: const Text('Report'),
                        onTap: () {
                          Navigator.pop(context);
                          _reportUser();
                        },
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: const [
                  Tab(text: 'Stats', icon: Icon(Icons.bar_chart, size: 20)),
                  Tab(text: 'Trips', icon: Icon(Icons.map, size: 20)),
                  Tab(text: 'Badges', icon: Icon(Icons.emoji_events, size: 20)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildStatsTab(),
            _buildTripsTab(),
            _buildBadgesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.amethyst600,
            AppColors.amethyst600.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceL),
          child: Column(
            children: [
              const SizedBox(height: 40), // Space for app bar
              
              // Avatar and Online Status
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Icon(
                      widget.friend.avatar,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  if (widget.friend.isOnline)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Name and Username
              Text(
                widget.friend.name,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.friend.username,
                style: AppTextStyles.heroSubtitle.copyWith(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceM,
                  vertical: AppDimensions.spaceS,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.friend.isOnline ? Icons.circle : Icons.access_time,
                      color: widget.friend.isOnline ? AppColors.success : Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(
                      widget.friend.isOnline ? 'Online & Exploring' : _formatLastSeen(widget.friend.lastSeen),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
                  _QuickStat(
                    value: '${widget.friend.totalTrips}',
                    label: 'Trips',
                    icon: Icons.route,
                  ),
                  _QuickStat(
                    value: '${widget.friend.badges}',
                    label: 'Badges',
                    icon: Icons.emoji_events,
                  ),
                  _QuickStat(
                    value: '${widget.friend.currentStreak}',
                    label: 'Streak',
                    icon: Icons.local_fire_department,
                  ),
                  _QuickStat(
                    value: '${widget.friend.mutualFriends}',
                    label: 'Mutual',
                    icon: Icons.people,
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceL),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing ? Colors.white.withOpacity(0.2) : Colors.white,
                        foregroundColor: _isFollowing ? Colors.white : AppColors.amethyst600,
                        side: _isFollowing ? const BorderSide(color: Colors.white) : null,
                      ),
                      icon: Icon(
                        _isFollowing ? Icons.check : Icons.person_add,
                        size: 20,
                      ),
                      label: Text(_isFollowing ? 'Following' : 'Follow'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _sendMessage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      icon: const Icon(Icons.message, size: 20),
                      label: const Text('Message'),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    ),
                    child: IconButton(
                      onPressed: _challengeFriend,
                      icon: const Icon(Icons.emoji_events, color: Colors.white),
                      tooltip: 'Challenge',
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

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Achievement Summary
          Text(
            'Achievement Summary',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Total Distance',
                  value: '${widget.friend.totalDistance.toStringAsFixed(1)} km',
                  icon: Icons.straighten,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  title: 'Exploration Time',
                  value: '${widget.friend.totalHours}h',
                  icon: Icons.access_time,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceM),
          
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Favorite Type',
                  value: widget.friend.favoriteType,
                  icon: Icons.favorite,
                  color: AppColors.challengeCrimson,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  title: 'Best Streak',
                  value: '${widget.friend.bestStreak} days',
                  icon: Icons.local_fire_department,
                  color: AppColors.fitnessAmber,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Trip Type Breakdown
          Text(
            'Trip Type Breakdown',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          ...widget.friend.tripTypeStats.entries.map((entry) {
            final total = widget.friend.tripTypeStats.values.reduce((a, b) => a + b);
            final percentage = (entry.value / total * 100).round();
            final color = TripTypeHelper.getColor(entry.key);
            final icon = TripTypeHelper.getIcon(entry.key);
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.spaceS),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                        ),
                        Text(
                          '${entry.value} trips ($percentage%)',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      value: entry.value / total,
                      backgroundColor: color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          ...widget.friend.recentActivity.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceS),
                    decoration: BoxDecoration(
                      color: activity.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activity.icon,
                      color: activity.color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.description, style: AppTextStyles.cardSubtitle),
                        Text(
                          _formatActivityTime(activity.timestamp),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTripsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: widget.friend.recentTrips.length,
      itemBuilder: (context, index) {
        final trip = widget.friend.recentTrips[index];
        return _TripCard(trip: trip, onTap: () => _viewTrip(trip));
      },
    );
  }

  Widget _buildBadgesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppDimensions.spaceM,
        mainAxisSpacing: AppDimensions.spaceM,
      ),
      itemCount: widget.friend.earnedBadges.length,
      itemBuilder: (context, index) {
        final badge = widget.friend.earnedBadges[index];
        return _BadgeCard(badge: badge);
      },
    );
  }

  // Action Methods
  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing 
            ? 'Now following ${widget.friend.name}' 
            : 'Unfollowed ${widget.friend.name}'),
      ),
    );
  }

  void _sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with ${widget.friend.name}...')),
    );
  }

  void _challengeFriend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Challenge ${widget.friend.name}'),
        content: const Text('Choose a challenge type:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _createChallenge('Distance');
            },
            child: const Text('Distance Challenge'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _createChallenge('Trip Count');
            },
            child: const Text('Trip Count Challenge'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _createChallenge(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type challenge sent to ${widget.friend.name}!')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${widget.friend.name}\'s profile...')),
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${widget.friend.name}?'),
        content: const Text('Blocked users won\'t be able to see your profile or send you messages.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.friend.name} has been blocked')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _reportUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report submitted for ${widget.friend.name}')),
    );
  }

  void _viewTrip(FriendTrip trip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening trip: ${trip.title}')),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return 'Active ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Active ${difference.inHours}h ago';
    } else {
      return 'Active ${difference.inDays}d ago';
    }
  }

  String _formatActivityTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Helper Widgets
class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _QuickStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: AppDimensions.spaceXS),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
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
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
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
            style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final FriendTrip trip;
  final VoidCallback onTap;

  const _TripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = TripTypeHelper.getColor(trip.type);
    final icon = TripTypeHelper.getIcon(trip.type);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceL),
        leading: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.spaceS),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(trip.title, style: AppTextStyles.cardTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${trip.distance} km • ${trip.duration}', style: AppTextStyles.cardSubtitle),
            Text(_formatActivityTime(trip.completedAt), style: AppTextStyles.caption),
          ],
        ),
        trailing: trip.isShared 
            ? const Icon(Icons.share, color: AppColors.success)
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _formatActivityTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).round()}w ago';
    }
  }
}

class _BadgeCard extends StatelessWidget {
  final FriendBadge badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    final color = TripTypeHelper.getColor(badge.type);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceL),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              badge.title,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              badge.type.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class FriendProfile {
  final String id;
  final String name;
  final String username;
  final IconData avatar;
  final bool isOnline;
  final DateTime lastSeen;
  final bool isFollowing;
  final int totalTrips;
  final int badges;
  final int currentStreak;
  final int bestStreak;
  final int mutualFriends;
  final double totalDistance;
  final int totalHours;
  final String favoriteType;
  final Map<String, int> tripTypeStats;
  final List<ActivityItem> recentActivity;
  final List<FriendTrip> recentTrips;
  final List<FriendBadge> earnedBadges;

  FriendProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.isFollowing,
    required this.totalTrips,
    required this.badges,
    required this.currentStreak,
    required this.bestStreak,
    required this.mutualFriends,
    required this.totalDistance,
    required this.totalHours,
    required this.favoriteType,
    required this.tripTypeStats,
    required this.recentActivity,
    required this.recentTrips,
    required this.earnedBadges,
  });
}

class ActivityItem {
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}

class FriendTrip {
  final String id;
  final String title;
  final String type;
  final String distance;
  final String duration;
  final DateTime completedAt;
  final bool isShared;

  FriendTrip({
    required this.id,
    required this.title,
    required this.type,
    required this.distance,
    required this.duration,
    required this.completedAt,
    required this.isShared,
  });
}

class FriendBadge {
  final String id;
  final String title;
  final String type;
  final DateTime earnedAt;

  FriendBadge({
    required this.id,
    required this.title,
    required this.type,
    required this.earnedAt,
  });
}