// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaypointAdapter extends TypeAdapter<Waypoint> {
  @override
  final int typeId = 1;

  @override
  Waypoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Waypoint(
      name: fields[0] as String,
      note: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Waypoint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaypointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 2;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      title: fields[1] as String,
      oldType: fields[2] as TripType?,
      waypoints: (fields[3] as List).cast<Waypoint>(),
      createdAt: fields[4] as DateTime,
      completed: fields[5] as bool,
      badgeEarned: fields[6] as bool,
      coreType: fields[7] as CoreType,
      subMode: fields[8] as String,
      ruleSetId: fields[9] as String,
      isPathStrict: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(11)
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
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BadgeAdapter extends TypeAdapter<Badge> {
  @override
  final int typeId = 3;

  @override
  Badge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Badge(
      id: fields[0] as String,
      tripId: fields[1] as String,
      label: fields[2] as String,
      earnedAt: fields[3] as DateTime,
      oldType: fields[4] as TripType?,
      coreType: fields[5] as CoreType?,
    );
  }

  @override
  void write(BinaryWriter writer, Badge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.earnedAt)
      ..writeByte(4)
      ..write(obj.oldType)
      ..writeByte(5)
      ..write(obj.coreType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScoreCardAdapter extends TypeAdapter<ScoreCard> {
  @override
  final int typeId = 5;

  @override
  ScoreCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreCard(
      id: fields[0] as String,
      tripId: fields[1] as String,
      userId: fields[2] as String,
      perWaypointScores: (fields[3] as List).cast<int>(),
      totalScore: fields[4] as int,
      penalties: (fields[5] as List).cast<String>(),
      bonuses: (fields[6] as List).cast<String>(),
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.perWaypointScores)
      ..writeByte(4)
      ..write(obj.totalScore)
      ..writeByte(5)
      ..write(obj.penalties)
      ..writeByte(6)
      ..write(obj.bonuses)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CoreTypeAdapter extends TypeAdapter<CoreType> {
  @override
  final int typeId = 4;

  @override
  CoreType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CoreType.explore;
      case 1:
        return CoreType.crawl;
      case 2:
        return CoreType.active;
      case 3:
        return CoreType.game;
      default:
        return CoreType.explore;
    }
  }

  @override
  void write(BinaryWriter writer, CoreType obj) {
    switch (obj) {
      case CoreType.explore:
        writer.writeByte(0);
        break;
      case CoreType.crawl:
        writer.writeByte(1);
        break;
      case CoreType.active:
        writer.writeByte(2);
        break;
      case CoreType.game:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripTypeAdapter extends TypeAdapter<TripType> {
  @override
  final int typeId = 0;

  @override
  TripType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TripType.standard;
      case 1:
        return TripType.challenge;
      case 2:
        return TripType.barcrawl;
      case 3:
        return TripType.fitness;
      default:
        return TripType.standard;
    }
  }

  @override
  void write(BinaryWriter writer, TripType obj) {
    switch (obj) {
      case TripType.standard:
        writer.writeByte(0);
        break;
      case TripType.challenge:
        writer.writeByte(1);
        break;
      case TripType.barcrawl:
        writer.writeByte(2);
        break;
      case TripType.fitness:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
