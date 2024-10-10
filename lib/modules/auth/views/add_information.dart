import 'package:connect/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddDetailScreen extends StatelessWidget {
  final TextEditingController ctr = TextEditingController();

  AddDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            const CircleAvatar(
              radius: 50,
            ),
            SizedBox(
              height: 60.h,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300]),
              height: 55,
              child: TextFormField(
                controller: ctr,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  Get.find<AuthController>().updateName(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300], // Fill color
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    // Border
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // No side border
                  ),
                 
                ),
              ),
            ),
            SizedBox(height: 60.h),
            GetBuilder<AuthController>(builder: (controller) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    fixedSize: Size(context.width, 48.h),
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    controller.updateProfile(controller.name.value);
                  },
                  child: controller.isLoading.value
                      ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                      : Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ));
            }),
          ],
        ),
      ),
    );
  }
}
