import 'package:connect/data/models/local/last_seen.dart';
import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/data/models/remote/last_seen.dart';
import 'package:connect/modules/auth/views/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/local/user_data.dart';

class HiveService {
  // Private constructor
  HiveService._privateConstructor();

  // The static instance
  static final HiveService _instance = HiveService._privateConstructor();

  // Provide global access to the instance
  static HiveService get instance => _instance;

  // Box names
  final String _boxName = 'userBox';
  final String _roomBox = 'messageRoomBox';

  final String _inboxBox = 'inboxBox';

  final String _lastSeenBox = 'lasSeenBox';

  // Cached box references
  Box<UserHiveData>? _userBox;
  Box<MessageHiveData>? _roomBoxInstance;
  Box<MessageHiveData>? _inboxBoxInstance;

  Box<SeenMessage>? _lastSeenInstance;

  // Initialize Hive and open the box
  Future<void> boxInit() async {
    _userBox = await Hive.openBox<UserHiveData>(_boxName);
    _roomBoxInstance = await Hive.openBox<MessageHiveData>(_roomBox);
    _inboxBoxInstance = await Hive.openBox<MessageHiveData>(_inboxBox);
    _lastSeenInstance = await Hive.openBox<SeenMessage>(_lastSeenBox);
  }

  // Ensure this is called before using Hive
  Future<void> adapterInit() async {
    Hive.registerAdapter(UserHiveDataAdapter());
    Hive.registerAdapter(MessageHiveDataAdapter());
    Hive.registerAdapter(SeenMessageAdapter());
  }

  // Save user data
  Future<void> saveUserData(UserHiveData userData) async {
    var box = _userBox ??= await Hive.openBox<UserHiveData>(_boxName);
    await box.put('userData', userData);
    if (kDebugMode) {
      print("User data saved successfully");
    }
  }

  // Retrieve user data
  UserHiveData? getUserData() {
    var box = _userBox ?? Hive.box<UserHiveData>(_boxName);
    return box.get('userData');
  }

  UserHiveData? get userData => getUserData();

  // Delete user data
  Future<void> deleteUserData() async {
    var box = _userBox ??= await Hive.openBox<UserHiveData>(_boxName);
    await box.delete('userData');
  }

  Future<void> signOut() async {
    await deleteUserData();
    if (userData == null) {
      Get.offAll(const LoginPage());
    }
  }

  // Save message to room
  Future<void> saveMessageToRoom(MessageHiveData message) async {
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);
    await box.add(message);
    await saveOrUpdateInbox(message);

