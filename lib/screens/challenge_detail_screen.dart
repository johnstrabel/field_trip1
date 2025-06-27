// lib/screens/challenge_detail_screen.dart - FIXED TO ACCEPT STRING ID

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId; // CHANGED: Now accepts String instead of Challenge object

  const ChallengeDetailScreen({
    super.key, // FIXED: Use super.key
    required this.challengeId, // CHANGED: Parameter name to match main.dart
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState(); // FIXED: Remove underscore
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _progressController;
  late Challenge _challenge; // Create challenge object from ID
  bool _isParticipating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _challenge = _createMockChallengeFromId(widget.challengeId); // Create mock challenge
    _isParticipating = _challenge.isParticipating;
    
    // Animate progress on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressController.forward();
    });
  }

  // ADDED: Create mock challenge from ID for development
  Challenge _createMockChallengeFromId(String challengeId) {
    return Challenge(
      id: challengeId,
      title: 'Challenge $challengeId',
      description: 'Complete this exciting challenge and earn rewards!',
      objective: 'Complete 5 different types of trips in 30 days',
      icon: Icons.emoji_events,
      color: AppColors.crawlCrimson,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 25)),
      reward: '500 Points',
      rewardDetails: 'Earn 500 points and unlock the Explorer Badge',
      rules: [
        'Complete at least 5 trips',
        'Each trip must be different type',
        'Complete within 30 days',
        'Share at least 2 trips with friends',
      ],
      tips: [
        'Start with easy explore trips',
        'Try different neighborhoods',
        'Invite friends for group trips',
        'Check the community hub for inspiration',
      ],
      milestones: [
        ChallengeMilestone(
          title: 'First Trip',
          description: 'Complete your first trip of any type',
        ),
        ChallengeMilestone(
          title: 'Explorer',
          description: 'Complete 2 different trip types',
        ),
        ChallengeMilestone(
          title: 'Adventurer',
          description: 'Complete 3 different trip types',
        ),
        ChallengeMilestone(
          title: 'Social Explorer',
          description: 'Share a trip with friends',
        ),
        ChallengeMilestone(
          title: 'Challenge Master',
          description: 'Complete all 5 trip types',
        ),
      ],
      leaderboard: [
        ChallengeParticipant(
          id: 'user1',
          name: 'Alex Chen',
          avatar: Icons.person,
          milestonesCompleted: 5,
          totalMilestones: 5,
          points: 500,
          isCurrentUser: false,
        ),
        ChallengeParticipant(
          id: 'current_user',
          name: 'You',
          avatar: Icons.person,
          milestonesCompleted: 3,
          totalMilestones: 5,
          points: 300,
          isCurrentUser: true,
        ),
        ChallengeParticipant(
          id: 'user3',
          name: 'Sarah Kim',
          avatar: Icons.person,
          milestonesCompleted: 2,
          totalMilestones: 5,
          points: 200,
          isCurrentUser: false,
        ),
      ],
      recentActivity: [
        ChallengeActivity(
          description: 'Alex Chen completed the challenge!',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          avatar: Icons.person,
          activityType: ActivityType.milestone,
        ),
        ChallengeActivity(
          description: 'Sarah Kim joined the challenge',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          avatar: Icons.person,
          activityType: ActivityType.joined,
        ),
      ],
      participantCount: 156,
      isParticipating: true,
      userProgress: 3,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _progressController.dispose();
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
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: _challenge.color,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildChallengeHeader(),
              ),
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share Challenge'),
                        onTap: () {
                          Navigator.pop(context);
                          _shareChallenge();
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notifications'),
                        onTap: () {
                          Navigator.pop(context);
                          _toggleNotifications();
                        },
                      ),
                    ),
                    if (_isParticipating)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Leave Challenge'),
                          onTap: () {
                            Navigator.pop(context);
                            _leaveChallenge();
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
                  Tab(text: 'Overview', icon: Icon(Icons.info_outline, size: 20)),
                  Tab(text: 'Leaderboard', icon: Icon(Icons.emoji_events, size: 20)),
                  Tab(text: 'Activity', icon: Icon(Icons.timeline, size: 20)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildLeaderboardTab(),
            _buildActivityTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _challenge.color,
            _challenge.color.withValues(alpha: 0.8), // FIXED: deprecated withOpacity
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
              
              // Challenge Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  _challenge.icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spaceM),
              
              // Challenge Title & Description
              Text(
                _challenge.title,
                style: AppTextStyles.heroTitle.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Text(
                _challenge.description,
                style: AppTextStyles.cardSubtitle.copyWith(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9), // FIXED: deprecated withOpacity
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              
              const SizedBox(height: AppDimensions.spaceL),
              
              // Quick Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HeaderStat(
                    icon: Icons.people,
                    value: '${_challenge.participantCount}',
                    label: 'Participants',
                  ),
                  _HeaderStat(
                    icon: Icons.access_time,
                    value: _formatTimeLeft(_challenge.endDate),
                    label: 'Time Left',
                  ),
                  _HeaderStat(
                    icon: Icons.emoji_events,
                    value: _challenge.reward,
                    label: 'Reward',
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spaceL),
              
              // Join/Leave Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _toggleParticipation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isParticipating 
                        ? Colors.white.withValues(alpha: 0.2) // FIXED: deprecated withOpacity
                        : Colors.white,
                    foregroundColor: _isParticipating 
                        ? Colors.white 
                        : _challenge.color,
                    side: _isParticipating 
                        ? const BorderSide(color: Colors.white) 
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceM),
                  ),
                  icon: Icon(
                    _isParticipating ? Icons.check : Icons.add,
                    size: 20,
                  ),
                  label: Text(
                    _isParticipating ? 'Participating' : 'Join Challenge',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Section
          if (_isParticipating) ...[
            Text(
              'Your Progress',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            _buildProgressCard(),
            const SizedBox(height: AppDimensions.spaceL),
          ],
          
          // Challenge Details
          Text(
            'Challenge Details',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          _DetailCard(
            icon: Icons.flag,
            title: 'Objective',
            content: _challenge.objective,
          ),
          
          _DetailCard(
            icon: Icons.schedule,
            title: 'Duration',
            content: '${_formatDate(_challenge.startDate)} - ${_formatDate(_challenge.endDate)}',
          ),
          
          _DetailCard(
            icon: Icons.rule,
            title: 'Rules',
            content: _challenge.rules.join('\n• '),
          ),
          
          _DetailCard(
            icon: Icons.emoji_events,
            title: 'Rewards',
            content: _challenge.rewardDetails,
          ),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Milestones
          Text(
            'Milestones',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          
          ..._challenge.milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final milestone = entry.value;
            final isCompleted = _isParticipating && index < _challenge.userProgress;
            final isActive = _isParticipating && index == _challenge.userProgress;
            
            return _MilestoneCard(
              milestone: milestone,
              isCompleted: isCompleted,
              isActive: isActive,
              color: _challenge.color,
            );
          }),
          
          const SizedBox(height: AppDimensions.spaceL),
          
          // Tips Section
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceL),
            decoration: BoxDecoration(
              color: _challenge.color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: _challenge.color.withValues(alpha: 0.3)), // FIXED: deprecated withOpacity
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: _challenge.color,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.spaceS),
                    Text(
                      'Pro Tips',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: _challenge.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceM),
                ..._challenge.tips.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spaceS),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: _challenge.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceS),
                        Expanded(
                          child: Text(
                            tip,
                            style: AppTextStyles.cardSubtitle,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = _challenge.userProgress / _challenge.milestones.length;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _challenge.color.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
            _challenge.color.withValues(alpha: 0.05), // FIXED: deprecated withOpacity
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: _challenge.color.withValues(alpha: 0.3)), // FIXED: deprecated withOpacity
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTextStyles.cardTitle.copyWith(
                  color: _challenge.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_challenge.userProgress}/${_challenge.milestones.length}',
                style: AppTextStyles.cardTitle.copyWith(
                  color: _challenge.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: progress * _progressController.value,
                backgroundColor: _challenge.color.withValues(alpha: 0.2), // FIXED: deprecated withOpacity
                valueColor: AlwaysStoppedAnimation<Color>(_challenge.color),
                minHeight: 8,
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            _getProgressMessage(),
            style: AppTextStyles.cardSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: _challenge.leaderboard.length,
      itemBuilder: (context, index) {
        final participant = _challenge.leaderboard[index];
        return _LeaderboardCard(
          participant: participant,
          rank: index + 1,
          isCurrentUser: participant.isCurrentUser,
          color: _challenge.color,
        );
      },
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      itemCount: _challenge.recentActivity.length,
      itemBuilder: (context, index) {
        final activity = _challenge.recentActivity[index];
        return _ActivityCard(activity: activity);
      },
    );
  }

  // Action Methods
  void _toggleParticipation() {
    setState(() {
      _isParticipating = !_isParticipating;
    });
    
    if (_isParticipating) {
      _progressController.forward();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joined ${_challenge.title}!'),
          backgroundColor: _challenge.color,
        ),
      );
    } else {
      _progressController.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Left challenge'),
        ),
      );
    }
  }

  void _shareChallenge() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${_challenge.title}...'),
        backgroundColor: _challenge.color,
      ),
    );
  }

  void _toggleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification preferences updated')),
    );
  }

  void _leaveChallenge() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Challenge?'),
        content: Text('Are you sure you want to leave ${_challenge.title}? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _toggleParticipation();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  String _getProgressMessage() {
    final remaining = _challenge.milestones.length - _challenge.userProgress;
    if (remaining == 0) {
      return 'Challenge completed! 🎉';
    } else if (remaining == 1) {
      return '1 milestone remaining';
    } else {
      return '$remaining milestones remaining';
    }
  }

  String _formatTimeLeft(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Helper Widgets
class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8), // FIXED: deprecated withOpacity
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceS),
            decoration: BoxDecoration(
              color: AppColors.amethyst600.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
              borderRadius: BorderRadius.circular(AppDimensions.spaceS),
            ),
            child: Icon(icon, color: AppColors.amethyst600, size: 20),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                const SizedBox(height: AppDimensions.spaceS),
                Text(content, style: AppTextStyles.cardSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final ChallengeMilestone milestone;
  final bool isCompleted;
  final bool isActive;
  final Color color;

  const _MilestoneCard({
    required this.milestone,
    required this.isCompleted,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: isActive 
            ? color.withValues(alpha: 0.1) // FIXED: deprecated withOpacity
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: isActive 
            ? Border.all(color: color, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted 
                  ? color 
                  : isActive 
                      ? color.withValues(alpha: 0.2) // FIXED: deprecated withOpacity
                      : AppColors.stroke,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted 
                  ? Icons.check 
                  : isActive 
                      ? Icons.play_arrow
                      : Icons.lock,
              color: isCompleted || isActive 
                  ? Colors.white 
                  : AppColors.textSecond,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: isActive ? color : null,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                Text(
                  milestone.description,
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: const Text(
                'COMPLETED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final ChallengeParticipant participant;
  final int rank;
  final bool isCurrentUser;
  final Color color;

  const _LeaderboardCard({
    required this.participant,
    required this.rank,
    required this.isCurrentUser,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
      decoration: BoxDecoration(
        color: isCurrentUser 
            ? color.withValues(alpha: 0.1) // FIXED: deprecated withOpacity
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: isCurrentUser 
            ? Border.all(color: color.withValues(alpha: 0.5)) // FIXED: deprecated withOpacity
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.spaceM),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    color: rank <= 3 ? Colors.white : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.amethyst600.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
                shape: BoxShape.circle,
              ),
              child: Icon(
                participant.avatar,
                color: AppColors.amethyst600,
                size: 20,
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              isCurrentUser ? 'You' : participant.name,
              style: AppTextStyles.cardTitle.copyWith(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (isCurrentUser) ...[
              const SizedBox(width: AppDimensions.spaceS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color,
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
        subtitle: Text(
          '${participant.milestonesCompleted}/${participant.totalMilestones} milestones',
          style: AppTextStyles.cardSubtitle,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${participant.points}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Text(
              'points',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
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

class _ActivityCard extends StatelessWidget {
  final ChallengeActivity activity;

  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.amethyst600.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.avatar,
              color: AppColors.amethyst600,
              size: 20,
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
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceS),
            decoration: BoxDecoration(
              color: activity.activityType == ActivityType.milestone
                  ? AppColors.success.withValues(alpha: 0.1) // FIXED: deprecated withOpacity
                  : AppColors.amethyst600.withValues(alpha: 0.1), // FIXED: deprecated withOpacity
              borderRadius: BorderRadius.circular(AppDimensions.spaceS),
            ),
            child: Icon(
              activity.activityType == ActivityType.milestone
                  ? Icons.flag
                  : Icons.person_add,
              color: activity.activityType == ActivityType.milestone
                  ? AppColors.success
                  : AppColors.amethyst600,
              size: 16,
            ),
          ),
        ],
      ),
    );
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

// Data Models
class Challenge {
  final String id;
  final String title;
  final String description;
  final String objective;
  final IconData icon;
  final Color color;
  final DateTime startDate;
  final DateTime endDate;
  final String reward;
  final String rewardDetails;
  final List<String> rules;
  final List<String> tips;
  final List<ChallengeMilestone> milestones;
  final List<ChallengeParticipant> leaderboard;
  final List<ChallengeActivity> recentActivity;
  final int participantCount;
  final bool isParticipating;
  final int userProgress;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.icon,
    required this.color,
    required this.startDate,
    required this.endDate,
    required this.reward,
    required this.rewardDetails,
    required this.rules,
    required this.tips,
    required this.milestones,
    required this.leaderboard,
    required this.recentActivity,
    required this.participantCount,
    required this.isParticipating,
    required this.userProgress,
  });
}

class ChallengeMilestone {
  final String title;
  final String description;

  ChallengeMilestone({
    required this.title,
    required this.description,
  });
}

class ChallengeParticipant {
  final String id;
  final String name;
  final IconData avatar;
  final int milestonesCompleted;
  final int totalMilestones;
  final int points;
  final bool isCurrentUser;

  ChallengeParticipant({
    required this.id,
    required this.name,
    required this.avatar,
    required this.milestonesCompleted,
    required this.totalMilestones,
    required this.points,
    required this.isCurrentUser,
  });
}

enum ActivityType { milestone, joined }

class ChallengeActivity {
  final String description;
  final DateTime timestamp;
  final IconData avatar;
  final ActivityType activityType;

  ChallengeActivity({
    required this.description,
    required this.timestamp,
    required this.avatar,
    required this.activityType,
  });
}