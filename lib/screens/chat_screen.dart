import 'package:connect/custom_widgets/custom_listtile_chat.dart';
import 'package:connect/screens/chat_inside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@Description: This is chat screen displaying user CHat list
///@params:It contains User chat list person avatar ,name,last send message, and time of sending
class ChatScreenConnect extends StatelessWidget {
  const ChatScreenConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, inded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: () {
                Get.to(() =>
                    ChatInsideScreen()); //Here it need to set So  that It goes to ChatInsideScreen According to Index
              },
              // --> Using CustomListTileChat Designn <-- //
              child: CustomListTileChat(context),
            ),
          );
        });
  }
}
