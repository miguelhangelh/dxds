// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkpoints_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckPointsLocalAdapter extends TypeAdapter<CheckPointsLocal> {
  @override
  final int typeId = 25;

  @override
  CheckPointsLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckPointsLocal(
      checkPointId: fields[0] as String?,
      dateTime: fields[1] as String?,
      loadingOrderId: fields[2] as String?,
      transportUnitId: fields[3] as String?,
      lat: fields[5] as double?,
      lng: fields[6] as double?,
      exit: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckPointsLocal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.checkPointId)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.loadingOrderId)
      ..writeByte(3)
      ..write(obj.transportUnitId)
      ..writeByte(4)
      ..write(obj.exit)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckPointsLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
