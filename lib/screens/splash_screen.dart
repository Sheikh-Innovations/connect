import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/utils/consts/color_const.dart';
import 'package:connect/screens/home_screen.dart';
import 'package:connect/modules/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
    checkAndRequestNotificationPermission();
    // Delay for 2 seconds before navigating to HomeScreen
    Future.delayed(const Duration(seconds: 2), () {
      if (HiveService.instance.userData?.token == null) {
        Get.off(() => const LoginPage());
      } else {
        Get.off(() => const HomeScreen());
      }
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
                height: 80.h,
                width: 80.h,
              ),
            ),
            "CONNECT".text.size(25.sp).color(primaryColor).makeCentered(),
          ],
        ),
      ),
    );
  }

  Future<void> checkAndRequestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      // Request permission
      PermissionStatus result = await Permission.notification.request();

      if (result.isGranted) {
        print('Notification permission granted.');
      } else {
        print('Notification permission denied.');
      }
    } else if (status.isGranted) {
      print('Notification permission already granted.');
    }
  }
}