    if (kDebugMode) {
      print('Message saved successfully');
    }
  }

  // Get messages for a specific room (conversation)
  Future<List<MessageHiveData>> getMessagesForRoom(
      String senderId, String receiverId) async {
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);

    // Filter messages where either the sender or receiver matches the participants
    return box.values
        .where((message) =>
            (message.senderId == senderId &&
                message.recipientId == receiverId) ||
            (message.senderId == receiverId && message.recipientId == senderId))
        .toList();
  }

  // Save or update the latest message in the inbox
  Future<void> saveOrUpdateInbox(MessageHiveData message) async {
    var box =
        _inboxBoxInstance ??= await Hive.openBox<MessageHiveData>(_inboxBox);
    await box.put(message.senderId,
        message); // Use senderId as key for the latest message
  }

  // Retrieve all inbox messages, sorted by timestamp (newest first)
  Future<List<MessageHiveData>> getInboxMessages() async {
    var box =
        _inboxBoxInstance ??= await Hive.openBox<MessageHiveData>(_inboxBox);
    return box.values
        .where((message) =>
            message.senderId != (HiveService.instance.userData?.id ?? ''))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Update message properties (e.g., isSeen, isTyping, etc.)
  Future<void> updateMessageProperty({
    required String senderId,
    bool? isTyping,
    bool? isSeen,
    String? message,
  }) async {
    var box =
        _inboxBoxInstance ??= await Hive.openBox<MessageHiveData>(_inboxBox);

    MessageHiveData? existingMessage = box.get(senderId);

    if (existingMessage != null) {
      MessageHiveData updatedMessage = MessageHiveData(
        senderId: existingMessage.senderId,
        message: message ?? existingMessage.message,
        name: existingMessage.name,
        avater: existingMessage.avater,
        replyTo: existingMessage.replyTo,
        repliedMsgId: existingMessage.repliedMsgId,
        messageId: existingMessage.messageId,
        isSeen: isSeen ?? existingMessage.isSeen,
        isTyping: isTyping ?? existingMessage.isTyping,
        timestamp: existingMessage.timestamp, // Keep existing timestamp
      );

      await box.put(senderId, updatedMessage);
    }
  }

  // Count unseen messages from a specific sender in the inbox
  Future<List<MessageHiveData>> getAllUnseenMessages() async {
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);
    return box.values.where((message) => message.isSeen == false).toList();
  }

  // Update all unseen messages to be marked as seen

  Future<void> markMessagesAsSeenBySender(String senderId) async {
    // Open the Hive box
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);

    // Iterate through each message and update the isSeen property for the given senderId
    for (var key in box.keys) {
      var message = box.get(key);
      if (message != null && message.senderId == senderId && !message.isSeen) {
        message.isSeen = true; // Set isSeen to true for the specific senderId
        await box.put(key, message); // Update the message in the box
      }
    }
  }

  Future<void> markMessagesAsSeenBySenderAndRecipient(
      String senderId, String recipientId) async {
    // Open the Hive box
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);
    var data = box.keys.where((key) {
      var message = box.get(key);
      return (message?.recipientId == senderId) &&
          (message?.senderId == recipientId) &&
          (message?.isSeen == false);
    }).toList();

    // Iterate through each message and update the isSeen property for the given senderId
    for (var key in data) {
      var message = box.get(key);
      message?.isSeen = true; // Set isSeen to true
      // Update the box with the modified message
      await box.put(key, message!);
    }

    if (kDebugMode) {
      print("Messages have been updated.");
    }
  }

  Future<void> saveSeenMessage(LasSeenEntry data) async {
    var box =
        _lastSeenInstance ??= await Hive.openBox<SeenMessage>(_lastSeenBox);

    // Find if the senderId already exists
    final existingMessages = box.values.where(
      (message) => message.senderId == data.senderId,
    );

    if (existingMessages.isNotEmpty) {
      // If exists, update the seenAt field
      final existingMessage = existingMessages.first; // Get the first match
      final updatedMessage = SeenMessage(
        senderId: existingMessage.senderId,
        seenAt: data.seenAt,
      );
      await box.put(existingMessage.key,
          updatedMessage); // Use the key to update the message

      if (kDebugMode) {
        print('Updated existing message');
      }
    } else {
      // Otherwise, add a new entry
      final newMessage = SeenMessage(
        senderId: data.senderId,
        seenAt: data.seenAt,
      );
      await box.add(newMessage); // Add new message

      if (kDebugMode) {
        print('Added new message');
      }
    }
  }

  Future<List<SeenMessage>> getSeenMessages() async {
    // Ensure the box is opened
    var box =
        _lastSeenInstance ??= await Hive.openBox<SeenMessage>(_lastSeenBox);

    // Check if the box contains any values before retrieving
    if (box.isEmpty) {
      if (kDebugMode) {
        print('No seen messages found');
      }
      return []; // Return an empty list if no messages exist
    }
    // Return the list of SeenMessages
    return box.values.toList();
  }

  Future<void> removeMessage(String messageId) async {
    // Ensure the box is opened
    _roomBoxInstance ??= await Hive.openBox<MessageHiveData>('roomBox');

    // Find the existing message by its ID

    final messageIndex = _roomBoxInstance!.values
        .toList()
        .indexWhere((msg) => msg.messageId == messageId);
    if (messageIndex != -1) {
      await _roomBoxInstance!.deleteAt(messageIndex); // Remove the message
      print('Message deleted successfully: $messageId');
    } else {
      print('Message not found: $messageId');
    }
  }

  // Edit a message by ID
  Future<void> editMessageById(
      String messageId, String newContent, DateTime timestamp) async {
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);

    // Find the index of the existing message
    final existingIndex = box.values.toList().indexWhere(
          (message) => message.messageId == messageId,
        );

    if (existingIndex != -1) {
      // If exists, update the message
      final existingMessage = box.getAt(existingIndex);

      // Create a new MessageHiveData with updated content
      final updatedMessage = MessageHiveData(
        message: newContent,
        isTyping: existingMessage!.isTyping,
        isSeen: existingMessage.isSeen,
        senderId: existingMessage.senderId,
        replyTo: existingMessage.replyTo,
        repliedMsgId: existingMessage.repliedMsgId,
        recipientId: existingMessage.recipientId,
        avater: existingMessage.avater,
        timestamp: timestamp,
        name: existingMessage.name,
        messageId: messageId,
      );

      // Use the index to update the message in the box
      await box.putAt(existingIndex,
          updatedMessage); // Update the message at the found index

      if (kDebugMode) {
        print('Updated existing message');
      }
    } else {
      if (kDebugMode) {
        print('Message with ID $messageId not found for editing');
      }
    }
  }
}
