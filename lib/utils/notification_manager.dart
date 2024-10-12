import 'dart:io';

import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


// Top-level function for background notification handling
@pragma('vm:entry-point')
void backgroundNotificationHandler(NotificationResponse details) {
  if (kDebugMode) {
    print('button pressed');
  } // Handle the background notification response
}

class NotificationManager {
  static final NotificationManager _instance =
      NotificationManager._privateConstructor();
  factory NotificationManager() => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var appName = 'Connect';

  static NotificationManager get instance => _instance;
  NotificationManager._privateConstructor();

  Future<void> init() async {
  
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );
  }

  Future<void> showChatNotification({
    required ShowPluginNotificationModel model,
    required String userImage,
    String makeAsRead = "Make as read",
    String reply = "Reply",
    String yourMessage = "Your message...",

    ///Username in the icon person!
    required String userName,
    List<Message>? messages,

    ///for group chat
    required String? conversationTitle,
  }) async {
    File? file;
    try {
      file = await DefaultCacheManager().getSingleFile(userImage);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    final messagingStyleInformation = MessagingStyleInformation(
      Person(
        important: true,
        name: userName,
      ),
      conversationTitle: conversationTitle,
      groupConversation: true,
      messages: messages ??
          [
            Message(
              model.body,
              DateTime.now().toLocal(),
              Person(
                important: true,
                name: userName,
                icon:
                    file == null ? null : BitmapFilePathAndroidIcon(file.path),
              ),
            ),
          ],
    );

    model.androidNotificationDetails = _highAndroidNotificationChatDetails(
      styleInformation: messagingStyleInformation,
      androidNotificationDetails: model.androidNotificationDetails,
      makeAsRead: makeAsRead,
      reply: reply,
      yourMessage: yourMessage,
    );
    return showPluginNotification(model);
  }

  Future<void> showPluginNotification(
    ShowPluginNotificationModel model,
  ) async {
    model.androidNotificationDetails ??= _highAndroidNotificationDetails;
    model.iosDetails ??= _highDarwinNotificationDetails;

    if (isMobile || Platform.isMacOS || Platform.isLinux) {
      await flutterLocalNotificationsPlugin.show(
        model.id,
        model.title,
        model.body,
        NotificationDetails(
          android: model.androidNotificationDetails,
          iOS: model.iosDetails,
          macOS: model.macOsDetails ??
              const DarwinNotificationDetails(
                presentSound: true,
                subtitle: 'Connect',
                presentBadge: true,
              ),
          linux: model.linux,
        ),
        payload: model.payload,
      );
    }
  }

  AndroidNotificationDetails get _highAndroidNotificationDetails =>
      AndroidNotificationDetails(
        "${appName}_notification",
        "${appName}_notification",
        channelDescription: "${appName}_notification_channel",
        importance: Importance.max,
        priority: Priority.max,
        setAsGroupSummary: true,
      );

  AndroidNotificationDetails _highAndroidNotificationChatDetails({
    required MessagingStyleInformation styleInformation,
    AndroidNotificationDetails? androidNotificationDetails,
    String makeAsRead = "Make as read",
    String reply = "Reply",
    String yourMessage = "Your message...",
  }) =>
      AndroidNotificationDetails(
        "${appName}_notification",
        "${appName}_notification",
        styleInformation: styleInformation,
        actions: [
          AndroidNotificationAction(
            "1",
            makeAsRead,
            showsUserInterface: true,
            cancelNotification: false,
          ),
          AndroidNotificationAction(
            "2",
            reply,
            allowGeneratedReplies: true,
            showsUserInterface: true,
            cancelNotification: false,
            inputs: [
              AndroidNotificationActionInput(
                label: yourMessage,
              )
            ],
          ),
        ],
        channelDescription: "${appName}_notification_channel",
        importance: Importance.max,
        priority: Priority.max,
        setAsGroupSummary: true,
      );

  DarwinNotificationDetails get _highDarwinNotificationDetails =>
      const DarwinNotificationDetails(
        badgeNumber: 1,
        presentSound: true,
        presentBadge: true,
      );

  
}

class ShowPluginNotificationModel {
  final int id;
  final String title;
  final String body;
  AndroidNotificationDetails? androidNotificationDetails;
  DarwinNotificationDetails? macOsDetails;
  final LinuxNotificationDetails? linux;
  DarwinNotificationDetails? iosDetails;
  final String? payload;

  ShowPluginNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.androidNotificationDetails,
    this.iosDetails,
    this.linux,
    this.macOsDetails,
    this.payload,
  });
}

bool get isMobile {
  return Platform.isAndroid || Platform.isIOS;
}

@pragma('vm:entry-point')
void _onDidReceiveNotificationResponse(NotificationResponse details) {
  if (details.actionId == "1") {
    // Handle "Mark as read" action
    if (kDebugMode) {
      print("Mark as read clicked");
    }
  } else if (details.actionId == "2") {
    final replyText = details.input;
    Get.find<HomeController>()
        .sendMessage(details.payload ?? '', replyText ?? '');
    // Handle reply action and extract the input

    if (kDebugMode) {
      print("Reply received: $replyText");
    }
  }
}
