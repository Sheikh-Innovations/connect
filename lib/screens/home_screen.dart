import 'package:connect/consts/color_const.dart';
import 'package:connect/custom_widgets/tab_bar.dart';
import 'package:connect/screens/ai_chat_screen.dart';
import 'package:connect/screens/notification_screen.dart';
import 'package:connect/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

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
            padding:
                const EdgeInsets.only(top: 30, bottom: 15, left: 15, right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        maxRadius: 30,
                        minRadius: 18,
                        child: ClipOval(
                            child: Image.asset(
                                'assets/Avatar.png')), //**User Image will come from database */
                      ),
                    ),
                    8.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Jhon Doe"
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
                    const Spacer(),
                    Row(
                      children: [
                        /// --> Notification Button Icon <-- //
                        GestureDetector(
                          onTap: () {
                            // WIll take to notification sccreen
                            Get.to(() => const NotificationScreen());
                          },
                          child: Icon(
                            CupertinoIcons.bell_fill,
                            color: whiteColor,
                            size: 25.h,
                          ),
                        ),
                        5.widthBox,
                        // ---> More Button <---//
                        GestureDetector(
                          onTap: () {
                            //FUNCTION need to add what will happen clicking the More button
                          },
                          child: Icon(
                            Icons.more_vert_sharp,
                            color: whiteColor,
                            size: 25.h,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                8.h.heightBox,

                /// ----> Search Bar Option Inside The Header Container <---- ////
                VxTextField(
                  onChanged: (value) {
                    // Handle search logic here to Intregate Search
                  },
                  borderType: VxTextFieldBorderType.roundLine,
                  fillColor: Colors.grey[200],
                  hint: 'Search in chat...',
                  autofocus: false,
                  height: 30.h,
                  borderRadius: 10,
                  prefixIcon: Icon(CupertinoIcons.search,
                      size: 25.h, color: Colors.grey),
                  showCursor: false,
                  clear: true,
                )
              ],
            ),
          ).box.size(width, height * 0.22).color(primaryColor).make(),

          /// ----> This Expanded Part is SHOWING TAB BAR with Two Option Chat And Calls <---- ///
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
              // Get.to(() => AiChatScreen()); AI chat Option Removed
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
