// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupTripAdapter extends TypeAdapter<GroupTrip> {
  @override
  final int typeId = 11;

  @override
  GroupTrip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupTrip(
      id: fields[0] as String,
      title: fields[1] as String,
      waypoints: (fields[3] as List).cast<Waypoint>(),
      createdAt: fields[4] as DateTime,
      coreType: fields[7] as CoreType,
      participantIds: (fields[20] as List).cast<String>(),
      creatorId: fields[21] as String,
      status: fields[22] as GroupTripStatus,
      userRoles: (fields[23] as Map).cast<String, UserRole>(),
      sharedScorecardId: fields[24] as String?,
      invitedAt: fields[25] as DateTime?,
      startedAt: fields[26] as DateTime?,
      subMode: fields[8] as String,
      completed: fields[5] as bool,
      badgeEarned: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GroupTrip obj) {
    writer
      ..writeByte(18)
      ..writeByte(20)
      ..write(obj.participantIds)
      ..writeByte(21)
      ..write(obj.creatorId)
      ..writeByte(22)
      ..write(obj.status)
      ..writeByte(23)
      ..write(obj.userRoles)
      ..writeByte(24)
      ..write(obj.sharedScorecardId)
      ..writeByte(25)
      ..write(obj.invitedAt)
      ..writeByte(26)
      ..write(obj.startedAt)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.oldType)
      ..writeByte(3)
      ..write(obj.waypoints)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.completed)
      ..writeByte(6)
      ..write(obj.badgeEarned)
      ..writeByte(7)
      ..write(obj.coreType)
      ..writeByte(8)
      ..write(obj.subMode)
      ..writeByte(9)
      ..write(obj.ruleSetId)
      ..writeByte(10)
      ..write(obj.isPathStrict);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupTripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroupTripStatusAdapter extends TypeAdapter<GroupTripStatus> {
  @override
  final int typeId = 9;

  @override
  GroupTripStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GroupTripStatus.planned;
      case 1:
        return GroupTripStatus.invited;
      case 2:
        return GroupTripStatus.active;
      case 3:
        return GroupTripStatus.completed;
      default:
        return GroupTripStatus.planned;
    }
  }

  @override
  void write(BinaryWriter writer, GroupTripStatus obj) {
    switch (obj) {
      case GroupTripStatus.planned:
        writer.writeByte(0);
        break;
      case GroupTripStatus.invited:
        writer.writeByte(1);
        break;
      case GroupTripStatus.active:
        writer.writeByte(2);
        break;
      case GroupTripStatus.completed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupTripStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 10;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.creator;
      case 1:
        return UserRole.participant;
      case 2:
        return UserRole.invited;
      case 3:
        return UserRole.spectator;
      default:
        return UserRole.creator;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.creator:
        writer.writeByte(0);
        break;
      case UserRole.participant:
        writer.writeByte(1);
        break;
      case UserRole.invited:
        writer.writeByte(2);
        break;
      case UserRole.spectator:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
