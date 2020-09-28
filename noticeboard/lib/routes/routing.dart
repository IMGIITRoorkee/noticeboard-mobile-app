import 'package:flutter/material.dart';
import 'package:noticeboard/screens/profile.dart';
import './routing_constants.dart';
import '../screens/login.dart';
import '../models/user_profile.dart';
import '../screens/institute_notices.dart';
import '../screens/launching.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launchingRoute:
        return MaterialPageRoute(builder: (context) => Launcher());
      case loginRoute:
        return MaterialPageRoute(builder: (context) => Login());
      case profileRoute:
        UserProfile userProfile = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => Profile(
                  userProfile: userProfile,
                ));
      case instituteNoticesRoute:
        return MaterialPageRoute(builder: (context) => Home());
    }
  }
}
