import 'dart:async';
import 'dart:convert';

import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:connect/utils/consts/color_const.dart';
import 'package:connect/utils/common_widgets/message_send_custom_desing.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      final controller = Get.find<HomeController>();
      controller.getRoomMessage(widget.senderId);
      controller.updateAvailsoundId(widget.senderId);
    });
  }

  final textCtr = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((t) {
      Get.find<HomeController>().clearId();
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
        Get.find<HomeController>().socket.emit(
            'typing',jsonData);
      });
    }
  }

  Timer? _debounce;
  bool _lastTypingState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,

      /// ---> App Bar of  chat Inside Screen <--- ///
      appBar: AppBar(
        backgroundColor: primaryColor,
        leadingWidth: 200.h,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            CircleAvatar(
              maxRadius: 20,
              minRadius: 18,
              child: ClipOval(child: Image.asset('assets/Avatar.png')),
            ),
            10.h.widthBox,
            widget.name.text.white.size(15.h).bold.make(),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.phone_solid,
              color: Colors.white,
              size: 25.h,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.video_camera_solid,
              color: Colors.white,
              size: 30.h,
            ),
            onPressed: () {},
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
                child: Scrollbar(
                  interactive: true,
                  thickness: 5,
                  controller: ctr.messageController,
                  child: ListView.builder(
                    itemCount: ctr.roomMessages.length,
                    controller: ctr.messageController,
                    reverse: true,
                    cacheExtent: 300,
                    itemBuilder: (context, index) {
                      final itemCount = ctr.roomMessages.length;
                      int reversedIndex = itemCount - 1 - index;
                      return ChatBubble(
                          message: Message(
                              text: ctr.roomMessages[reversedIndex].message,
                              isUser: ctr.isUser(
                                  HiveService.instance.userData?.id ?? '',
                                  ctr.roomMessages[reversedIndex].senderId),
                              avatarPath: "assets/Avatar.png"));
                    },
                  ),
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
                  ctr.sendMessage(widget.senderId, textCtr.text);
                  textCtr.clear();
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
  final String avatarPath;

  Message({required this.text, required this.isUser, required this.avatarPath});
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

    /// ---> Chat Bubble Alignment <---- ////
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 15),
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
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              maxRadius: 20,
              minRadius: 18,
              child: ClipOval(
                  child: Image.asset(message
                      .avatarPath)), //**User Image will come from database */
            ),
          ],
        ],
      ),
    );
  }
}
