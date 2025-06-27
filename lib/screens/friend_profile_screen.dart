// lib/screens/friend_profile_screen.dart - FIXED TO ACCEPT STRING ID

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendProfileScreen extends StatefulWidget {
  final String friendId; // CHANGED: Now accepts String instead of FriendProfile object

  const FriendProfileScreen({
    super.key, // FIXED: Use super.key
    required this.friendId, // CHANGED: Parameter name to match main.dart
  });

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState(); // FIXED: Remove underscore
}

class _FriendProfileScreenState extends State<FriendProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late FriendProfile _friend; // Create friend object from ID
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _friend = _createMockFriendFromId(widget.friendId); // Create mock friend
    _isFollowing = _friend.isFollowing;
  }

  // ADDED: Create mock friend from ID for development
  FriendProfile _createMockFriendFromId(String friendId) {
    return FriendProfile(
      id: friendId,
      name: 'Friend $friendId',
      username: '@friend$friendId',
      avatar: Icons.person,
      isOnline: friendId.hashCode % 2 == 0, // Mock online status
      lastSeen: DateTime.now().subtract(Duration(hours: friendId.length)),
      isFollowing: false,
      totalTrips: 15 + friendId.length,
      badges: 8 + friendId.length,
      currentStreak: 5,
      bestStreak: 12,
      mutualFriends: 3,
      totalDistance: 45.2 + friendId.length,
      totalHours: 28 + friendId.length,
      favoriteType: 'crawl',
      tripTypeStats: {
        'explore': 8,
        'crawl': 12,
        'sport': 5,
      },
      recentActivity: [
        ActivityItem(
          description: 'Completed Downtown Adventure',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          icon: Icons.check_circle,
          color: AppColors.success,
        ),
        ActivityItem(
          description: 'Earned Explorer Badge',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.emoji_events,
          color: AppColors.warning,
        ),
      ],
      recentTrips: [
        FriendTrip(
          id: '1',
          title: 'City Center Crawl',
          type: 'crawl',
          distance: '3.2 km',
          duration: '2h 15m',
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
          isShared: true,
        ),
        FriendTrip(
          id: '2',
          title: 'Park Explorer',
          type: 'explore',
          distance: '5.1 km',
          duration: '1h 45m',
          completedAt: DateTime.now().subtract(const Duration(days: 3)),
          isShared: false,
        ),
      ],
      earnedBadges: [
        FriendBadge(
          id: '1',
          title: 'Explorer',
          type: 'explore',
          earnedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        FriendBadge(
          id: '2',
          title: 'Night Owl',
          type: 'crawl',
          earnedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    );
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
                unselectedLabelColor: Colors.white.withValues(alpha: 0.7), // FIXED: deprecated withOpacity
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
            AppColors.amethyst600.withValues(alpha: 0.8), // FIXED: deprecated withOpacity
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
                      color: Colors.white.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Icon(
                      _friend.avatar,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  if (_friend.isOnline)
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
                _friend.name,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _friend.username,
                style: AppTextStyles.cardSubtitle.copyWith(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9), // FIXED: deprecated withOpacity
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
                  color: Colors.white.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _friend.isOnline ? Icons.circle : Icons.access_time,
                      color: _friend.isOnline ? AppColors.success : Colors.white.withValues(alpha: 0.8), // FIXED: deprecated withOpacity
                      size: 16,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(
                      _friend.isOnline ? 'Online & Exploring' : _formatLastSeen(_friend.lastSeen),
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
                    value: '${_friend.totalTrips}',
                    label: 'Trips',
                    icon: Icons.route,
                  ),
                  _QuickStat(
                    value: '${_friend.badges}',
                    label: 'Badges',
                    icon: Icons.emoji_events,
                  ),
                  _QuickStat(
                    value: '${_friend.currentStreak}',
                    label: 'Streak',
                    icon: Icons.local_fire_department,
                  ),
                  _QuickStat(
                    value: '${_friend.mutualFriends}',
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
                        backgroundColor: _isFollowing ? Colors.white.withValues(alpha: 0.2) : Colors.white, // FIXED: deprecated withOpacity
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
                      color: Colors.white.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
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
                  value: '${_friend.totalDistance.toStringAsFixed(1)} km',
                  icon: Icons.straighten,
                  color: AppColors.amethyst600,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  title: 'Exploration Time',
                  value: '${_friend.totalHours}h',
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
                  value: _friend.favoriteType,
                  icon: Icons.favorite,
                  color: AppColors.crawlCrimson,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: _StatCard(
                  title: 'Best Streak',
                  value: '${_friend.bestStreak} days',
                  icon: Icons.local_fire_department,
                  color: AppColors.sportAmber,
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
          
          ..._friend.tripTypeStats.entries.map((entry) {
            final total = _friend.tripTypeStats.values.reduce((a, b) => a + b);
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
                      color: color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
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
                      backgroundColor: color.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          ..._friend.recentActivity.map((activity) {
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
                      color: activity.color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
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
          }),
        ],
      ),
    );
  }

  Widget _buildTripsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: _friend.recentTrips.length,
      itemBuilder: (context, index) {
        final trip = _friend.recentTrips[index];
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
      itemCount: _friend.earnedBadges.length,
      itemBuilder: (context, index) {
        final badge = _friend.earnedBadges[index];
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
            ? 'Now following ${_friend.name}' 
            : 'Unfollowed ${_friend.name}'),
      ),
    );
  }

  void _sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening chat with ${_friend.name}...')),
    );
  }

  void _challengeFriend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Challenge ${_friend.name}'),
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
      SnackBar(content: Text('$type challenge sent to ${_friend.name}!')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${_friend.name}\'s profile...')),
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${_friend.name}?'),
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
                SnackBar(content: Text('${_friend.name} has been blocked')),
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
      SnackBar(content: Text('Report submitted for ${_friend.name}')),
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
            color: Colors.white.withValues(alpha: 0.8), // FIXED: deprecated withOpacity
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
                  color: color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
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
            color: color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
            borderRadius: BorderRadius.circular(AppDimensions.spaceS),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(trip.title, style: AppTextStyles.cardTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${trip.distance} • ${trip.duration}', style: AppTextStyles.cardSubtitle),
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