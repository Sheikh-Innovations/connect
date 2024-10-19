// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_hive_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageHiveDataAdapter extends TypeAdapter<MessageHiveData> {
  @override
  final int typeId = 1;

  @override
  MessageHiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageHiveData(
      senderId: fields[0] as String,
      message: fields[1] as String,
      name: fields[2] as String,
      avater: fields[3] as String?,
      isSeen: fields[4] as bool,
      isTyping: fields[5] as bool,
      repliedMsgId: fields[9] as String,
      messageId: fields[8] as String,
      timestamp: fields[6] as DateTime,
      recipientId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageHiveData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.avater)
      ..writeByte(4)
      ..write(obj.isSeen)
      ..writeByte(5)
      ..write(obj.isTyping)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.recipientId)
      ..writeByte(8)
      ..write(obj.messageId)
      ..writeByte(9)
      ..write(obj.repliedMsgId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHiveDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
