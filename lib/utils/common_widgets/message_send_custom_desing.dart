import 'package:connect/utils/consts/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///@Description: This Is Custom Design of Sending Message Input
///@function: Mesage Sendign Function,emoji,attachment,
Widget onMessageSendButton(
    {required VoidCallback onTap, required TextEditingController textCtr,   required FocusNode focusNode, }) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: Row(
      children: [
        // Emoji/Attachment Button
        IconButton(
          icon: Icon(
            Icons.emoji_emotions_outlined,
            color: greyColor,
            size: 25.h,
          ),
          onPressed: () {
            // Add emoji picker logic here
          },
        ),
        // Text Input Field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    focusNode: focusNode,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    controller: textCtr,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.attach_file, color: primaryColor),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
        // Send Button
        IconButton(
          icon: Icon(
            Icons.send,
            color: primaryColor,
            size: 30.h,
          ),
          onPressed: onTap,
        ),
      ],
    ),
  );
}
