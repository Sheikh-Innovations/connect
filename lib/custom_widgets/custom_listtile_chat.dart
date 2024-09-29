import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

///@description:Custom ListTile Style for Chat Tile
///@param: last message,name,time
Widget CustomListTileChat(BuildContext context) {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;
  return ListTile(
    leading: Stack(
      children: [
        CircleAvatar(
          maxRadius: 35,
          child: ClipOval(
              child:
                  Image.asset('assets/Avatar.png')), // here goes the user image
        ),
        Positioned(
          right: 8,
          bottom: 0,
          child: Container(
            width: 15, // Size of the smaller circle
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green, // Color of the small circle
              border: Border.all(
                color: Colors
                    .white, // Optional: Border color around the small circle
                width: 2, // Optional: Border width
              ),
            ),
          ),
        ),
      ],
    ),
    title: "Virtual User".text.make(), //User Name You can Make param for this
    subtitle: "Last Sent Message of user".text.make(), //user last message
    trailing: "11.20 PM".text.make(), //time of sending
  ).box.size(width, height * 0.09).make();
}
