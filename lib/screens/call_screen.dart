import 'package:connect/utils/common_widgets/custom_call_listTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///@Description: This Displays calls History of User
///@Param: last call , time, name
class CallScreenConnect extends StatelessWidget {
  const CallScreenConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, inded) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
    
              /// --> CustomListTileCall Design <--- ///
              child: CustomListTileCall(context));
        });
  }
}
