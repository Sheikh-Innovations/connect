import 'dart:convert';
import 'dart:math';

import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/data/models/remote/message_data.dart';
import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/utils/consts/api_const.dart';
import 'package:connect/utils/consts/asset_const.dart';
import 'package:connect/utils/notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

class HomeController extends GetxController implements GetxService {
  var searchText = ''.obs; // Observable search text
  var inboxMessages = <MessageData>[].obs; // Observable for messages

  var roomMessages = <MessageData>[].obs;
  var unReadMessages = <MessageData>[].obs;
  var availReceiveSoundId = ''.obs;
  late AudioPlayer _audioPlayer;
  late io.Socket socket;
  var senderIds = [].obs;

  var onlineUsers = [].obs;

  var isTyping = <String>[].obs; // List to store typing users (observable)

  Future<void> getInbox() async {
    try {
      var data = await HiveService.instance.getInboxMessages();
      inboxMessages.value = data.map((message) {
        senderIds.add(message.senderId);

        return MessageData.fromMessageData(message);
      }).toList();
      getUnreadMessage();
      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching inbox messages: $e');
      }
    }
  }

  getUnreadMessage() async {
    var data = await HiveService.instance.getAllUnseenMessages();
    unReadMessages.value = data.map((message) {
      print(message.isSeen);

      return MessageData.fromMessageData(message);
    }).toList();

    update();
  }

  int getUnreadCount(String senderId) {
    // Filter unread messages based on senderId
    return unReadMessages
        .where((message) => message.senderId == senderId && !message.isSeen)
        .length;
  }

  Future<void> saveMessages(MessageHiveData message) async {
    try {
      await HiveService.instance.saveMessageToRoom(message);
      roomMessages.add(MessageData(
          senderId: message.senderId,
          message: message.message,
          name: message.name,
          messageId: message.messageId,
          repliedMsgId: message.repliedMsgId,
          recipientId: message.recipientId,
          isSeen: message.isSeen,
          isTyping: message.isTyping,
          timestamp: DateTime.now()));
      getInbox();
      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching inbox messages: $e');
      }
    }
  }

  Future<void> getRoomMessage(String senderId) async {
    try {
      var data = await HiveService.instance.getMessagesForRoom(
          senderId, HiveService.instance.userData?.id ?? '');
      roomMessages.value = data.map((message) {
        return MessageData.fromMessageData(message);
      }).toList();

      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching room messages: $e');
      }
    }
  }

  Future<void> connectSocket() async {
    final options = io.OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders(
            {'Authorization': 'Bearer ${HiveService.instance.userData?.token}'})
        .enableForceNew()
        .build();

    socket = io.io(ApiConst.socketbaseUrl, options);
    socket.onConnect((data) {
      requestOnline();
      if (kDebugMode) {
        print('Connected to Socket');
      }
      // You can handle any initial actions upon connection here
    });

    socket.on('message', (data) {
      print('Received message from WebSocket: ${data}');
      final receivedData = MessageData.fromMap(data);

      saveMessages(receivedData.toHiveData());
      playReceiveMsgSound(receivedData.senderId, receivedData);

      if (kDebugMode) {
        print('Received message from WebSocket: ${receivedData.message}');
      }
      // Handle the received message as needed
    });

    // Listen for 'typing' event from socket
    socket.on('typing', (data) {
      // Parse the data into TypingStatus model
      final typing = TypingStatus.fromJson(data);

      // Update UI after changes
      update();

      if (typing.isTyping) {
        // Add unique senderId if not already present
        if (!isTyping.contains(typing.senderId)) {
          isTyping.add(typing.senderId);
          update();
        }
      } else {
        // Remove the senderId when typing stops
        isTyping.remove(typing.senderId);
        update();
      }

      if (kDebugMode) {
        print(isTyping);
        print('Received message from WebSocket: ${typing.senderId}');
      }

      // Handle the received message as needed
    });
    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Disconnected Socket');
      }
    });
  }

  String generateHexId() {
    var random = Random();
    const hexChars = '0123456789abcdef';
    return List.generate(24, (index) => hexChars[random.nextInt(16)]).join();
  }

  // Function to emit message data
  void sendMessage(String recipientId, String message,
      [String repliedMsgId = "false"]) {
    final msgId = generateHexId();
    final data = {
      "recipientId": recipientId,
      "message": message,
      "messageId": msgId,
      "repliedMsgId": repliedMsgId
    };
    // Convert Map to JSON string
    String jsonData = jsonEncode(data);
    // Emit the message data to the server
    socket.emit('message', jsonData);

    final receivedData = MessageData.fromMap(MessageData(
            isSeen: true,
            isTyping: false,
            message: message,
            messageId: msgId,
            repliedMsgId: repliedMsgId,
            senderId: HiveService.instance.userData?.id ?? '',
            avater: null,
            recipientId: recipientId,
            name: HiveService.instance.userData?.name ?? '',
            timestamp: DateTime.now())
        .toJson());

    saveMessages(receivedData.toHiveData());

    playSound(MediaConst.sendMsgSound);
    HiveService.instance
        .updateMessageProperty(senderId: recipientId, message: message);
    if (kDebugMode) {
      print('Message sent to recipient $recipientId: $message');
    }
  }

  requestOnline() {
    String jsonData = jsonEncode(senderIds);
    if (senderIds.isNotEmpty) {
      socket.emit('checkOnline', jsonData);
    }
  }

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    listenOnlineUser();
    getInbox();
  }

  void updateSearchText(String value) {
    searchText.value = value; // Update the search text
  }

  bool isUser(String id1, String id2) {
    return id1 == id2;
  }

  playReceiveMsgSound(String senderId, MessageData data) {
    if (availReceiveSoundId.value == senderId) {
      playSound(MediaConst.receivedMsgSound);
    } else {
      NotificationManager.instance.showChatNotification(
        model: ShowPluginNotificationModel(
          id: 0,
          title: data.name,
          payload: data.senderId,
          body: data.message,
        ),
        userImage:
            'https://img.freepik.com/free-photo/androgynous-avatar-non-binary-queer-person_23-2151100270.jpg',
        userName: data.name,
        conversationTitle: 'New Message',
      );
    }
  }

  Future<void> playSound(String soundPath) async {
    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setAsset(soundPath); // Use your audio file
      _audioPlayer.play();
    } catch (e) {
      if (kDebugMode) {
        print("Error playing audio: $e");
      }
    }
  }

  void updateAvailsoundId(String value) {
    availReceiveSoundId.value = value; // Update the search text

    update();
  }

  void markAsRead(String senderId) async {
    final data = {"recipientId": senderId};
    final unRead = getUnreadCount(senderId);
    String jsonData = jsonEncode(data);
    if (unRead != 0) {
      socket.emit("messageSeen", jsonData);
      await HiveService.instance.markAllMessagesAsSeen();
      unReadMessages.clear();
  
    }

    update();
  }

  void clearId() {
    availReceiveSoundId.value = ''; // Update the search text

    update();
  }

  ScrollController messageController = ScrollController();

  void scrollToBottom() async {
    // Adding a small delay to ensure messages are loaded fully
    await Future.delayed(const Duration(milliseconds: 100));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messageController.hasClients) {
        messageController.animateTo(
          messageController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void listenOnlineUser() {
    socket.on('onlineUsers', (data) {
      onlineUsers.value =
          List<String>.from(data); // Update the online users list
      update(); // Notify listeners to rebuild the UI
    });
  }

  bool isOnline(String idToCheck) {
    return onlineUsers.contains(idToCheck);
  }

  bool isTypingCheck(String idToCheck) {
    return isTyping.contains(idToCheck);
  }

  @override
  void onClose() {
    socket.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}

class TypingStatus {
  final String senderId;
  final bool isTyping;

  TypingStatus({required this.senderId, required this.isTyping});

  // Method to convert a JSON map into a TypingStatus object
  factory TypingStatus.fromJson(Map<String, dynamic> json) {
    return TypingStatus(
      senderId: json['senderId'],
      isTyping: json['isTyping'],
    );
  }

  // Method to convert a TypingStatus object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'isTyping': isTyping,
    };
  }
}
