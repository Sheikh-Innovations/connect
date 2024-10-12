import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:connect/utils/common_widgets/custom_listtile_chat.dart';
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
    return GetBuilder<HomeController>(builder: (ctr) {
      return ListView.builder(
          itemCount: ctr.inboxMessages.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ChatInsideScreen(
                        name: ctr.inboxMessages[index].name,
                        senderId: ctr.inboxMessages[index].senderId,
                      ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(microseconds: 100)
                      ); //Here it need to set So  that It goes to ChatInsideScreen According to Index
                },
                // --> Using CustomListTileChat Designn <-- //
                child: customListTileChat(
                    context,
                    ctr.inboxMessages[index].name,
                    ctr.inboxMessages[index].message,
                    ctr.inboxMessages[index].timestamp,
                    ctr.isOnline(ctr.inboxMessages[index].senderId)
                    
                    ),
              ),
            );
          });
    });
  }
}
