// lib/models/trip.dart

import 'package:hive/hive.dart';

part 'trip.g.dart';

// NEW: CoreType enum with 3 types (Explore, Crawl, Sport)
@HiveType(typeId: 4)
enum CoreType {
  @HiveField(0)
  explore,   // Traditional exploration and sightseeing
  @HiveField(1)
  crawl,     // Nightlife: bars, beer golf, subway surfers, barcrawl
  @HiveField(2)
  sport      // All fitness, time trials, games (golf, frisbee golf), scorecards
  // NOTE: Removed 'active' and 'game' - now combined into 'sport'
}

// KEEP OLD: TripType enum for migration purposes
@HiveType(typeId: 0)
enum TripType {
  @HiveField(0)
  standard,
  @HiveField(1)
  challenge,
  @HiveField(2)
  barcrawl,
  @HiveField(3)
  fitness
}

@HiveType(typeId: 1)
class Waypoint {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String note;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  Waypoint({
    required this.name,
    required this.note,
    required this.latitude,
    required this.longitude,
  });
}

@HiveType(typeId: 2)
class Trip {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final TripType? oldType; // Keep for migration, make nullable

  @HiveField(3)
  final List<Waypoint> waypoints;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  bool badgeEarned;

  // NEW FIELDS
  @HiveField(7)
  final CoreType coreType;

  @HiveField(8)
  final String subMode; // e.g., 'beer_golf', 'time_trial', 'frisbee_golf'

  @HiveField(9)
  final String ruleSetId; // Links to RuleSet for scoring

  @HiveField(10)
  final bool isPathStrict; // Creator toggle for active races

  Trip({
    required this.id,
    required this.title,
    this.oldType, // Nullable for migration
    required this.waypoints,
    required this.createdAt,
    this.completed = false,
    this.badgeEarned = false,
    required this.coreType,
    this.subMode = 'standard',
    this.ruleSetId = 'default',
    this.isPathStrict = false,
  });

  // COMPATIBILITY: Constructor that works with old TripType
  Trip.fromOldType({
    required this.id,
    required this.title,
    required TripType type,
    required this.waypoints,
    required this.createdAt,
    this.completed = false,
    this.badgeEarned = false,
    this.subMode = 'standard',
    this.ruleSetId = 'default',
    this.isPathStrict = false,
  }) : oldType = type,
       coreType = _migrateTripTypeToCore(type);

  // Migration helper - convert old TripType to new CoreType (UPDATED FOR 3 TYPES)
  static CoreType _migrateTripTypeToCore(TripType oldType) {
    switch (oldType) {
      case TripType.standard:
        return CoreType.explore;
      case TripType.barcrawl:
        return CoreType.crawl;
      case TripType.fitness:
      case TripType.challenge: // Both fitness and challenge become 'sport'
        return CoreType.sport;
    }
  }

  // Helper to get the current type (prioritizes coreType over oldType)
  CoreType get currentType {
    return coreType;
  }

  // COMPATIBILITY: Get old type for existing code (UPDATED FOR 3 TYPES)
  TripType get type {
    if (oldType != null) return oldType!;
    // Convert new CoreType back to old TripType for compatibility
    switch (coreType) {
      case CoreType.explore:
        return TripType.standard;
      case CoreType.crawl:
        return TripType.barcrawl;
      case CoreType.sport:
        return TripType.fitness; // Default sport to fitness for compatibility
    }
  }
}

@HiveType(typeId: 3)
class Badge {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tripId;

  @HiveField(2)
  final String label;

  @HiveField(3)
  final DateTime earnedAt;

  @HiveField(4)
  final TripType? oldType; // Keep for migration

  // NEW FIELD
  @HiveField(5)
  final CoreType? coreType; // New type system

  Badge({
    required this.id,
    required this.tripId,
    required this.label,
    required this.earnedAt,
    this.oldType, // Nullable for migration
    this.coreType, // Nullable for migration
  });

  // COMPATIBILITY: Constructor that works with old TripType
  Badge.fromOldType({
    required this.id,
    required this.tripId,
    required this.label,
    required this.earnedAt,
    required TripType type,
  }) : oldType = type,
       coreType = Trip._migrateTripTypeToCore(type);

  // Helper to get current type
  CoreType get currentType {
    if (coreType != null) return coreType!;
    if (oldType != null) return Trip._migrateTripTypeToCore(oldType!);
    return CoreType.explore; // Default fallback
  }

  // COMPATIBILITY: Get old type for existing code (UPDATED FOR 3 TYPES)
  TripType get type {
    if (oldType != null) return oldType!;
    // Convert new CoreType back to old TripType for compatibility
    switch (currentType) {
      case CoreType.explore:
        return TripType.standard;
      case CoreType.crawl:
        return TripType.barcrawl;
      case CoreType.sport:
        return TripType.fitness; // Default sport to fitness for compatibility
    }
  }
}

// NEW: ScoreCard model for competitive modes (especially Sport type)
@HiveType(typeId: 5)
class ScoreCard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tripId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final List<int> perWaypointScores;

  @HiveField(4)
  final int totalScore;

  @HiveField(5)
  final List<String> penalties;

  @HiveField(6)
  final List<String> bonuses;

  @HiveField(7)
  final DateTime createdAt;

  ScoreCard({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.perWaypointScores,
    required this.totalScore,
    required this.penalties,
    required this.bonuses,
    required this.createdAt,
  });
}