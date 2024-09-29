import 'package:connect/consts/color_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: Custom Notification Design With just the Message
///@param: Notification Message

Widget CustomNotificationItem({
  required String message,
  required BuildContext context,
}) {
  double widht = MediaQuery.sizeOf(context).width;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        15.widthBox,
        Icon(CupertinoIcons.mail, color: primaryColor),
        10.widthBox,
        Expanded(
          child:
              message.text.overflow(TextOverflow.ellipsis).maxLines(2).make(),
        ),
      ],
    )
        .box
        .height(60.h)
        .width(widht * 0.9)
        .color(Colors.white)
        .roundedSM
        .shadowSm
        .makeCentered(),
  );
}
