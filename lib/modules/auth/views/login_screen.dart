import 'package:connect/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GetBuilder<AuthController>(builder: (controller) {
            return Form(
              key: controller.formKey, // Use controller's formKey
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Text(
                    'CONNECT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 80.h),
                  IntlPhoneField(
                    disableLengthCheck: true,
                    validator: (value) {
                      if (value == null || value.completeNumber.isEmpty) {
                        return "required";
                      }
                      return null;
                    },
                    dropdownTextStyle: const TextStyle(color: Colors.black),
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.w,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.w,
                          color: Colors.grey,
                        ),
                      ),
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    initialCountryCode: 'BD',
                    onChanged: (phone) {
                      controller.updatePhoneNumber(phone
                          .completeNumber); // Update the phone number in the controller
                      print(controller
                          .phoneNumber.value); // You can observe this if needed
                    },
                  ),
                  SizedBox(height: 50.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: const BeveledRectangleBorder(),
                      fixedSize: Size(context.width, 48.h),
                    ),
                    onPressed: () {
                      if (controller.phoneNumber.isNotEmpty) {
                        // Call the login handler
                        controller.loginUser(
                            controller.phoneNumber.value.trim(),
                            controller.generateRandomString(30));
                      }
                      // Call the login handler
                    },
                    child: controller.isLoading.value
                        ? const CupertinoActivityIndicator(
                          color: Colors.white,
                        )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
