// lib/screens/leaderboard_screen.dart - Complete version with navigation wiring

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeframe = 'This Week';
  final List<String> _timeframeOptions = ['This Week', 'This Month', 'All Time'];

  // Mock data - replace with real data later
  final Map<String, List<LeaderboardEntry>> _leaderboards = {
    'trips': [
      LeaderboardEntry(
        rank: 1,
        userId: '1',
        name: 'Alex Chen',
        username: '@alexc',
        avatar: Icons.person,
        score: 28,
        change: 3,
        isCurrentUser: false,
        badges: 12,
        streak: 7,
      ),
      LeaderboardEntry(
        rank: 2,
        userId: '2',
        name: 'Maya Rodriguez',
        username: '@maya_explores',
        avatar: Icons.person_2,
        score: 24,
        change: 1,
        isCurrentUser: false,
        badges: 10,
        streak: 4,
      ),
      LeaderboardEntry(
        rank: 3,
        userId: '3',
        name: 'Sam Johnson',
        username: '@sam_adventures',
        avatar: Icons.person_3,
        score: 22,
        change: -1,
        isCurrentUser: false,
        badges: 15,
        streak: 12,
      ),
      LeaderboardEntry(
        rank: 4,
        userId: 'current',
        name: 'You',
        username: '@explorer',
        avatar: Icons.person_4,
        score: 18,
        change: 2,
        isCurrentUser: true,
        badges: 8,
        streak: 3,
      ),
      LeaderboardEntry(
        rank: 5,
        userId: '5',
        name: 'Emma Wilson',
        username: '@emma_w',
        avatar: Icons.person,
        score: 16,
        change: 0,
        isCurrentUser: false,
        badges: 6,
        streak: 2,
      ),
    ],
    'distance': [
      LeaderboardEntry(
        rank: 1,
        userId: '3',
        name: 'Sam Johnson',
        username: '@sam_adventures',
        avatar: Icons.person_3,
        score: 142, // km
        change: 8,
        isCurrentUser: false,
        badges: 15,
        streak: 12,
      ),
      LeaderboardEntry(
        rank: 2,
        userId: '1',
        name: 'Alex Chen',
        username: '@alexc',
        avatar: Icons.person,
        score: 128,
        change: 5,
        isCurrentUser: false,
        badges: 12,
        streak: 7,
      ),
      LeaderboardEntry(
        rank: 3,
        userId: 'current',
        name: 'You',
        username: '@explorer',
        avatar: Icons.person_4,
        score: 95,
        change: 12,
        isCurrentUser: true,
        badges: 8,
        streak: 3,
      ),
      LeaderboardEntry(
        rank: 4,
        userId: '2',
        name: 'Maya Rodriguez',
        username: '@maya_explores',
        avatar: Icons.person_2,
        score: 87,
        change: -2,
        isCurrentUser: false,
        badges: 10,
        streak: 4,
      ),
      LeaderboardEntry(
        rank: 5,
        userId: '5',
        name: 'Emma Wilson',
        username: '@emma_w',
        avatar: Icons.person,
        score: 73,
        change: 3,
        isCurrentUser: false,
        badges: 6,
        streak: 2,
      ),
    ],
    'badges': [
      LeaderboardEntry(
        rank: 1,
        userId: '3',
        name: 'Sam Johnson',
        username: '@sam_adventures',
        avatar: Icons.person_3,
        score: 15,
        change: 1,
        isCurrentUser: false,
        badges: 15,
        streak: 12,
      ),
      LeaderboardEntry(
        rank: 2,
        userId: '1',
        name: 'Alex Chen',
        username: '@alexc',
        avatar: Icons.person,
        score: 12,
        change: 2,
        isCurrentUser: false,
        badges: 12,
        streak: 7,
      ),
      LeaderboardEntry(
        rank: 3,
        userId: '2',
        name: 'Maya Rodriguez',
        username: '@maya_explores',
        avatar: Icons.person_2,
        score: 10,
        change: 0,
        isCurrentUser: false,
        badges: 10,
        streak: 4,
      ),
      LeaderboardEntry(
        rank: 4,
        userId: 'current',
        name: 'You',
        username: '@explorer',
        avatar: Icons.person_4,
        score: 8,
        change: 1,
        isCurrentUser: true,
        badges: 8,
        streak: 3,
      ),
      LeaderboardEntry(
        rank: 5,
        userId: '5',
        name: 'Emma Wilson',
        username: '@emma_w',
        avatar: Icons.person,
        score: 6,
        change: 0,
        isCurrentUser: false,
        badges: 6,
        streak: 2,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedTimeframe,
            onSelected: (String value) {
              setState(() {
                _selectedTimeframe = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _timeframeOptions.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedTimeframe,
                    style: AppTextStyles.cardSubtitle.copyWith(
                      color: AppColors.amethyst600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.amethyst600,
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.amethyst600,
          labelColor: AppColors.amethyst600,
          unselectedLabelColor: AppColors.textSecond,
          tabs: const [
            Tab(text: 'Trips'),
            Tab(text: 'Distance'),
            Tab(text: 'Badges'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboard('trips', 'trips', Icons.map),
          _buildLeaderboard('distance', 'km', Icons.straighten),
          _buildLeaderboard('badges', 'badges', Icons.emoji_events),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(String type, String unit, IconData icon) {
    final entries = _leaderboards[type] ?? [];
    
    if (entries.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.spaceM),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _LeaderboardCard(
          entry: entry,
          subtitle: '${entry.score} $unit',
          icon: icon,
          onTap: () => _viewProfile(entry),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.emoji_events_outlined,
                size: 60,
                color: AppColors.amethyst600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              'No leaderboard data',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              'Complete trips and challenges to see how you rank among your friends!',
              style: AppTextStyles.cardSubtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    Color textColor;
    
    switch (rank) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        textColor = Colors.black;
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        textColor = Colors.black;
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        textColor = Colors.white;
        break;
      default:
        badgeColor = AppColors.amethyst100;
        textColor = AppColors.amethyst600;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        border: rank <= 3 ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(LeaderboardEntry user, String subtitle, IconData icon) {
    return Row(
      children: [
        // Avatar with online indicator (for non-current users)
        Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: user.isCurrentUser 
                    ? AppColors.amethyst100 
                    : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                user.avatar,
                color: user.isCurrentUser 
                    ? AppColors.amethyst600 
                    : AppColors.textSecond,
                size: 24,
              ),
            ),
            if (!user.isCurrentUser)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(width: AppDimensions.spaceM),
        
        // User details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: AppTextStyles.cardTitle.copyWith(
                  fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              Text(
                user.username,
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Row(
                children: [
                  Text(
                    subtitle,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.amethyst600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Icon(
                    user.change > 0 
                        ? Icons.trending_up 
                        : user.change < 0 
                            ? Icons.trending_down 
                            : Icons.trending_flat,
                    color: user.change > 0 
                        ? AppColors.success 
                        : user.change < 0 
                            ? AppColors.error 
                            : AppColors.textSecond,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Text(
                    user.change == 0 
                        ? 'No change' 
                        : '${user.change > 0 ? '+' : ''}${user.change} from last period',
                    style: TextStyle(
                      color: user.change > 0 
                          ? AppColors.success 
                          : user.change < 0 
                              ? AppColors.error 
                              : AppColors.textSecond,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Action button
        Icon(
          icon,
          color: AppColors.amethyst600,
          size: 32,
        ),
      ],
    );
  }

  // Helper method to convert LeaderboardEntry to FriendProfile for navigation
  FriendProfile _leaderboardEntryToProfile(LeaderboardEntry entry) {
    return FriendProfile(
      id: entry.userId,
      name: entry.name,
      username: entry.username,
      avatar: entry.avatar,
      isOnline: true, // Mock data
      lastSeen: DateTime.now(),
      totalTrips: entry.score,
      badges: entry.badges,
      currentStreak: entry.streak,
      mutualFriends: 2, // Mock data
      isFollowing: false,
      location: 'Unknown', // Mock data
      bio: 'Fellow explorer and adventurer',
    );
  }

  void _viewProfile(LeaderboardEntry entry) {
    if (entry.isCurrentUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This is your profile!')),
      );
    } else {
      final friendProfile = _leaderboardEntryToProfile(entry);
      Navigator.pushNamed(
        context,
        '/friend-profile',
        arguments: friendProfile,
      );
    }
  }
}

class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _LeaderboardCard({
    required this.entry,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: entry.isCurrentUser 
              ? AppColors.amethyst100.withOpacity(0.3)
              : AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: entry.isCurrentUser 
              ? Border.all(color: AppColors.amethyst600, width: 2)
              : Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            // Rank badge
            _buildRankBadge(entry.rank),
            
            const SizedBox(width: AppDimensions.spaceM),
            
            // User info
            Expanded(
              child: _buildUserInfo(entry, subtitle, icon),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    Color textColor;
    
    switch (rank) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        textColor = Colors.black;
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        textColor = Colors.black;
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        textColor = Colors.white;
        break;
      default:
        badgeColor = AppColors.amethyst100;
        textColor = AppColors.amethyst600;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        border: rank <= 3 ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Center(
        child: Text(
          '$rank',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(LeaderboardEntry user, String subtitle, IconData icon) {
    return Row(
      children: [
        // Avatar with online indicator (for non-current users)
        Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: user.isCurrentUser 
                    ? AppColors.amethyst100 
                    : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                user.avatar,
                color: user.isCurrentUser 
                    ? AppColors.amethyst600 
                    : AppColors.textSecond,
                size: 24,
              ),
            ),
            if (!user.isCurrentUser)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(width: AppDimensions.spaceM),
        
        // User details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: AppTextStyles.cardTitle.copyWith(
                  fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.w600,
                ),
              ),
              Text(
                user.username,
                style: AppTextStyles.cardSubtitle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: AppDimensions.spaceXS),
              Row(
                children: [
                  Text(
                    subtitle,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.amethyst600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Icon(
                    user.change > 0 
                        ? Icons.trending_up 
                        : user.change < 0 
                            ? Icons.trending_down 
                            : Icons.trending_flat,
                    color: user.change > 0 
                        ? AppColors.success 
                        : user.change < 0 
                            ? AppColors.error 
                            : AppColors.textSecond,
                    size: 16,
                  ),
                  const SizedBox(width: AppDimensions.spaceXS),
                  Text(
                    user.change == 0 
                        ? 'No change' 
                        : '${user.change > 0 ? '+' : ''}${user.change} from last period',
                    style: TextStyle(
                      color: user.change > 0 
                          ? AppColors.success 
                          : user.change < 0 
                              ? AppColors.error 
                              : AppColors.textSecond,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Action icon
        Icon(
          icon,
          color: AppColors.amethyst600,
          size: 32,
        ),
      ],
    );
  }
}

// Data Models
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String name;
  final String username;
  final IconData avatar;
  final int score;
  final int change;
  final bool isCurrentUser;
  final int badges;
  final int streak;

  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.name,
    required this.username,
    required this.avatar,
    required this.score,
    required this.change,
    required this.isCurrentUser,
    required this.badges,
    required this.streak,
  });
}

class FriendProfile {
  final String id;
  final String name;
  final String username;
  final IconData avatar;
  final bool isOnline;
  final DateTime lastSeen;
  final int totalTrips;
  final int badges;
  final int currentStreak;
  final int mutualFriends;
  final bool isFollowing;
  final String location;
  final String bio;

  FriendProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.isOnline,
    required this.lastSeen,
    required this.totalTrips,
    required this.badges,
    required this.currentStreak,
    required this.mutualFriends,
    required this.isFollowing,
    required this.location,
    required this.bio,
  });
}