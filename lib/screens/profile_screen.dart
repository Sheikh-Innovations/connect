import 'package:connect/custom_widgets/custom_profile_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

///@description: Profile Screen
///@parama: User Image,name,id,number,mail
///CustomListTileChat design used
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            CupertinoIcons.back,
            size: 25.h,
          ),
        ),
        title: "Profile".text.make(),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //User Image
        CircleAvatar(
          maxRadius: 45,
          minRadius: 18,
          child: ClipOval(child: Image.asset('assets/Avatar.png')), //image path
        ),
        20.heightBox,
        CustomRow(
            icon: CupertinoIcons.person,
            text: "JHON DOe",
            context: context), //Nmae
        15.heightBox,
        CustomRow(
            icon: CupertinoIcons.number,
            text: "User Id",
            context: context), //Id
        15.heightBox,
        CustomRow(
            icon: CupertinoIcons.mail,
            text: "jhondoe@mail.com", //Mail
            context: context),
        15.heightBox,
        CustomRow(
            icon: CupertinoIcons.phone,
            text: "+00000000000",
            context: context), //Number
      ])),
    );
  }
}
