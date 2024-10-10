import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

///@description:Custom ListTile Style for Chat Tile
///@param: last message,name,time
Widget customListTileChat(BuildContext context, String name, String msg, DateTime time) {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;

  String formatCurrentTime() {
  // Get current time

  // Format time as 'hh.mm a' (11.20 PM)
  final formatter = DateFormat('hh.mm a');
  return formatter.format(time);
}
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
    title: name.text.make(), //User Name You can Make param for this
    subtitle: msg.text.make(), //user last message
    trailing: formatCurrentTime().text.make(), //time of sending
  ).box.size(width, height * 0.09).make();
}
