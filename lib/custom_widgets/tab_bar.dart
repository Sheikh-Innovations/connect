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

  bool chatScreen = false;
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
          // Wrap TabBar only with necessary padding
          // TabBar(
          //   padding: EdgeInsets.zero,
          //   indicatorSize: TabBarIndicatorSize.tab,
          //   labelColor: whiteColor,
          //   unselectedLabelColor: primaryColor,
          //   dividerColor: whiteColor,
          //   indicator: BoxDecoration(
          //     color: primaryColor,
          //     borderRadius: const BorderRadius.all(Radius.circular(10)),
          //   ),
          //   tabs: const [
          //     Tab(text: 'Chats'),
          //     Tab(text: 'Calls'),
          //   ],
          // )
          //   .box
          //   .height(40.h)
          //   .width(width * 0.7.h)
          //   .color(Colors.white)
          //   .roundedLg
          //   .border(color: Colors.grey.withOpacity(0.3))
          //   .make(),
      
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
