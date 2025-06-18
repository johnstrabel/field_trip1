// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrailPointAdapter extends TypeAdapter<TrailPoint> {
  @override
  final int typeId = 4;

  @override
  TrailPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailPoint(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      timestamp: fields[2] as DateTime,
      accuracy: fields[3] as double?,
      altitude: fields[4] as double?,
      speed: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, TrailPoint obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.accuracy)
      ..writeByte(4)
      ..write(obj.altitude)
      ..writeByte(5)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrailDataAdapter extends TypeAdapter<TrailData> {
  @override
  final int typeId = 5;

  @override
  TrailData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailData(
      tripId: fields[0] as String,
      points: (fields[1] as List).cast<TrailPoint>(),
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
      totalDistance: fields[4] as double,
      duration: fields[5] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, TrailData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tripId)
      ..writeByte(1)
      ..write(obj.points)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.totalDistance)
      ..writeByte(5)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
