// Custom reusable widget for the row with an icon and text
import 'package:connect/consts/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

///@description: CustomRow for User Profile
///@param: User name,user id,user mail,user phonenumber
Widget CustomRow(
    {required IconData icon,
    required String text,
    required BuildContext context}) {
  double widht = MediaQuery.sizeOf(context).width;
  return Padding(
    padding: const EdgeInsets.only(left: 15),
    child: Row(
      children: [
        Icon(
          icon,
          color: whiteColor,
        ),
        25.widthBox,
        text.text.size(15.h).white.make(),
      ],
    ),
  )
      .box
      .color(primaryColor)
      .size(widht * 0.85, 50.h)
      .roundedSM
      .border(color: primaryColor, width: 2)
      .makeCentered();
}
