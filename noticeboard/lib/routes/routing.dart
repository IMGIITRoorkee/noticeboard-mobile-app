import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/screens/bottom_navigation.dart';
import 'package:noticeboard/screens/profile.dart';
import './routing_constants.dart';
import '../screens/login.dart';
import '../screens/list_notices.dart';
import '../screens/launching.dart';
import '../models/notice_intro.dart';
import '../screens/notice_detail.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launchingRoute:
        return MaterialPageRoute(builder: (context) => Launcher());
        break;
      case loginRoute:
        return MaterialPageRoute(builder: (context) => Login());
        break;
      case bottomNavigationRoute:
        return MaterialPageRoute(builder: (context) => MyBottomNavigationBar());
        break;
      case profileRoute:
        return MaterialPageRoute(builder: (context) => Profile());
        break;
      case listNoticesRoute:
        ListNoticeMetaData listNoticeMetaData = settings.arguments;

        return MaterialPageRoute(
            builder: (context) => ListNotices(
                  listNoticeMetaData: listNoticeMetaData,
                ));
        break;
      case noticeDetailRoute:
        NoticeIntro noticeIntro = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => NoticeDetail(
                  noticeIntro: noticeIntro,
                ));
        break;
    }
  }
}
