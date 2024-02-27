import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/screens/bottom_navigation.dart';
import 'package:noticeboard/screens/profile.dart';
import './routing_constants.dart';
import '../screens/login.dart';
import '../screens/list_notices.dart';
import '../screens/launching.dart';
import '../screens/notice_detail.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launchingRoute:
        return MaterialPageRoute(builder: (context) => Launcher());
      case loginRoute:
        return MaterialPageRoute(builder: (context) => Login());
      case bottomNavigationRoute:
        return MaterialPageRoute(builder: (context) => MyBottomNavigationBar());
      case profileRoute:
        return MaterialPageRoute(builder: (context) => Profile());
      case listNoticesRoute:
        ListNoticeMetaData? listNoticeMetaData =
            settings.arguments as ListNoticeMetaData?;

        return MaterialPageRoute(
            builder: (context) => ListNotices(
                  listNoticeMetaData: listNoticeMetaData,
                ));
      case noticeDetailRoute:
        NoticeIntro? noticeIntro = settings.arguments as NoticeIntro?;
        return MaterialPageRoute(
            builder: (context) => NoticeDetail(
                  noticeIntro: noticeIntro,
                ));
      default:
        return MaterialPageRoute(builder: (context) => Launcher());
    }
  }
}
