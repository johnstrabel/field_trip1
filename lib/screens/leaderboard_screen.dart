// lib/screens/leaderboard_screen.dart - Complete version with navigation wiring

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

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
        change: -1,
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
    ],
    'streaks': [
      LeaderboardEntry(
        rank: 1,
        userId: '3',
        name: 'Sam Johnson',
        username: '@sam_adventures',
        avatar: Icons.person_3,
        score: 12,
        change: 0,
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
        score: 7,
        change: 1,
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
        score: 4,
        change: -1,
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
        score: 3,
        change: 1,
        isCurrentUser: true,
        badges: 8,
        streak: 3,
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
        backgroundColor: AppColors.card,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.access_time),
            initialValue: _selectedTimeframe,
            onSelected: (value) {
              setState(() {
                _selectedTimeframe = value;
              });
            },
            itemBuilder: (context) => _timeframeOptions.map((timeframe) {
              return PopupMenuItem<String>(
                value: timeframe,
                child: Row(
                  children: [
                    Icon(
                      _selectedTimeframe == timeframe
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: AppColors.amethyst600,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(timeframe),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.amethyst600,
          labelColor: AppColors.amethyst600,
          unselectedLabelColor: AppColors.textSecond,
          tabs: const [
            Tab(
              text: 'Trips',
              icon: Icon(Icons.route, size: 20),
            ),
            Tab(
              text: 'Badges',
              icon: Icon(Icons.emoji_events, size: 20),
            ),
            Tab(
              text: 'Streaks',
              icon: Icon(Icons.local_fire_department, size: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Timeframe Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.amethyst600.withOpacity(0.1),
                  AppColors.amethyst100.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.amethyst600,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.spaceS),
                Text(
                  _selectedTimeframe,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.amethyst600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardTab('trips', 'Trips Completed', Icons.route),
                _buildLeaderboardTab('badges', 'Badges Earned', Icons.emoji_events),
                _buildLeaderboardTab('streaks', 'Day Streak', Icons.local_fire_department),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(String category, String subtitle, IconData icon) {
    final entries = _leaderboards[category] ?? [];
    final currentUserEntry = entries.firstWhere(
      (entry) => entry.isCurrentUser,
      orElse: () => entries.first,
    );

    return Column(
      children: [
        // Top 3 Podium
        if (entries.length >= 3) _buildPodium(entries.take(3).toList(), icon),

        // Current User Summary (if not in top 3)
        if (currentUserEntry.rank > 3) _buildCurrentUserSummary(currentUserEntry, subtitle, icon),

        // Full Leaderboard
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _LeaderboardCard(
                entry: entries[index],
                subtitle: subtitle,
                icon: icon,
                onTap: () => _viewProfile(entries[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> topThree, IconData icon) {
    // Reorder for podium display: 2nd, 1st, 3rd
    final podiumOrder = [
      if (topThree.length > 1) topThree[1], // 2nd place
      topThree[0], // 1st place
      if (topThree.length > 2) topThree[2], // 3rd place
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: podiumOrder.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          final realRank = user.rank;
          
          // Heights for podium effect
          final heights = [80.0, 120.0, 60.0]; // 2nd, 1st, 3rd
          final colors = [
            Colors.grey.shade400, // Silver
            AppColors.warning, // Gold
            Colors.brown.shade400, // Bronze
          ];
          
          return Column(
            children: [
              // Avatar with crown for 1st place
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: realRank == 1 ? 80 : 60,
                    height: realRank == 1 ? 80 : 60,
                    decoration: BoxDecoration(
                      color: AppColors.amethyst100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors[index],
                        width: realRank == 1 ? 4 : 3,
                      ),
                    ),
                    child: Icon(
                      user.avatar,
                      color: AppColors.amethyst600,
                      size: realRank == 1 ? 32 : 24,
                    ),
                  ),
                  if (realRank == 1)
                    Positioned(
                      top: -10,
                      left: 0,
                      right: 0,
                      child: Icon(
                        Icons.emoji_events,
                        color: AppColors.warning,
                        size: 32,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Name
              SizedBox(
                width: 80,
                child: Text(
                  user.isCurrentUser ? 'You' : user.name.split(' ').first,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: realRank == 1 ? 16 : 14,
                    fontWeight: realRank == 1 ? FontWeight.bold : FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Score
              Text(
                '${user.score}',
                style: TextStyle(
                  fontSize: realRank == 1 ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: colors[index],
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceS),
              
              // Podium Base
              Container(
                width: 60,
                height: heights[index],
                decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusS),
                    topRight: Radius.circular(AppDimensions.radiusS),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$realRank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentUserSummary(LeaderboardEntry user, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.amethyst600.withOpacity(0.1),
            AppColors.amethyst100.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.amethyst600.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.amethyst600,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#${user.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Ranking',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.amethyst600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${user.score} $subtitle',
                  style: AppTextStyles.cardSubtitle,
                ),
                if (user.change != 0)
                  Row(
                    children: [
                      Icon(
                        user.change > 0 ? Icons.trending_up : Icons.trending_down,
                        color: user.change > 0 ? AppColors.success : AppColors.error,
                        size: 16,
                      ),
                      const SizedBox(width: AppDimensions.spaceXS),
                      Text(
                        '${user.change > 0 ? '+' : ''}${user.change} from last period',
                        style: TextStyle(
                          color: user.change > 0 ? AppColors.success : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Icon(
            icon,
            color: AppColors.amethyst600,
            size: 32,
          ),
        ],
      ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: entry.isCurrentUser 
            ? AppColors.amethyst100.withOpacity(0.3)
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: entry.isCurrentUser 
            ? Border.all(color: AppColors.amethyst600.withOpacity(0.5))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceM),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(entry.rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#${entry.rank}',
                  style: TextStyle(
                    color: entry.rank <= 3 ? Colors.white : AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.amethyst100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                entry.avatar,
                color: AppColors.amethyst600,
                size: 24,
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              entry.isCurrentUser ? 'You' : entry.name,
              style: AppTextStyles.cardTitle.copyWith(
                fontWeight: entry.isCurrentUser ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (entry.isCurrentUser) ...[
              const SizedBox(width: AppDimensions.spaceS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amethyst600,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.username, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '${entry.score} $subtitle',
                  style: AppTextStyles.cardSubtitle,
                ),
                if (entry.change != 0) ...[
                  const SizedBox(width: AppDimensions.spaceS),
                  Icon(
                    entry.change > 0 ? Icons.trending_up : Icons.trending_down,
                    color: entry.change > 0 ? AppColors.success : AppColors.error,
                    size: 14,
                  ),
                  Text(
                    '${entry.change > 0 ? '+' : ''}${entry.change}',
                    style: TextStyle(
                      color: entry.change > 0 ? AppColors.success : AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (entry.rank <= 3)
              Icon(
                Icons.emoji_events,
                color: _getRankColor(entry.rank),
                size: 24,
              )
            else
              Icon(
                icon,
                color: AppColors.textSecond,
                size: 20,
              ),
            const SizedBox(height: 4),
            Text(
              '${entry.badges} badges',
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.warning; // Gold
      case 2:
        return Colors.grey.shade400; // Silver
      case 3:
        return Colors.brown.shade400; // Bronze
      default:
        return AppColors.surface;
    }
  }
}

// Data Model
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String name;
  final String username;
  final IconData avatar;
  final int score;
  final int change; // +/- change from last period
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