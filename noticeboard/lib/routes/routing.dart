import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_detail_route_arguments.dart';
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
        NoticeDetailArgument noticeDetailArgument =
            settings.arguments as NoticeDetailArgument;
            if(!noticeDetailArgument.goingtoPrevNotice){
              return MaterialPageRoute(
            builder: (context) => NoticeDetail(
                  noticeIntro: noticeDetailArgument.noticeIntro,
                  listOfNotices: noticeDetailArgument.listOfNotices,
                  listNoticesBloc: noticeDetailArgument.listNoticesBloc,
                )
                );
            }
            else{
              return PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) => NoticeDetail(
                  noticeIntro: noticeDetailArgument.noticeIntro,
                  listOfNotices: noticeDetailArgument.listOfNotices,
                  listNoticesBloc: noticeDetailArgument.listNoticesBloc,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
    var begin = Offset(-1.0, 0.0); // Start the animation from the left
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  },
                );
            }
        
      default:
        return MaterialPageRoute(builder: (context) => Launcher());
    }
  }
}
