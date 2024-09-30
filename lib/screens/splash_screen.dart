import 'package:connect/consts/color_const.dart';
import 'package:connect/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

///@Description: Simple Splash Screen with logo and appname
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds before navigating to HomeScreen
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const HomeScreen());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/connectAppLogo.png',
                height: 200.h,
                width: 200.h,
              ),
            ),
            "Connect".text.size(35.h).color(primaryColor).makeCentered(),
          ],
        ),
      ),
    );
  }
}
