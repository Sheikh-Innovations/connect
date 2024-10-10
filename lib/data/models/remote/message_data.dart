import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/data/providers/hive_service.dart';

class MessageData {
  final String senderId;
  final String message;
  final String name;
  final String? avater;
  final bool isSeen;
  final bool isTyping;
  final String recipientId; // New field for recipientId
  final DateTime timestamp;

  MessageData({
    required this.senderId,
    required this.message,
    required this.name,
    this.avater,
    required this.isSeen,
    required this.isTyping,
    required this.recipientId, // Add recipientId to the constructor
    required this.timestamp,
  });

  // Factory constructor to convert from MessageHiveData to MessageData
  factory MessageData.fromMessageData(MessageHiveData messageData) {
    return MessageData(
      senderId: messageData.senderId,
      message: messageData.message,
      name: messageData.name,
      avater: messageData.avater,
      isSeen: messageData.isSeen,
      isTyping: messageData.isTyping,
      recipientId: messageData.recipientId, // Assign recipientId
      timestamp: messageData.timestamp,
    );
  }

  // Factory method to convert from a Map to MessageData
  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      name: map['name'] as String,
      avater: map['avater'] as String?,
      isSeen: map['isSeen'] as bool,
      isTyping: map['isTyping'] as bool,
      recipientId: map['recipientId'] ?? HiveService.instance.userData?.id??'', // Map recipientId
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  // Convert MessageData to Map (for JSON-like structure)
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'message': message,
      'name': name,
      'avater': avater,
      'isSeen': isSeen,
      'isTyping': isTyping,
      'recipientId': recipientId, // Add recipientId to JSON
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Method to convert MessageData to MessageHiveData (Hive)
  MessageHiveData toHiveData() {
    return MessageHiveData(
      senderId: senderId,
      message: message,
      name: name,
      avater: avater,
      isSeen: isSeen,
      isTyping: isTyping,
      recipientId: recipientId, // Add recipientId to Hive data
      timestamp: timestamp,
    );
  }
}
