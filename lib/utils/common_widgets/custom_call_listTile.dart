import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: Custom list tile for Call
///@param: user name,time,incoming or outgoing,
Widget CustomListTileCall(BuildContext context) {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;
  return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                maxRadius: 35,
                child: ClipOval(child: Image.asset('assets/Avatar.png')),
              ),
              Positioned(
                right: 8,
                bottom: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: "Virtual User".text.make(),
          subtitle: Row(
            children: [
              const Icon(
                Icons.call_received_rounded,
                color: Colors.redAccent,
              ),
              "September 8, 5.44 PM".text.make(),
            ],
          ),
          trailing: const Icon(CupertinoIcons.phone_solid))
      .box
      .size(width, height * 0.09)
      .make();
}
