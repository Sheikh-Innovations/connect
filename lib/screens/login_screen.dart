import 'package:connect/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtr = TextEditingController();

  String? _number;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
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
                  controller: phoneCtr,
                  validator: (value) {
                    if (value!.completeNumber.isEmpty) {
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
                    // fillColor: otpFill,
                    // filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.w,
                        color: Colors.grey,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
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
                    _number = phone.completeNumber;
                    print(_number);
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

                           Get.off(() => const HomeScreen());
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                // _buildLoginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
