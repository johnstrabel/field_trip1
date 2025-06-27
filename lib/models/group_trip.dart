// lib/models/group_trip.dart - FIXED VERSION

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
    required super.id,           // FIXED: Use super parameters
    required super.title,        // FIXED: Use super parameters
    required super.waypoints,    // FIXED: Use super parameters
    required super.createdAt,    // FIXED: Use super parameters
    required super.coreType,     // FIXED: Use super parameters
    required this.participantIds,
    required this.creatorId,
    required this.status,
    required this.userRoles,
    this.sharedScorecardId,
    this.invitedAt,
    this.startedAt,
    super.subMode,               // FIXED: Use super parameters
    super.completed = false,     // FIXED: Use super parameters
    super.badgeEarned = false,   // FIXED: Use super parameters
  });

  // Helper methods
  bool isUserParticipant(String userId) => participantIds.contains(userId);
  bool isUserCreator(String userId) => creatorId == userId;
  UserRole? getUserRole(String userId) => userRoles[userId];
  
  int get totalParticipants => participantIds.length;
  List<String> get invitedUsers => userRoles.entries
      .where((entry) => entry.value == UserRole.invited)
      .map((entry) => entry.key)
      .toList();
      
  List<String> get activeParticipants => userRoles.entries
      .where((entry) => entry.value == UserRole.participant)
      .map((entry) => entry.key)
      .toList();
      
  bool get canStart => activeParticipants.length >= 2 && status == GroupTripStatus.planned;
  
  bool get isActive => status == GroupTripStatus.active;
  bool get isCompleted => status == GroupTripStatus.completed;
  
  // Create a copy with updated status
  GroupTrip copyWith({
    String? id,
    String? title,
    List<Waypoint>? waypoints,
    DateTime? createdAt,
    CoreType? coreType,
    List<String>? participantIds,
    String? creatorId,
    GroupTripStatus? status,
    Map<String, UserRole>? userRoles,
    String? sharedScorecardId,
    DateTime? invitedAt,
    DateTime? startedAt,
    String? subMode,
    bool? completed,
    bool? badgeEarned,
  }) {
    return GroupTrip(
      id: id ?? this.id,
      title: title ?? this.title,
      waypoints: waypoints ?? this.waypoints,
      createdAt: createdAt ?? this.createdAt,
      coreType: coreType ?? this.coreType,
      participantIds: participantIds ?? this.participantIds,
      creatorId: creatorId ?? this.creatorId,
      status: status ?? this.status,
      userRoles: userRoles ?? this.userRoles,
      sharedScorecardId: sharedScorecardId ?? this.sharedScorecardId,
      invitedAt: invitedAt ?? this.invitedAt,
      startedAt: startedAt ?? this.startedAt,
      subMode: subMode ?? this.subMode,
      completed: completed ?? this.completed,
      badgeEarned: badgeEarned ?? this.badgeEarned,
    );
  }
}
