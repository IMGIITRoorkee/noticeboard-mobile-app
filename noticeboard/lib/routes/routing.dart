import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/screens/profile.dart';
import './routing_constants.dart';
import '../screens/login.dart';
import '../models/user_profile.dart';
import '../screens/list_notices.dart';
import '../screens/launching.dart';
import '../models/notice_intro.dart';
import '../screens/notice_detail.dart';
import '../screens/filters.dart';

class MyRouter {
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
      case listNoticesRoute:
        ListNoticeMetaData listNoticeMetaData = settings.arguments;

        return MaterialPageRoute(
            builder: (context) => ListNotices(
                  listNoticeMetaData: listNoticeMetaData,
                ));
      case noticeDetailRoute:
        NoticeIntro noticeIntro = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => NoticeDetail(
                  noticeIntro: noticeIntro,
                ));
      case filterRoute:
        return MaterialPageRoute(builder: (context) => Filters());
      default:
        return MaterialPageRoute(builder: (context) => Login());
    }
  }
}
