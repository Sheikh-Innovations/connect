import 'package:connect/data/models/local/message_hive_data.dart';
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

  // Cached box references
  Box<UserHiveData>? _userBox;
  Box<MessageHiveData>? _roomBoxInstance;
  Box<MessageHiveData>? _inboxBoxInstance;

  // Initialize Hive and open the box
  Future<void> boxInit() async {
    _userBox = await Hive.openBox<UserHiveData>(_boxName);
    _roomBoxInstance = await Hive.openBox<MessageHiveData>(_roomBox);
    _inboxBoxInstance = await Hive.openBox<MessageHiveData>(_inboxBox);
  }

  // Ensure this is called before using Hive
  Future<void> adapterInit() async {
    Hive.registerAdapter(UserHiveDataAdapter());
    Hive.registerAdapter(MessageHiveDataAdapter());
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

  Future<void> markAllMessagesAsSeen() async {
    // Open the Hive box
    var box =
        _roomBoxInstance ??= await Hive.openBox<MessageHiveData>(_roomBox);
    // Iterate through each message and update the isSeen property
    for (var key in box.keys) {
      var message = box.get(key);
      if (message != null && !message.isSeen) {
        message.isSeen = true; // Set isSeen to true
        await box.put(key, message); // Update the message in the box
      }
    }
  }
}
