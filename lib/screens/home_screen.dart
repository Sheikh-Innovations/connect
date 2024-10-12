import 'package:connect/modules/auth/views/available_contacts.dart';
import 'package:connect/utils/consts/color_const.dart';
import 'package:connect/utils/common_widgets/tab_bar.dart';

import 'package:connect/screens/notification_screen.dart';
import 'package:connect/screens/profile_screen.dart';
import 'package:connect/utils/functions.dart';
import 'package:connect/utils/notification_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../data/providers/hive_service.dart';

///@description: This is the home Screen Of the App
///@param: this Contain Search,Name,Image,param
///@button: Profile Button , Notification ,AI Chat Button, Tabbar,More Button

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 35.h, bottom: 10.h, left: 15.w, right: 15.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //wiLL TAKE TO PROFILE SCREEN
                        Get.to(() => const ProfileScreen());
                      },

                      /// ** In this Avatar User Image Will be shown ** ///
                      child: CircleAvatar(
                        maxRadius: 30.r,

                        backgroundImage: const AssetImage(
                            'assets/Avatar.png'), //**User Image will come from database */
                      ),
                    ),
                    8.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (HiveService.instance.userData?.name ?? 'John Doe')
                            .text
                            .size(20.h)
                            .white
                            .semiBold
                            .make(), //**User Name will come from database */
                        "Connect with your dear ones"
                            .text
                            .size(12.h)
                            .gray200
                            .make(),
                      ],
                    ),
                    58.widthBox,

                    GestureDetector(
                      onTap: () {
                     
       

                        // // WIll take to notification sccreen
                        // Get.to(() => const NotificationScreen());
                      },
                      child: Icon(
                        CupertinoIcons.bell_fill,
                        color: whiteColor,
                        size: 25.h,
                      ),
                    ),
                    // Row(
                    //   children: [

                    //     // ---> More Button <---//
                    //     // PopupMenuButton(

                    //     //   padding: EdgeInsets.zero,
                    //     //     iconColor: Colors.white,
                    //     //     itemBuilder: (ctx) => [
                    //     //           const PopupMenuItem(child: Text('Settings')),
                    //     //           PopupMenuItem(
                    //     //               onTap: () {}, child: const Text('Logout'))
                    //     //         ])
                    //   ],
                    // ),
                  ],
                ),
                8.h.heightBox,

                /// ----> Search Bar Option Inside The Header Container <---- ////
                SizedBox(
                  height: 35.0.h, // Adjust height as needed
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      // Handle search logic here to integrate search
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search in chat...',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide.none, // No border line
                      ),
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        size: 25.0, // Adjust icon size as needed
                        color: Colors.grey,
                      ),
                    ),
                    autofocus: false,
                    showCursor: false, // Hide cursor if desired
                  ),
                ),
              ],
            ),
          ).box.size(width, height * 0.22).color(primaryColor).make(),

          /// ----> This Expanded Part is SHOWING TAB BAR with Two Option Chat And Calls <---- ///

          20.h.heightBox,
          const Expanded(child: CustomTabbar()),
        ],
      ),

      /// ----> Floating Action Button For AI Chat <---- ///
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 60.h,
          width: 60.h,
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            elevation: 10,
            onPressed: () {
              Get.to(() => const ContactComparisonScreen());
            },
            tooltip: 'Talk With AI',
            child: Icon(
              CupertinoIcons.add,
              size: 30.h,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchButtons extends StatelessWidget {
  final String button1;
  final String button2;

  final VoidCallback onTapButton1;
  final VoidCallback onTapButton2;
  final bool isFirstButtonSelected;
  const SwitchButtons(
      {super.key,
      required this.button1,
      required this.button2,
      required this.onTapButton1,
      required this.onTapButton2,
      required this.isFirstButtonSelected});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTapButton1,
                child: Container(
                  height: 35.h,
                  decoration: BoxDecoration(
                    color:
                        isFirstButtonSelected ? primaryColor : Colors.grey[300],
                    borderRadius:
                        const BorderRadius.horizontal(left: Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      button1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isFirstButtonSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapButton2,
                child: Container(
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: !isFirstButtonSelected
                        ? primaryColor
                        : Colors.grey[300],
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      button2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !isFirstButtonSelected
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
