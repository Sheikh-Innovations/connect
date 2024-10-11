import 'package:connect/data/bindings/binding.dart';
import 'package:connect/data/models/local/message_hive_data.dart';

import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/screens/splash_screen.dart';
import 'package:connect/utils/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and HiveService singleton

  await Hive.initFlutter();
  await HiveService.instance.adapterInit(); // Register the adapter
  await HiveService.instance.boxInit();
  //  HiveService.instance.saveOrUpdateInbox(MessageHiveData(
  //                 senderId: "75",
  //                 message: 'Hi',
  //                 name: 'Farhana',
  //                 isSeen: false,
  //                 isTyping: false,
  //                 timestamp: DateTime.now()));
 NotificationManager.instance.init();
  runApp(const ConnectApp());
  // Open the box
}

class ConnectApp extends StatelessWidget {
  const ConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Connect',
          debugShowCheckedModeBanner: false,
          initialBinding: DependencyBinding(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
