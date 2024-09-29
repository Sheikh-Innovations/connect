import 'package:connect/consts/color_const.dart';
import 'package:connect/custom_widgets/message_send_custom_desing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: This Is Chat Screen Of User Chat With Ai.
///@Function: it will just show conversation between Ai and User.
///Chat bubbles will contain Chat Messages
///And which one is user Message will be decide by  isUser this param, This is boolean param
class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});

  /// ---> These are the Demo Message  , chat functions needs to add <--- ///
  final List<Message> messages = [
    Message(
        text: "I need some Help !",
        isUser: true,
        avatarPath: "assets/Avatar.png"),
    Message(
        text: "Hi, How can I help you?",
        isUser: false,
        avatarPath: "assets/Avatar.png"),
    Message(
        text: "What is Database system ?!",
        isUser: true,
        avatarPath: "assets/Avatar.png"),
    Message(
        text:
            " Data System Is System Design to maintain Data of any application",
        isUser: false,
        avatarPath: "assets/Avatar.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,

      /// ---> App Bar of AI chat Screen <--- ///
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              CupertinoIcons.back,
              color: whiteColor,
            )),
        backgroundColor: primaryColor,
        title: "AI Chatbot".text.white.semiBold.size(18.h).make(),
        centerTitle: true,
      ),

      /// ---> Body Part Showing Messages of AI bot and User <---- ///
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: messages[index]);
                },
              ),
            ),
          ),

          /// ---> UI part of Sendign Messaging TextFiled <--- ///
          const MessageSendingCustomDesign(),
          5.h.heightBox,
        ],
      ),
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
  ChatBubble({required this.message});

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
