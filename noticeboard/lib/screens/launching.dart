import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noticeboard/routes/routing_constants.dart';
import 'package:noticeboard/styles/launching_constants.dart';
import 'package:noticeboard/styles/profile_constants.dart';
import 'package:uni_links/uni_links.dart';
import '../global/global_constants.dart';
import '../models/notice_content.dart';
import '../models/notice_intro.dart';
import '../services/api_service/api_service.dart';
import '../services/auth/auth_repository.dart';
import '../global/global_functions.dart';
import '../styles/login_constants.dart';

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  final _authRepository = AuthRepository();
  late StreamSubscription _sub;

  @override
  void initState() {
    initiateBrain();
    super.initState();
  }

  Future initiateBrain() async {
    try {
      String? noticeFromLink = await initUniLinks();
      await _authRepository.checkIfAlreadySignedIn(noticeFromLink);
    } catch (e) {
      showGenericError();
      logout();
    }
  }

  Future<String?> initUniLinks() async {
    // ... check initialLink
    // Uri parsing may fail, so we use a try/catch FormatException.
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        var pathSegs = initialUri.pathSegments;
        log(pathSegs.toString());
        if (pathSegs[pathSegs.length - 2] == "notice") {
          return pathSegs.last;
        }
      }
      // Use the uri and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on FormatException {
      // Handle exception by warning the user their action did not succeed
      return null;
    }
    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) async {
      // Parse the link and warn the user, if it is not correct
      if (link != null) {
        Uri uri = Uri.parse(link);
        log(uri.pathSegments.toString());
        var pathSegs = uri.pathSegments;
        if (pathSegs[pathSegs.length - 1] == "notice") {
          try {
            NoticeContent notice = await ApiService().fetchNoticeContent(
              int.parse(pathSegs.last),
            );
            NoticeIntro noticeIntro = NoticeIntro(
              id: notice.id,
              title: notice.title,
              dateCreated: notice.dateCreated,
              department: notice.department,
              read: notice.read,
              starred: notice.starred,
            );
            // print(notice.content);
            navigatorKey.currentState!.pushNamed(
              noticeDetailRoute,
              arguments: noticeIntro,
            );
          } catch (e) {
            showGenericError();
            navigatorKey.currentState!.pushNamed(bottomNavigationRoute);
          }
        }
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      showGenericError();
    });
    return null;
    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  Future logout() async {
    await _authRepository.logout();
    navigatorKey.currentState!.pushNamed(loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: globalWhiteColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: _width,
          height: _height,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: mainLaunchingLogo(_width, _height))),
              Positioned(left: 0, right: 0, bottom: 80, child: spinner()),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: lotsOfLove(context, _width))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
