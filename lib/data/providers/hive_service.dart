import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/modules/auth/views/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/local/user_data.dart';
// Assuming your UserData model is here

class HiveService {
  // Private constructor
  HiveService._privateConstructor();

  // The static instance
  static final HiveService _instance = HiveService._privateConstructor();

  // Provide global access to the instance
  static HiveService get instance => _instance;

  // Box name
  final String _boxName = 'userBox';
  final String _roomBox = 'messageRoomBox';
  final String _inboxBox = 'inboxBox';

  // Initialize Hive and open the box
  Future<void> boxInit() async {
    await Hive.openBox<UserHiveData>(_boxName);
    await Hive.openBox<MessageHiveData>(_roomBox);
    await Hive.openBox<MessageHiveData>(_inboxBox);
  }

// Ensure this is called before using Hive
  Future<void> adapterInit() async {
    Hive.registerAdapter(UserHiveDataAdapter());
    Hive.registerAdapter(MessageHiveDataAdapter());
  }

  // Save user data
  Future<void> saveUserData(UserHiveData userData) async {
    var box = Hive.box<UserHiveData>(_boxName);
    await box.put('userData', userData);
    if (kDebugMode) {
      print("Data saved successfully");
    }
  }

  // Retrieve user data
  UserHiveData? getUserData() {
    var box = Hive.box<UserHiveData>(_boxName);
    return box.get('userData');
  }

  UserHiveData? get userData {
    // Return cached data if available, otherwise fetch from Hive
    return getUserData();
  }

  // Delete user data
  Future<void> deleteUserData() async {
    var box = Hive.box<UserHiveData>(_boxName);
    await box.delete('userData');
  }

  Future<void> signOut() async {
    deleteUserData();
    if (userData == null) {
      Get.offAll(const LoginPage());
    }
  }

  Future<void> saveMessageToRoom(MessageHiveData message) async {
    var box = Hive.box<MessageHiveData>(_roomBox);
    await box.add(message);

    saveOrUpdateInbox(message);
    if (kDebugMode) {
      print('save successfully');
    }
    // Add the new message to the room
  }

  Future<List<MessageHiveData>> getMessagesForRoom(
      String senderId, String receiverId) async {
    var box = await Hive.openBox<MessageHiveData>(_roomBox);

    // Filter messages where either the sender or receiver matches the participants
    return box.values
        .where((message) =>
            (message.senderId == senderId &&
                message.recipientId == receiverId) ||
            (message.senderId == receiverId && message.recipientId == senderId))
        .toList();
  }

//for inbox
  Future<void> saveOrUpdateInbox(MessageHiveData message) async {
    var box = Hive.box<MessageHiveData>(_inboxBox);
    await box.put(message.senderId,
        message); // Use senderId as the key to update the latest message
  }

  Future<List<MessageHiveData>> getInboxMessages() async {
    var box = await Hive.openBox<MessageHiveData>(_inboxBox);

    // Filter messages and sort them by timestamp (newest first)
    return box.values
        .where((message) =>
            message.senderId != (HiveService.instance.userData?.id ?? ''))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp
  }

  Future<void> updateMessageProperty({
    required String senderId,
    bool? isTyping,
    bool? isSeen,
    String? message,
  }) async {
    var box = await Hive.openBox<MessageHiveData>(_inboxBox);

    // Retrieve the message using senderId
    MessageHiveData? existingMessage = box.get(senderId);

    if (existingMessage != null) {
      // Create a new message with the updated properties
      MessageHiveData updatedMessage = MessageHiveData(
        senderId: existingMessage.senderId,
        message: message ?? existingMessage.message,
        name: existingMessage.name,
        avater: existingMessage.avater,
        isSeen: isSeen ?? existingMessage.isSeen, // Update only if provided
        isTyping:
            isTyping ?? existingMessage.isTyping, // Update only if provided
        timestamp: DateTime.now(), // Keep the existing timestamp
      );

      // Update the message in the inbox
      await box.put(senderId, updatedMessage);
    }
  }
}
