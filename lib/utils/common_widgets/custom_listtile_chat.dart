import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

///@description:Custom ListTile Style for Chat Tile
///@param: last message,name,time
Widget customListTileChat(BuildContext context, String name, String msg,
    DateTime time, bool isOnline) {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;

  String formatCurrentTime(DateTime time) {
    // Get current UTC time
    DateTime utcNow = time.toUtc();

    // Convert to Bangladesh time (UTC+6)
    DateTime bangladeshTime = utcNow.add(const Duration(hours: 6));

    // Format time as 'hh.mm a' (11.20 PM)
    final formatter = DateFormat('hh.mm a');
    return formatter.format(bangladeshTime);
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
              color: isOnline
                  ? Colors.green
                  : Colors.grey, // Color of the small circle
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
    subtitle: limitTo22Characters(msg).text.make(), //user last message
    trailing: formatCurrentTime(time).text.make(), //time of sending
  ).box.size(width, height * 0.09).make();
}

String limitTo22Characters(String input) {
  // Check if the input is longer than 20 characters
  if (input.length > 22) {
    // Truncate and add ellipsis
    return '${input.substring(0, 22)}...';
  }
  // If the string is 20 characters or less, return it as is
  return input;
}
