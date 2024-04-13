import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:noticeboard/services/auth/auth_service.dart';

class NotificationService {
  AuthService _auth = AuthService();
  Future<void> setUpBackgroundNotifs() async {
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      _auth.registerNotificationToken();
      log('User granted permission: ${settings.authorizationStatus}');
    }
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  }

  Future<void> setUpForegroundNotifs() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }
  }
}
