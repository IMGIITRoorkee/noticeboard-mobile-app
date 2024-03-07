import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String previousRoute = "";

SnackBar noprevNoticeSnackBar =
    const SnackBar(content: Text("You are already on the latest notice!"));
