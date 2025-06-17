// lib/models/trip.dart

import 'package:hive/hive.dart';

part 'trip.g.dart';

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
  final TripType type;

  @HiveField(3)
  final List<Waypoint> waypoints;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  bool completed;

  @HiveField(6)
  bool badgeEarned;

  Trip({
    required this.id,
    required this.title,
    required this.type,
    required this.waypoints,
    required this.createdAt,
    this.completed = false,
    this.badgeEarned = false,
  });
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
  final TripType type;

  Badge({
    required this.id,
    required this.tripId,
    required this.label,
    required this.earnedAt,
    required this.type,
  });
}