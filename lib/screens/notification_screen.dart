import 'package:connect/custom_widgets/custom_notification_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

//@Description : This is for notification SHowing Screen
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              CupertinoIcons.back,
              size: 25.h,
            )),
        title: "Notification".text.make(),
      ),
      body: Center(
        child: Column(
          //Later can use ListViewBuilders  for many notification
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomNotificationItem(
                message:
                    "You Got a new Message From Your Friend", // Notification message
                context: context),
            CustomNotificationItem(
                message: "Your Got a New Call from Random User",
                context: context)
          ],
        ),
      ),
    );
  }
}
