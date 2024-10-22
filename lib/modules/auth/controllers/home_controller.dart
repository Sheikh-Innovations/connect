import 'dart:convert';
import 'dart:math';

import 'package:connect/data/models/local/message_hive_data.dart';
import 'package:connect/data/models/remote/edit_remove.dart';
import 'package:connect/data/models/remote/last_seen.dart';
import 'package:connect/data/models/remote/message_data.dart';
import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/utils/consts/api_const.dart';
import 'package:connect/utils/consts/asset_const.dart';
import 'package:connect/utils/notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  var isVisiblity = false.obs;
  var onlineUsers = [].obs;
  var lastSeenUsrs = <LasSeenEntry>[].obs;
  var isTyping = <String>[].obs; // List to store typing users (observable)
  var repliedMsgId = 'false'.obs;

  var repliedName = 'false'.obs;

  Future<void> getInbox() async {
    try {
      var data = await HiveService.instance.getInboxMessages();
      inboxMessages.value = data.map((message) {
        senderIds.add(message.senderId);
        listenOnlineUser();

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

  Future<void> getLastSeen() async {
    try {
      // Fetch the data from the Hive box
      var data = await HiveService.instance.getSeenMessages();

      // Map the data to `lastSeenUsrs`
      lastSeenUsrs.value = data.map((message) {
        return LasSeenEntry.fromSeenMessage(message);
      }).toList();

      update();
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('Error fetching last seen messages: $e');
      }
    }
  }

  getUnreadMessage() async {
    var data = await HiveService.instance.getAllUnseenMessages();
    unReadMessages.value = data.map((message) {
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
          replyTo: message.replyTo,
          messageId: message.messageId,
          repliedMsgId: message.repliedMsgId,
          recipientId: message.recipientId,
          isSeen: message.isSeen,
          isTyping: message.isTyping,
          timestamp: message.timestamp.toLocal()));
      getInbox();
      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching inbox messages: $e');
      }
    }
  }

  Future<void> saveLastSeen(LasSeenEntry data) async {
    try {
      await HiveService.instance.saveSeenMessage(data);
      lastSeenUsrs.add(data);
      getLastSeen();
      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching last seen: $e');
      }
    }
  }

  Future<void> deleteAndEditMessageById(
      {required String msgId,
      required String senderId,
      required String actionType,
      required String newContent,
      required DateTime timestamp}) async {
    try {
      if (actionType == "edit") {
        await HiveService.instance
            .editMessageById(msgId, newContent, timestamp);
        getRoomMessage(senderId);

        int index = findMessageIndexById(msgId);

// Check if the message is the last in the list
        bool isLastMessage = index == roomMessages.length - 1;

        if (isLastMessage) {
          HiveService.instance
              .updateMessageProperty(senderId: senderId, message: newContent);

          getInbox();
        }

        //     .updateMessageProperty(senderId: senderId, message: newContent);
      } else {
        await HiveService.instance.removeMessage(msgId);
        getRoomMessage(senderId);
        int index = findMessageIndexById(msgId);

// Check if the message is the last in the list
        bool isLastMessage = index == roomMessages.length - 1;

        if (isLastMessage) {
          HiveService.instance.updateMessageProperty(
              senderId: senderId, message: 'Content is unsent');

          getInbox();
        }
      }

      update();
    } catch (e) {
      // Handle errors if any, e.g. print or log them
      if (kDebugMode) {
        print('Error fetching inbox messages: $e');
      }
    }
  }

  int findMessageIndexById(String messageId) {
    return roomMessages.indexWhere((message) => message.messageId == messageId);
  }

  Future<void> markAsUnReadBySenderAndReceipent(String senderId) async {
    try {
      await HiveService.instance.markMessagesAsSeenBySenderAndRecipient(
          senderId, HiveService.instance.userData?.id ?? '');
      getRoomMessage(senderId);
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
        print(message.messageId);
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
      final receivedData = MessageData.fromMap(data);

      saveMessages(receivedData.toHiveData());
      playReceiveMsgSound(receivedData.senderId, receivedData);

      if (kDebugMode) {
        print('Received message from WebSocket: ${data}');
      }
      // Handle the received message as needed
    });

    socket.on('messageSeen', (data) {
      final receivedData = LasSeenEntry.fromMap(data);
      markAsUnReadBySenderAndReceipent(receivedData.senderId);
      saveLastSeen(receivedData);
      if (kDebugMode) {
        print('Received message from WebSocket: ${receivedData.senderId}');
      }
      // Handle the received message as needed
    });

    socket.on('messageUpdated', (data) {
      final updatedData = EditRemoveRspnse.fromMap(data);
      deleteAndEditMessageById(
          msgId: updatedData.messageId,
          senderId: updatedData.senderId,
          actionType: updatedData.eventType,
          newContent: updatedData.newContent,
          timestamp: updatedData.timestamp);
      if (kDebugMode) {
        print('Received message from WebSocket: ${updatedData.messageId}');
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
  void sendMessage(
    String recipientId,
    String message,
  ) {
    final msgId = generateHexId();
    final data = {
      "recipientId": recipientId,
      "message": message,
      "messageId": msgId,
      "replyTo": repliedName.value == "You" ? "Himself" : repliedName.value,
      "repliedMsgId": repliedMsgId.value
    };
    // Convert Map to JSON string
    String jsonData = jsonEncode(data);
    // Emit the message data to the server
    socket.emit('message', jsonData);

    final receivedData = MessageData.fromMap(MessageData(
            isSeen: false,
            isTyping: false,
            message: message,
            messageId: msgId,
            replyTo: repliedName.value,
            repliedMsgId: repliedMsgId.value,
            senderId: HiveService.instance.userData?.id ?? '',
            avater: null,
            recipientId: recipientId,
            name: HiveService.instance.userData?.name ?? '',
            timestamp: DateTime.now())
        .toJson());
    saveMessages(receivedData.toHiveData());
    repliedMsgId.value = "false";
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

  removeAndEditEmit(
      {required String recipientId,
      required String messageId,
      required String eventType,
      required String newContent}) {
    final data = {
      "recipientId": recipientId,
      "messageId": messageId,
      "eventType": eventType,
      "newContent": newContent
    };

    String jsonData = jsonEncode(data);
    if (recipientId.isNotEmpty && recipientId.isNotEmpty) {
      socket.emit('messageUpdated', jsonData);
    }
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

  updateVisibity(bool value) {
    isVisiblity.value = value;
    update();
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

  void markAsReadBySenderId(String senderId) async {
    final data = {"recipientId": senderId};
    final unRead = getUnreadCount(senderId);
    String jsonData = jsonEncode(data);

    socket.emit("messageSeen", jsonData);
    await HiveService.instance.markMessagesAsSeenBySender(senderId);
    if (unRead != 0) {
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

      if (kDebugMode) {
        print('Online user $onlineUsers');
      }
      update(); // Notify listeners to rebuild the UI
    });
  }

  bool isOnline(String idToCheck) {
    return onlineUsers.contains(idToCheck);
  }

  bool isTypingCheck(String idToCheck) {
    return isTyping.contains(idToCheck);
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  String calculateLastSeenDurationString(String senderId) {
    try {
      // Use where to filter the list for entries that match the senderId
      final matchingEntries =
          lastSeenUsrs.where((entry) => entry.senderId == senderId);

      // If no matching entries are found, return a default message
      if (matchingEntries.isEmpty) {
        return 'No last seen';
      }

      // Get the first matching entry
      final lastSeenEntry = matchingEntries.first;

      DateTime lastSeenTime =
          lastSeenEntry.seenAt; // Assuming seenAt is a DateTime
      DateTime currentTime = DateTime.now();

      // Calculate the duration
      Duration duration = currentTime.difference(lastSeenTime);

      // Format the duration as a string
      String durationString = _formatDuration(duration);

      // Check if the user is currently online
      if (isOnline(senderId)) {
        return 'Online';
      } else {
        // Return the formatted last seen time
        return 'Last seen: $durationString ago';
      }
    } catch (e) {
      // Handle errors if any
      if (kDebugMode) {
        print('Error calculating last seen duration: $e');
      }
      return 'Error calculating duration';
    }
  }

// Helper function to format the Duration into a readable string
  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds} seconds';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inDays < 1) {
      return '${duration.inHours} hours';
    } else {
      return '${duration.inDays} days';
    }
  }

  String findMessageTextById(String messageId) {
    try {
      // Find the message with the matching messageId
      final message =
          roomMessages.firstWhere((message) => message.messageId == messageId);
      return message.message; // Return the message's text if found
    } catch (e) {
      // If no message is found, return a default message or error message
      return "Message not found";
    }
  }

  updateRepliedMsg(String value, String name, String recipientId) {
    repliedMsgId.value = value;

    if (HiveService.instance.userData?.id == recipientId) {
      repliedName.value = name;
      update();
    } else {
      repliedName.value = "You";
      update();
    }

    update();
  }

  closeReply() {
    repliedMsgId.value = "false";
    update();
  }

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    getInbox();
    getLastSeen();
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
