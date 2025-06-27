// lib/models/shared_scorecard.dart
import 'package:hive/hive.dart';

part 'shared_scorecard.g.dart';

@HiveType(typeId: 12)
class ScoreEntry {
  @HiveField(0)
  final String userId;
  
  @HiveField(1)
  final int waypointIndex;
  
  @HiveField(2)
  final int score;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final String? note;

  ScoreEntry({
    required this.userId,
    required this.waypointIndex,
    required this.score,
    required this.timestamp,
    this.note,
  });
}

@HiveType(typeId: 13)
class SharedScoreCard {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String tripId;
  
  @HiveField(2)
  final List<ScoreEntry> entries;
  
  @HiveField(3)
  final bool allowEdit;
  
  @HiveField(4)
  final DateTime lastUpdated;
  
  @HiveField(5)
  final Map<String, int> userTotals;

  SharedScoreCard({
    required this.id,
    required this.tripId,
    required this.entries,
    required this.allowEdit,
    required this.lastUpdated,
    required this.userTotals,
  });

  // Calculate totals for each user
  Map<String, int> calculateUserTotals() {
    final totals = <String, int>{};
    for (final entry in entries) {
      totals[entry.userId] = (totals[entry.userId] ?? 0) + entry.score;
    }
    return totals;
  }

  // Get entries for a specific user
  List<ScoreEntry> getEntriesForUser(String userId) {
    return entries.where((entry) => entry.userId == userId).toList();
  }

  // Get leaderboard sorted by total score
  List<MapEntry<String, int>> getLeaderboard() {
    return userTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }
}
