import 'dart:async';
import 'dart:convert';

import 'package:connect/data/models/remote/message_data.dart';
import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:connect/utils/common_widgets/modal_bottom_sheet.dart';
import 'package:connect/utils/consts/color_const.dart';
import 'package:connect/utils/common_widgets/message_send_custom_desing.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: This Is Chat Screen Of Users.
///@Function: it will just show conversation between User and User.
///Chat bubbles will contain Chat Messages
///And which one is user Message will be decide by  isUser this param, This is boolean param
class ChatInsideScreen extends StatefulWidget {
  final String name;
  final String senderId;
  const ChatInsideScreen(
      {super.key, required this.name, required this.senderId});

  @override
  State<ChatInsideScreen> createState() => _ChatInsideScreenState();
}

class _ChatInsideScreenState extends State<ChatInsideScreen> {
  late HomeController controller;
  @override
  void initState() {
    super.initState();

    controller = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.getRoomMessage(widget.senderId);
      controller.updateAvailsoundId(widget.senderId);
      controller.markAsReadBySenderId(widget.senderId);
    });
  }

  final textCtr = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.clearId();
      textCtr.dispose();
    });
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    bool isTyping = text.isNotEmpty;

    // Check if the typing state has changed to prevent unnecessary emits
    if (isTyping != _lastTypingState) {
      _lastTypingState = isTyping; // Update the last known state

      // Debouncing logic to delay the emit action
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final data = {"recipientId": widget.senderId, "isTyping": isTyping};
        // Convert Map to JSON string
        String jsonData = jsonEncode(data);
        // Emit typing event after the debounce duration
        Get.find<HomeController>().socket.emit('typing', jsonData);
      });
    }
  }

  Timer? _debounce;
  bool _lastTypingState = false;

  bool isEditAction = false;
  MessageData? currentMessageForSend;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,

      /// ---> App Bar of  chat Inside Screen <--- ///
      appBar: AppBar(
        backgroundColor: primaryColor,
        leadingWidth: 250.h,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            CircleAvatar(
              maxRadius: 20.h,
              minRadius: 18.h,
              backgroundColor:
                  Colors.transparent, // Ensure background is transparent
              child: ClipOval(
                child: Image.asset('assets/Avatar.png',
                    fit: BoxFit.cover), // Fit image to cover the circle
              ),
            ),
            SizedBox(width: 10.h), // Use SizedBox for spacing
            GetBuilder<HomeController>(builder: (ctr) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start
                children: [
                  widget.name.text.white.size(15.h).bold.make(),
                  if (ctr.calculateLastSeenDurationString(widget.senderId) !=
                      "No last seen")
                    Text(
                      ctr.calculateLastSeenDurationString(widget.senderId),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12), // Slightly smaller text
                    ),
                ],
              );
            }),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.phone_solid,
              color: Colors.white,
              size: 25.h,
            ),
            onPressed: () {
              // Implement phone action
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.video_camera_solid,
              color: Colors.white,
              size: 30.h,
            ),
            onPressed: () {
              // Implement video call action
            },
          ),
        ],
      ),

      /// ---> Body Part Showing Messages of Users <---- ///
      body: GetBuilder<HomeController>(builder: (ctr) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: ctr.roomMessages.length,
                  controller: ctr.messageController,
                  reverse: true,
                  cacheExtent: 300,
                  itemBuilder: (context, index) {
                    final itemCount = ctr.roomMessages.length;
                    int reversedIndex = itemCount - 1 - index;
                    bool isLastMessage = index == 0;
                    // Get the current and the previous message timestamps
                    // Get the current and previous message timestamps
                    final currentMessage = ctr.roomMessages[reversedIndex];
                    final previousMessage = (reversedIndex > 0)
                        ? ctr.roomMessages[reversedIndex - 1]
                        : null;

                    // Check if the dates are different for displaying the date
                    bool showDate = previousMessage == null ||
                        !isSameDay(currentMessage.timestamp,
                            previousMessage.timestamp);

                    return GestureDetector(
                      onLongPress: () {
                        showEditDeleteModal(
                            context: context,
                            onDelete: () {
                              if (currentMessage.senderId ==
                                  HiveService.instance.userData?.id) {
                                controller.removeAndEditEmit(
                                    recipientId: currentMessage.recipientId,
                                    messageId: currentMessage.messageId,
                                    eventType: "delete",
                                    newContent: "Unsent");

                                controller.deleteAndEditMessageById(
                                    msgId: currentMessage.messageId,
                                    senderId: currentMessage.recipientId,
                                    actionType: "delete",
                                    newContent: "Unsent",
                                    timestamp: DateTime.now());

                                Navigator.pop(context);
                              } else {
                                controller.deleteAndEditMessageById(
                                    msgId: currentMessage.messageId,
                                    senderId: currentMessage.recipientId,
                                    actionType: "delete",
                                    newContent: "Unsent",
                                    timestamp: DateTime.now());

                                Navigator.pop(context);
                              }
                            },
                            onEdit: () {
                              textCtr.text = currentMessage.message;
                              currentMessageForSend = currentMessage;
                              isEditAction = true;
                              Navigator.pop(context);
                            },
                            senderId: currentMessage.senderId);
                      },
                      child: ChatBubble(
                        message: Message(
                            isSameDay: showDate,
                            timestamp:
                                ctr.roomMessages[reversedIndex].timestamp,
                            isLastMessage: isLastMessage,
                            isSeen: ctr.roomMessages[reversedIndex].isSeen,
                            text: ctr.roomMessages[reversedIndex].message,
                            isUser: ctr.isUser(
                                HiveService.instance.userData?.id ?? '',
                                ctr.roomMessages[reversedIndex].senderId),
                            avatarPath: "assets/Avatar.png"),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: ctr.isTypingCheck(widget.senderId) == true
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Typing.."),
                      )
                    : const SizedBox.shrink()),

            /// ---> UI part of Sendign Messaging TextFiled <--- ///
            onMessageSendButton(
                focusNode: focusNode, // Pass the FocusNode here
                textCtr: textCtr,
                onTap: () {
                  if (isEditAction && currentMessageForSend != null) {
                    controller.removeAndEditEmit(
                      recipientId: currentMessageForSend?.recipientId ?? '',
                      messageId: currentMessageForSend?.messageId ?? '',
                      eventType: "edit",
                      newContent: textCtr.text,
                    );

                    controller.deleteAndEditMessageById(
                        msgId: currentMessageForSend?.messageId ?? '',
                        senderId: currentMessageForSend?.recipientId ?? '',
                        actionType: "edit",
                        newContent: textCtr.text,
                        timestamp: DateTime.now());
                    textCtr.clear();
                  } else {
                    ctr.sendMessage(widget.senderId, textCtr.text);
                    textCtr.clear();
                  }
                },
                onChanged: _onTextChanged),
            15.h.heightBox,
          ],
        );
      }),
    );
  }
}

