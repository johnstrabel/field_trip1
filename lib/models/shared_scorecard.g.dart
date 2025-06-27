// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_scorecard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      userId: fields[0] as String,
      waypointIndex: fields[1] as int,
      score: fields[2] as int,
      timestamp: fields[3] as DateTime,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScoreEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.waypointIndex)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.note);
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
      tripId: fields[1] as String,
      entries: (fields[2] as List).cast<ScoreEntry>(),
      allowEdit: fields[3] as bool,
      lastUpdated: fields[4] as DateTime,
      userTotals: (fields[5] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, SharedScoreCard obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.entries)
      ..writeByte(3)
      ..write(obj.allowEdit)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.userTotals);
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
