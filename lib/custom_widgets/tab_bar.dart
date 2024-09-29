import 'package:connect/screens/call_screen.dart';
import 'package:connect/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';
import '../consts/color_const.dart';

///@description: This is Custom Tabbar that is added in HomeScreen
///@just two screen added here 2 tab
class CustomTabbar extends StatefulWidget {
  const CustomTabbar({super.key});
  @override
  State<CustomTabbar> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar> {
  // ---> Tab list of Chat Screen and Call Screen <--- //
  final List<Widget> _tabScreenList = [
    const ChatScreenConnect(),
    const CallScreenConnect(),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return DefaultTabController(
      length: 2,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: whiteColor,
                  unselectedLabelColor: primaryColor,
                  dividerColor: whiteColor,
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  tabs: const [
                    Tab(
                      text: 'Chats',
                    ),
                    Tab(
                      text: 'Calls',
                    ),
                  ],
                )
                    .box
                    .height(40.h)
                    .width(width * 0.7.h)
                    .color(Colors.white)
                    .roundedLg
                    .border(color: Colors.grey.withOpacity(0.3))
                    .make(),
                const SizedBox(height: 5),
                Expanded(
                  child: TabBarView(
                    children: _tabScreenList,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