/// ---> Each Message Contains Data of Message , checking isUser or Ai , and Avatar of user <---- ///
class Message {
  final String text;
  final bool isUser;
  final bool isSeen;

  final bool isSameDay;
  final bool isLastMessage; // Add this parameter
  final String avatarPath;
  final DateTime timestamp;

  Message(
      {required this.text,
      required this.isUser,
      required this.isLastMessage,
      required this.avatarPath,
      required this.timestamp,
      required this.isSameDay,
      required this.isSeen});
}

/// ---> Chat Bubble Design <--- ///
class ChatBubble extends StatelessWidget {
  final Message message;

  /// In the Bubble Message will be shown
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft:
          message.isUser ? const Radius.circular(12) : const Radius.circular(0),
      bottomRight:
          message.isUser ? const Radius.circular(0) : const Radius.circular(12),
    );

    /// Check if the current message is on a different day than the previous one
    /// Check if the current message is on a different day than the previous one

    /// ---> Chat Bubble Alignment <---- ////
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          if (message.isSameDay)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                getChatDayTime(message.timestamp),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                CircleAvatar(
                  maxRadius: 20,
                  minRadius: 18,
                  child: ClipOval(
                      child: Image.asset(message
                          .avatarPath)), //**User Image will come from database */
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      margin: EdgeInsets.only(
                          bottom: message.isUser
                              ? message.isLastMessage
                                  ? 2.h
                                  : 10.h
                              : 10.h,
                          right: 3.w),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6.h),
                      decoration: BoxDecoration(
                        color: message.isUser ? primaryColor : blackColor,
                        borderRadius: borderRadius,
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? whiteColor : whiteColor,
                          fontSize: 16.h,
                        ),
                      ),
                    ),
                    if (message.isUser && message.isLastMessage)
                      Text(
                        message.isSeen ? 'Seen' : 'Delivered', // Status text
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.h,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String getChatDayTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(const Duration(days: 1));
  DateTime localDateTime = dateTime;

  if (localDateTime.day == now.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return 'Today';
  } else if (localDateTime.day == yesterday.day &&
      localDateTime.month == yesterday.month &&
      localDateTime.year == yesterday.year) {
    return 'Yesterday';
  } else {
    return dateConverterMonth(dateTime.toString());
  }
}

String dateConverterMonth(String string) {
  int i = 0;
  String s = "";
  String monthNum = string.split('')[5] + string.split('')[6];
  String dayNum = string.split('')[8] + string.split('')[9];

  List<String> m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<String> mN = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];

  for (i = 0; i < 12; ++i) {
    if (monthNum == mN[i]) {
      s = '$dayNum ${m[i]} ';
      break;
    }
  }

  for (i = 0; i < 4; ++i) {
    s += string.split('')[i];
  }

  return s;
}

bool isSameDay(DateTime nowTime, DateTime priviesTime) {
  DateTime now = nowTime.toLocal();
  DateTime privies = priviesTime;
  if (now.day == privies.day &&
      now.month == privies.month &&
      now.year == privies.year) {
    return true;
  }
  return false;
}
