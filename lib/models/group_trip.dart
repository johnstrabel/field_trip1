// lib/models/group_trip.dart
import 'package:hive/hive.dart';
import 'trip.dart';

part 'group_trip.g.dart';

@HiveType(typeId: 9)
enum GroupTripStatus {
  @HiveField(0)
  planned,
  @HiveField(1)
  invited,
  @HiveField(2)
  active,
  @HiveField(3)
  completed
}

@HiveType(typeId: 10)
enum UserRole {
  @HiveField(0)
  creator,
  @HiveField(1)
  participant,
  @HiveField(2)
  invited,
  @HiveField(3)
  spectator
}

@HiveType(typeId: 11)
class GroupTrip extends Trip {
  @HiveField(20)
  final List<String> participantIds;
  
  @HiveField(21)
  final String creatorId;
  
  @HiveField(22)
  final GroupTripStatus status;
  
  @HiveField(23)
  final Map<String, UserRole> userRoles;
  
  @HiveField(24)
  final String? sharedScorecardId;
  
  @HiveField(25)
  final DateTime? invitedAt;
  
  @HiveField(26)
  final DateTime? startedAt;

  GroupTrip({
    required String id,
    required String title,
    required List<Waypoint> waypoints,
    required DateTime createdAt,
    required CoreType coreType,
    required this.participantIds,
    required this.creatorId,
    required this.status,
    required this.userRoles,
    this.sharedScorecardId,
    this.invitedAt,
    this.startedAt,
    String? subMode,
    bool completed = false,
    bool badgeEarned = false,
  }) : super(
    id: id,
    title: title,
    waypoints: waypoints,
    createdAt: createdAt,
    coreType: coreType,
    subMode: subMode,
    completed: completed,
    badgeEarned: badgeEarned,
  );

  // Helper methods
  bool isUserParticipant(String userId) => participantIds.contains(userId);
  bool isUserCreator(String userId) => creatorId == userId;
  UserRole? getUserRole(String userId) => userRoles[userId];
  
  int get totalParticipants => participantIds.length;
  List<String> get invitedUsers => userRoles.entries
      .where((entry) => entry.value == UserRole.invited)
      .map((entry) => entry.key)
      .toList();
}