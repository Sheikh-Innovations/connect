import 'package:connect/consts/color_const.dart';
import 'package:connect/custom_widgets/message_send_custom_desing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: This Is Chat Screen Of Users.
///@Function: it will just show conversation between User and User.
///Chat bubbles will contain Chat Messages
///And which one is user Message will be decide by  isUser this param, This is boolean param
class ChatInsideScreen extends StatelessWidget {
  ChatInsideScreen({super.key});

  /// ---> These are the Demo Message  , chat functions needs to add <--- ///
  final List<Message> messages = [
    Message(
        text: "Hey How Are?", isUser: true, avatarPath: "assets/Avatar.png"),
    Message(
        text: "i am absolutey Rocking, Tell me About You",
        isUser: false,
        avatarPath: "assets/Avatar.png"),
    Message(
        text: "THings are also great for me!",
        isUser: true,
        avatarPath: "assets/Avatar.png"),
    Message(
        text: " So How is your app development process going?",
        isUser: false,
        avatarPath: "assets/Avatar.png"),
    Message(
        text: "It's on the Last stage",
        isUser: true,
        avatarPath: "assets/Avatar.png"),
  ];

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
              icon: Icon(CupertinoIcons.back, color: Colors.white),
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
            "John Doe".text.white.size(15.h).bold.make(),
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
          15.h.heightBox,
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
