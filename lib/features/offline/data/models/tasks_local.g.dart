// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskLocalAdapter extends TypeAdapter<TaskLocal> {
  @override
  final int typeId = 10;

  @override
  TaskLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskLocal(
      id: fields[0] as String?,
      taskId: fields[1] as String?,
      name: fields[2] as String?,
      changeStage: fields[3] as bool?,
      order: fields[4] as int?,
      viewCarrier: fields[5] as bool?,
      viewClient: fields[6] as bool?,
      allowFiles: fields[7] as bool?,
      pushNotification: fields[8] as bool?,
      emailNotification: fields[9] as bool?,
      smsNotification: fields[10] as bool?,
      state: fields[11] as int?,
      contentType: fields[12] as String?,
      dateRealized: fields[13] as String?,
      loadingOrderId: fields[14] as String?,
      idStage: fields[16] as String?,
      file: (fields[15] as List).cast<String>(),
      allowOperator: fields[17] as bool?,
      allowCarrier: fields[18] as bool?,
      allowClient: fields[19] as bool?,
      validationOperator: fields[20] as bool?,
      validationCarrier: fields[21] as bool?,
      validationClient: fields[22] as bool?,
      dateAction: fields[23] as String?,
      dateValidation: fields[24] as String?,
      approve: fields[26] as bool?,
      ifValidation: fields[25] as bool?,
      comment: fields[27] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskLocal obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.changeStage)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.viewCarrier)
      ..writeByte(6)
      ..write(obj.viewClient)
      ..writeByte(7)
      ..write(obj.allowFiles)
      ..writeByte(8)
      ..write(obj.pushNotification)
      ..writeByte(9)
      ..write(obj.emailNotification)
      ..writeByte(10)
      ..write(obj.smsNotification)
      ..writeByte(11)
      ..write(obj.state)
      ..writeByte(12)
      ..write(obj.contentType)
      ..writeByte(13)
      ..write(obj.dateRealized)
      ..writeByte(14)
      ..write(obj.loadingOrderId)
      ..writeByte(15)
      ..write(obj.file)
      ..writeByte(16)
      ..write(obj.idStage)
      ..writeByte(17)
      ..write(obj.allowOperator)
      ..writeByte(18)
      ..write(obj.allowCarrier)
      ..writeByte(19)
      ..write(obj.allowClient)
      ..writeByte(20)
      ..write(obj.validationOperator)
      ..writeByte(21)
      ..write(obj.validationCarrier)
      ..writeByte(22)
      ..write(obj.validationClient)
      ..writeByte(23)
      ..write(obj.dateAction)
      ..writeByte(24)
      ..write(obj.dateValidation)
      ..writeByte(25)
      ..write(obj.ifValidation)
      ..writeByte(26)
      ..write(obj.approve)
      ..writeByte(27)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
