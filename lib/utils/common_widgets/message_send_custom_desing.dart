import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:connect/utils/consts/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///@Description: This Is Custom Design of Sending Message Input
///@function: Mesage Sendign Function,emoji,attachment,
Widget onMessageSendButton(
    {required VoidCallback onTap,
    required TextEditingController textCtr,
    required FocusNode focusNode,
    required String messageId,
    required void Function(String)? onChanged}) {
  return GetBuilder<HomeController>(builder: (ctr) {
    return Column(
      children: [
        if (ctr.repliedMsgId.value != "false")
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 20.h, maxHeight: 120.h),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              // margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),

              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vertical Line

                    Container(
                      // Makes the line expand with the content

                      width: 4.w,

                      color: Colors.amber,

                      margin: EdgeInsets.only(
                        right: 8.w,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ctr.repliedName.value,
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 16.h,
                                ),
                              ),

                              // Close Icon Button
                              GestureDetector(

                                onTap: (){

                                  ctr.closeReply();
                                },
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  child: Icon(Icons.close,
                                  size: 25.sp,
                                      color:
                                          Colors.amber), // Remove padding
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ctr.findMessageTextById(ctr.repliedMsgId.value),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
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
                child: GetBuilder<HomeController>(builder: (ctr) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: null,
                            focusNode: focusNode,
                            minLines: 1,
                            onChanged: onChanged,
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
                  );
                }),
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
        ),
      ],
    );
  });
}
