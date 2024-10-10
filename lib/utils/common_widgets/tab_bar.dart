import 'package:connect/screens/call_screen.dart';
import 'package:connect/screens/chat_screen.dart';
import 'package:connect/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

///@description: This is Custom Tabbar that is added in HomeScreen
///@just two screen added here 2 tab

class CustomTabbar extends StatefulWidget {
  const CustomTabbar({super.key});

  @override
  State<CustomTabbar> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar> {
  // ---> Tab list of Chat Screen and Call Screen <--- //

  bool chatScreen = true;
  updateSwitchTap(bool value) {
    setState(() {
      chatScreen = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
      
      
          Center(
            child: SizedBox(
              width: 250.w,
              child: SwitchButtons(
                button1: 'CHATS',
                button2: 'CALLS',
                onTapButton1: () {
                  updateSwitchTap(true);
                },
                onTapButton2: () {
                  updateSwitchTap(false);
                },
                isFirstButtonSelected: chatScreen,
              ),
            ),
          ),
          // Wrap TabBarView in SafeArea to ensure it's well-positioned and avoid bottom notches
          10.h.heightBox,
          if (chatScreen) ...[const ChatScreenConnect()],
          if (!chatScreen) ...[const CallScreenConnect()],
        ],
      ),
    );
  }
}
