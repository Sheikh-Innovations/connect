// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_seen.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeenMessageAdapter extends TypeAdapter<SeenMessage> {
  @override
  final int typeId = 2;

  @override
  SeenMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeenMessage(
      senderId: fields[0] as String,
      seenAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SeenMessage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.seenAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeenMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
