import 'package:connect/data/providers/hive_service.dart';
import 'package:hive/hive.dart';

part 'message_hive_data.g.dart'; // This file will be generated by Hive using `build_runner`

@HiveType(typeId: 1)
class MessageHiveData {
  @HiveField(0)
  final String senderId;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? avater;

  @HiveField(4)
  final bool isSeen;

  @HiveField(5)
  final bool isTyping;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7) // Add this line for recipientId
  final String recipientId; // New field for recipientId

  MessageHiveData({
    required this.senderId,
    required this.message,
    required this.name,
    this.avater,
    required this.isSeen,
    required this.isTyping,
    required this.timestamp,
    String? recipientId, // Change this line
  }) : recipientId = recipientId ?? HiveService.instance.userData?.id ?? ''; // Default value
}

//flutter packages pub run build_runner build