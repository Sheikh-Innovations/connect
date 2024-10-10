// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveDataAdapter extends TypeAdapter<UserHiveData> {
  @override
  final int typeId = 0;

  @override
  UserHiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveData(
      id: fields[0] as String,
      name: fields[1] as String?,
      number: fields[2] as String,
      avater: fields[3] as String?,
      fcmToken: fields[4] as String,
      token: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.avater)
      ..writeByte(4)
      ..write(obj.fcmToken)
      ..writeByte(5)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
