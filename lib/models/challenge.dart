// lib/models/challenge.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 22)
class Challenge {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String objective;

  @HiveField(4)
  final String iconCodePoint; // Store icon as int for Hive

  @HiveField(5)
  final int colorValue; // Store color as int for Hive

  @HiveField(6)
  final DateTime startDate;

  @HiveField(7)
  final DateTime endDate;

  @HiveField(8)
  final String reward;

  @HiveField(9)
  final String rewardDetails;

  @HiveField(10)
  final List<String> rules;

  @HiveField(11)
  final List<String> tips;

  @HiveField(12)
  final List<ChallengeMilestone> milestones;

  @HiveField(13)
  final int participantCount;

  @HiveField(14)
  final ChallengeType challengeType;

  @HiveField(15)
  final ChallengeStatus status;

  @HiveField(16)
  final String creatorId;

  @HiveField(17)
  final Map<String, int> userProgress; // userId -> milestones completed

  @HiveField(18)
  final List<String> participantIds;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.iconCodePoint,
    required this.colorValue,
    required this.startDate,
    required this.endDate,
    required this.reward,
    required this.rewardDetails,
    required this.rules,
    required this.tips,
    required this.milestones,
    required this.participantCount,
    required this.challengeType,
    required this.status,
    required this.creatorId,
    required this.userProgress,
    required this.participantIds,
  });

  // Helper getters for UI
  IconData get icon => IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);
  
  bool isParticipating(String userId) => participantIds.contains(userId);
  int getUserProgress(String userId) => userProgress[userId] ?? 0;
  
  // Progress calculation
  double getProgressPercentage(String userId) {
    if (milestones.isEmpty) return 0.0;
    return getUserProgress(userId) / milestones.length;
  }
}

@HiveType(typeId: 23)
enum ChallengeType {
  @HiveField(0)
  explore,    // Visit X places, explore Y areas
  @HiveField(1)
  crawl,      // Complete X bar visits, beer golf rounds
  @HiveField(2)
  sport,      // Fitness goals, sports achievements
  @HiveField(3)
  social,     // Group activities, friend challenges
  @HiveField(4)
  streak,     // Daily/weekly consistency challenges
  @HiveField(5)
  collection, // Badge collection, achievement hunting
}

@HiveType(typeId: 24)
enum ChallengeStatus {
  @HiveField(0)
  upcoming,   // Not started yet
  @HiveField(1)
  active,     // Currently running
  @HiveField(2)
  completed,  // Ended normally
  @HiveField(3)
  cancelled,  // Cancelled by creator
}

@HiveType(typeId: 25)
class ChallengeMilestone {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int order; // For sequential milestones

  @HiveField(4)
  final Map<String, dynamic> requirements; // Flexible requirements

  @HiveField(5)
  final int pointValue;

  @HiveField(6)
  final String iconCodePoint;

  ChallengeMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.requirements,
    required this.pointValue,
    required this.iconCodePoint,
  });

  IconData get icon => IconData(int.parse(iconCodePoint), fontFamily: 'MaterialIcons');
}

@HiveType(typeId: 26)
class ChallengeParticipant {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String avatarIconCodePoint;

  @HiveField(4)
  final int milestonesCompleted;

  @HiveField(5)
  final int totalPoints;

  @HiveField(6)
  final DateTime joinedAt;

  @HiveField(7)
  final DateTime? lastActivityAt;

  @HiveField(8)
  final int currentStreak;

  ChallengeParticipant({
    required this.userId,
    required this.name,
    required this.username,
    required this.avatarIconCodePoint,
    required this.milestonesCompleted,
    required this.totalPoints,
    required this.joinedAt,
    this.lastActivityAt,
    required this.currentStreak,
  });

  IconData get avatar => IconData(int.parse(avatarIconCodePoint), fontFamily: 'MaterialIcons');
  bool get isCurrentUser => userId == 'current_user'; // TODO: Replace with actual user ID
  
  // Calculate completion percentage
  double getCompletionPercentage(int totalMilestones) {
    if (totalMilestones == 0) return 0.0;
    return milestonesCompleted / totalMilestones;
  }
}

@HiveType(typeId: 27)
enum ActivityType {
  @HiveField(0)
  milestone,  // Completed a milestone
  @HiveField(1)
  joined,     // Joined the challenge
  @HiveField(2)
  left,       // Left the challenge
  @HiveField(3)
  achievement, // Special achievement
  @HiveField(4)
  streak,     // Streak milestone
}

@HiveType(typeId: 28)
class ChallengeActivity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String challengeId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final String avatarIconCodePoint;

  @HiveField(7)
  final ActivityType activityType;

  @HiveField(8)
  final Map<String, dynamic>? metadata; // Additional data

  ChallengeActivity({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.userName,
    required this.description,
    required this.timestamp,
    required this.avatarIconCodePoint,
    required this.activityType,
    this.metadata,
  });

  IconData get avatar => IconData(int.parse(avatarIconCodePoint), fontFamily: 'MaterialIcons');
}

