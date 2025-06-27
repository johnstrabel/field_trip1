// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infection_game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameActionAdapter extends TypeAdapter<GameAction> {
  @override
  final int typeId = 17;

  @override
  GameAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameAction(
      id: fields[0] as String,
      playerId: fields[1] as String,
      actionType: fields[2] as String,
      timestamp: fields[3] as DateTime,
      data: (fields[4] as Map).cast<String, dynamic>(),
      targetPlayerId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GameAction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playerId)
      ..writeByte(2)
      ..write(obj.actionType)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.targetPlayerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerStateAdapter extends TypeAdapter<PlayerState> {
  @override
  final int typeId = 18;

  @override
  PlayerState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerState(
      userId: fields[0] as String,
      displayName: fields[1] as String,
      role: fields[2] as PlayerRole,
      lastUpdate: fields[3] as DateTime?,
      latitude: fields[4] as double?,
      longitude: fields[5] as double?,
      actions: (fields[6] as List).cast<GameAction>(),
      isImmune: fields[7] as bool,
      immunityEndsAt: fields[8] as DateTime?,
      isFrozen: fields[9] as bool,
      freezeEndsAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerState obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.lastUpdate)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.actions)
      ..writeByte(7)
      ..write(obj.isImmune)
      ..writeByte(8)
      ..write(obj.immunityEndsAt)
      ..writeByte(9)
      ..write(obj.isFrozen)
      ..writeByte(10)
      ..write(obj.freezeEndsAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameBoundaryAdapter extends TypeAdapter<GameBoundary> {
  @override
  final int typeId = 19;

  @override
  GameBoundary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameBoundary(
      id: fields[0] as String,
      boundaryPoints: (fields[1] as List).cast<LatLng>(),
      radius: fields[2] as double?,
      type: fields[3] as String,
      center: fields[4] as LatLng,
    );
  }

  @override
  void write(BinaryWriter writer, GameBoundary obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.boundaryPoints)
      ..writeByte(2)
      ..write(obj.radius)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.center);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBoundaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LatLngAdapter extends TypeAdapter<LatLng> {
  @override
  final int typeId = 20;

  @override
  LatLng read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatLng(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LatLng obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLngAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameSessionAdapter extends TypeAdapter<GameSession> {
  @override
  final int typeId = 21;

  @override
  GameSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSession(
      id: fields[0] as String,
      name: fields[1] as String,
      mode: fields[2] as InfectionMode,
      players: (fields[3] as List).cast<PlayerState>(),
      createdAt: fields[4] as DateTime,
      startTime: fields[5] as DateTime?,
      endTime: fields[6] as DateTime?,
      gameDuration: fields[7] as Duration?,
      rules: (fields[8] as Map).cast<String, dynamic>(),
      boundary: fields[9] as GameBoundary?,
      status: fields[10] as GameStatus,
      creatorId: fields[11] as String,
      gameLog: (fields[12] as List).cast<GameAction>(),
    );
  }

  @override
  void write(BinaryWriter writer, GameSession obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mode)
      ..writeByte(3)
      ..write(obj.players)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.gameDuration)
      ..writeByte(8)
      ..write(obj.rules)
      ..writeByte(9)
      ..write(obj.boundary)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.creatorId)
      ..writeByte(12)
      ..write(obj.gameLog);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreEntryAdapter extends TypeAdapter<ScoreEntry> {
  @override
  final int typeId = 12;

  @override
  ScoreEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreEntry(
      playerId: fields[0] as String,
      playerName: fields[1] as String,
      scores: (fields[2] as Map).cast<String, dynamic>(),
      lastUpdated: fields[3] as DateTime,
      totalScore: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.playerId)
      ..writeByte(1)
      ..write(obj.playerName)
      ..writeByte(2)
      ..write(obj.scores)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.totalScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedScoreCardAdapter extends TypeAdapter<SharedScoreCard> {
  @override
  final int typeId = 13;

  @override
  SharedScoreCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedScoreCard(
      id: fields[0] as String,
      groupTripId: fields[1] as String,
      entries: (fields[2] as List).cast<ScoreEntry>(),
      createdAt: fields[3] as DateTime,
      lastUpdated: fields[4] as DateTime,
      isActive: fields[5] as bool,
      gameRules: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedScoreCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupTripId)
      ..writeByte(2)
      ..write(obj.entries)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.gameRules);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedScoreCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InfectionModeAdapter extends TypeAdapter<InfectionMode> {
  @override
  final int typeId = 14;

  @override
  InfectionMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InfectionMode.arena;
      case 1:
        return InfectionMode.freeForAll;
      case 2:
        return InfectionMode.crawl;
      default:
        return InfectionMode.arena;
    }
  }

  @override
  void write(BinaryWriter writer, InfectionMode obj) {
    switch (obj) {
      case InfectionMode.arena:
        writer.writeByte(0);
        break;
      case InfectionMode.freeForAll:
        writer.writeByte(1);
        break;
      case InfectionMode.crawl:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfectionModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerRoleAdapter extends TypeAdapter<PlayerRole> {
  @override
  final int typeId = 15;

  @override
  PlayerRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlayerRole.runner;
      case 1:
        return PlayerRole.infected;
      case 2:
        return PlayerRole.eliminated;
      default:
        return PlayerRole.runner;
    }
  }

  @override
  void write(BinaryWriter writer, PlayerRole obj) {
    switch (obj) {
      case PlayerRole.runner:
        writer.writeByte(0);
        break;
      case PlayerRole.infected:
        writer.writeByte(1);
        break;
      case PlayerRole.eliminated:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GameStatusAdapter extends TypeAdapter<GameStatus> {
  @override
  final int typeId = 16;

  @override
  GameStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameStatus.lobby;
      case 1:
        return GameStatus.starting;
      case 2:
        return GameStatus.active;
      case 3:
        return GameStatus.paused;
      case 4:
        return GameStatus.finished;
      default:
        return GameStatus.lobby;
    }
  }

  @override
  void write(BinaryWriter writer, GameStatus obj) {
    switch (obj) {
      case GameStatus.lobby:
        writer.writeByte(0);
        break;
      case GameStatus.starting:
        writer.writeByte(1);
        break;
      case GameStatus.active:
        writer.writeByte(2);
        break;
      case GameStatus.paused:
        writer.writeByte(3);
        break;
      case GameStatus.finished:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
