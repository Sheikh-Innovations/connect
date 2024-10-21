import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/data/providers/hive_service.dart';

class MessageData {
  final String senderId;
  final String message;
  final String name;
  final String? avater;
  final bool isSeen;
  final bool isTyping;
  final String recipientId;
  final DateTime timestamp;
  final String repliedMsgId;
  final String messageId; // New field for _id

  MessageData({
    required this.senderId,
    required this.message,
    required this.name,
    this.avater,
    required this.isSeen,
    required this.isTyping,
    required this.repliedMsgId,
    required this.recipientId,
    required this.timestamp,
    required this.messageId, // Add _id to the constructor
  });

  // Factory constructor to convert from MessageHiveData to MessageData
  factory MessageData.fromMessageData(MessageHiveData messageData) {
    return MessageData(
      senderId: messageData.senderId,
      message: messageData.message,
      name: messageData.name,
      avater: messageData.avater,
      repliedMsgId: messageData.repliedMsgId,
      isSeen: messageData.isSeen,
      isTyping: messageData.isTyping,
      recipientId: messageData.recipientId,
      timestamp: messageData.timestamp,
      messageId: messageData.messageId, // Assign _id from Hive data
    );
  }

  // Factory method to convert from a Map to MessageData
  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      messageId: map['messageId'] as String,
      name: map['name'] as String,
      repliedMsgId: map['repliedMsgId'] as String,
      avater: map['avater'] as String?,
      isSeen: map['isSeen'] as bool,
      isTyping: map['isTyping'] as bool,
      recipientId:
          map['recipientId'] ?? HiveService.instance.userData?.id ?? '',
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
      'repliedMsgId': repliedMsgId,
      'recipientId': recipientId,
      'timestamp': timestamp.toIso8601String(),
      'messageId': messageId, // Add _id to JSON
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
      repliedMsgId : repliedMsgId,
      isTyping: isTyping,
      recipientId: recipientId,
      timestamp: timestamp,
      messageId: messageId, // Pass _id to Hive data
    );
  }


   // Add the copyWith method
  MessageData copyWith({
    String? senderId,
    String? message,
    String? name,
    String? avater,
    bool? isSeen,
    bool? isTyping,
    String? recipientId,
    DateTime? timestamp,
    String? repliedMsgId,
    String? messageId,
  }) {
    return MessageData(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      name: name ?? this.name,
      avater: avater ?? this.avater,
      isSeen: isSeen ?? this.isSeen,
      isTyping: isTyping ?? this.isTyping,
      recipientId: recipientId ?? this.recipientId,
      timestamp: timestamp ?? this.timestamp,
      repliedMsgId: repliedMsgId ?? this.repliedMsgId,
      messageId: messageId ?? this.messageId,
    );
  }
}
