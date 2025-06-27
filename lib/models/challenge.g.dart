// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 22;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      objective: fields[3] as String,
      iconCodePoint: fields[4] as String,
      colorValue: fields[5] as int,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
      reward: fields[8] as String,
      rewardDetails: fields[9] as String,
      rules: (fields[10] as List).cast<String>(),
      tips: (fields[11] as List).cast<String>(),
      milestones: (fields[12] as List).cast<ChallengeMilestone>(),
      participantCount: fields[13] as int,
      challengeType: fields[14] as ChallengeType,
      status: fields[15] as ChallengeStatus,
      creatorId: fields[16] as String,
      userProgress: (fields[17] as Map).cast<String, int>(),
      participantIds: (fields[18] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.objective)
      ..writeByte(4)
      ..write(obj.iconCodePoint)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.reward)
      ..writeByte(9)
      ..write(obj.rewardDetails)
      ..writeByte(10)
      ..write(obj.rules)
      ..writeByte(11)
      ..write(obj.tips)
      ..writeByte(12)
      ..write(obj.milestones)
      ..writeByte(13)
      ..write(obj.participantCount)
      ..writeByte(14)
      ..write(obj.challengeType)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.creatorId)
      ..writeByte(17)
      ..write(obj.userProgress)
      ..writeByte(18)
      ..write(obj.participantIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeMilestoneAdapter extends TypeAdapter<ChallengeMilestone> {
  @override
  final int typeId = 25;

  @override
  ChallengeMilestone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeMilestone(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      order: fields[3] as int,
      requirements: (fields[4] as Map).cast<String, dynamic>(),
      pointValue: fields[5] as int,
      iconCodePoint: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeMilestone obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.requirements)
      ..writeByte(5)
      ..write(obj.pointValue)
      ..writeByte(6)
      ..write(obj.iconCodePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeMilestoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeParticipantAdapter extends TypeAdapter<ChallengeParticipant> {
  @override
  final int typeId = 26;

  @override
  ChallengeParticipant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeParticipant(
      userId: fields[0] as String,
      name: fields[1] as String,
      username: fields[2] as String,
      avatarIconCodePoint: fields[3] as String,
      milestonesCompleted: fields[4] as int,
      totalPoints: fields[5] as int,
      joinedAt: fields[6] as DateTime,
      lastActivityAt: fields[7] as DateTime?,
      currentStreak: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeParticipant obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.avatarIconCodePoint)
      ..writeByte(4)
      ..write(obj.milestonesCompleted)
      ..writeByte(5)
      ..write(obj.totalPoints)
      ..writeByte(6)
      ..write(obj.joinedAt)
      ..writeByte(7)
      ..write(obj.lastActivityAt)
      ..writeByte(8)
      ..write(obj.currentStreak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeActivityAdapter extends TypeAdapter<ChallengeActivity> {
  @override
  final int typeId = 28;

  @override
  ChallengeActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeActivity(
      id: fields[0] as String,
      challengeId: fields[1] as String,
      userId: fields[2] as String,
      userName: fields[3] as String,
      description: fields[4] as String,
      timestamp: fields[5] as DateTime,
      avatarIconCodePoint: fields[6] as String,
      activityType: fields[7] as ActivityType,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeActivity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.challengeId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.avatarIconCodePoint)
      ..writeByte(7)
      ..write(obj.activityType)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeTypeAdapter extends TypeAdapter<ChallengeType> {
  @override
  final int typeId = 23;

  @override
  ChallengeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeType.explore;
      case 1:
        return ChallengeType.crawl;
      case 2:
        return ChallengeType.sport;
      case 3:
        return ChallengeType.social;
      case 4:
        return ChallengeType.streak;
      case 5:
        return ChallengeType.collection;
      default:
        return ChallengeType.explore;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeType obj) {
    switch (obj) {
      case ChallengeType.explore:
        writer.writeByte(0);
        break;
      case ChallengeType.crawl:
        writer.writeByte(1);
        break;
      case ChallengeType.sport:
        writer.writeByte(2);
        break;
      case ChallengeType.social:
        writer.writeByte(3);
        break;
      case ChallengeType.streak:
        writer.writeByte(4);
        break;
      case ChallengeType.collection:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChallengeStatusAdapter extends TypeAdapter<ChallengeStatus> {
  @override
  final int typeId = 24;

  @override
  ChallengeStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChallengeStatus.upcoming;
      case 1:
        return ChallengeStatus.active;
      case 2:
        return ChallengeStatus.completed;
      case 3:
        return ChallengeStatus.cancelled;
      default:
        return ChallengeStatus.upcoming;
    }
  }

  @override
  void write(BinaryWriter writer, ChallengeStatus obj) {
    switch (obj) {
      case ChallengeStatus.upcoming:
        writer.writeByte(0);
        break;
      case ChallengeStatus.active:
        writer.writeByte(1);
        break;
      case ChallengeStatus.completed:
        writer.writeByte(2);
        break;
      case ChallengeStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 27;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.milestone;
      case 1:
        return ActivityType.joined;
      case 2:
        return ActivityType.left;
      case 3:
        return ActivityType.achievement;
      case 4:
        return ActivityType.streak;
      default:
        return ActivityType.milestone;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.milestone:
        writer.writeByte(0);
        break;
      case ActivityType.joined:
        writer.writeByte(1);
        break;
      case ActivityType.left:
        writer.writeByte(2);
        break;
      case ActivityType.achievement:
        writer.writeByte(3);
        break;
      case ActivityType.streak:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