// Helper class for challenge creation and management
class ChallengeHelper {
  // Predefined challenge templates
  static const Map<ChallengeType, List<Map<String, dynamic>>> templates = {
    ChallengeType.explore: [
      {
        'title': 'City Explorer',
        'description': 'Discover hidden gems in your city',
        'milestones': [
          {'title': 'First Steps', 'description': 'Complete your first explore trip'},
          {'title': 'Local Expert', 'description': 'Visit 5 different neighborhoods'},
          {'title': 'Urban Navigator', 'description': 'Complete 10 explore trips'},
        ]
      },
    ],
    ChallengeType.crawl: [
      {
        'title': 'Nightlife Champion',
        'description': 'Master the art of bar crawling',
        'milestones': [
          {'title': 'First Round', 'description': 'Complete your first bar crawl'},
          {'title': 'Beer Golf Pro', 'description': 'Complete 3 beer golf rounds'},
          {'title': 'Night Owl', 'description': 'Complete 5 crawl trips'},
        ]
      },
    ],
    ChallengeType.sport: [
      {
        'title': 'Fitness Warrior',
        'description': 'Push your physical limits',
        'milestones': [
          {'title': 'Getting Started', 'description': 'Complete your first sport trip'},
          {'title': 'Active Lifestyle', 'description': 'Complete 5 sport activities'},
          {'title': 'Athlete', 'description': 'Complete 15 sport activities'},
        ]
      },
    ],
  };

  // Create challenge from template
  static Challenge createFromTemplate(
    ChallengeType type,
    int templateIndex,
    String creatorId,
    DateTime startDate,
    DateTime endDate,
  ) {
    final template = templates[type]![templateIndex];
    final milestones = (template['milestones'] as List).asMap().entries.map((entry) {
      final index = entry.key;
      final milestone = entry.value;
      return ChallengeMilestone(
        id: 'milestone_${DateTime.now().millisecondsSinceEpoch}_$index',
        title: milestone['title'],
        description: milestone['description'],
        order: index,
        requirements: {},
        pointValue: (index + 1) * 100, // Increasing point values
        iconCodePoint: Icons.flag.codePoint.toString(),
      );
    }).toList();

    return Challenge(
      id: 'challenge_${DateTime.now().millisecondsSinceEpoch}',
      title: template['title'],
      description: template['description'],
      objective: template['description'],
      iconCodePoint: _getTypeIcon(type).codePoint.toString(),
      colorValue: _getTypeColor(type).value,
      startDate: startDate,
      endDate: endDate,
      reward: '${milestones.length * 100} points',
      rewardDetails: 'Earn points and badges for completing milestones',
      rules: _getDefaultRules(type),
      tips: _getDefaultTips(type),
      milestones: milestones,
      participantCount: 1,
      challengeType: type,
      status: ChallengeStatus.upcoming,
      creatorId: creatorId,
      userProgress: {creatorId: 0},
      participantIds: [creatorId],
    );
  }

  // Type-specific helpers
  static IconData _getTypeIcon(ChallengeType type) {
    switch (type) {
      case ChallengeType.explore:
        return Icons.explore;
      case ChallengeType.crawl:
        return Icons.local_bar;
      case ChallengeType.sport:
        return Icons.sports;
      case ChallengeType.social:
        return Icons.people;
      case ChallengeType.streak:
        return Icons.whatshot;
      case ChallengeType.collection:
        return Icons.emoji_events;
    }
  }

  static Color _getTypeColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.explore:
        return const Color(0xFF2196F3); // Blue
      case ChallengeType.crawl:
        return const Color(0xFFE91E63); // Pink/Crimson
      case ChallengeType.sport:
        return const Color(0xFFFFC107); // Amber
      case ChallengeType.social:
        return const Color(0xFF9C27B0); // Purple
      case ChallengeType.streak:
        return const Color(0xFFFF5722); // Deep Orange
      case ChallengeType.collection:
        return const Color(0xFF4CAF50); // Green
    }
  }

  static List<String> _getDefaultRules(ChallengeType type) {
    switch (type) {
      case ChallengeType.explore:
        return [
          'Complete trips in the explore category',
          'Each milestone must be completed in order',
          'GPS tracking must be enabled',
          'Photos encouraged for verification'
        ];
      case ChallengeType.crawl:
        return [
          'Complete bar crawls and related activities',
          'Drink responsibly',
          'Must visit all waypoints',
          'No driving under influence'
        ];
      case ChallengeType.sport:
        return [
          'Complete sport and fitness activities',
          'Follow safety guidelines',
          'Track your progress accurately',
          'Listen to your body'
        ];
      default:
        return [
          'Complete challenge milestones',
          'Follow community guidelines',
          'Be respectful to other participants'
        ];
    }
  }

  static List<String> _getDefaultTips(ChallengeType type) {
    switch (type) {
      case ChallengeType.explore:
        return [
          'Start with nearby locations to build momentum',
          'Use public transportation for longer trips',
          'Bring a portable charger for your phone',
          'Check weather conditions before heading out'
        ];
      case ChallengeType.crawl:
        return [
          'Plan your route using public transportation',
          'Eat before and during your crawl',
          'Stay hydrated with water between stops',
          'Set a reasonable budget beforehand'
        ];
      case ChallengeType.sport:
        return [
          'Start with easier activities and build up',
          'Warm up before intense activities',
          'Track your heart rate if possible',
          'Rest and recover between sessions'
        ];
      default:
        return [
          'Set realistic goals for yourself',
          'Celebrate small victories',
          'Stay consistent with your efforts'
        ];
    }
  }
}