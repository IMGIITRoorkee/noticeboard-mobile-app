import 'dart:async';
import 'dart:developer';
import 'package:noticeboard/bloc/list_notices_bloc.dart';
import 'package:noticeboard/global/global_functions.dart';
import 'package:noticeboard/models/notice_content.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/routes/routing_constants.dart';
import 'package:noticeboard/services/api_service/api_service.dart';
import '../../global/global_constants.dart';
import '../../models/user_tokens.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class AuthRepository {
  AuthService _authService = AuthService();

  Future signInWithUsernamePassword(
      {String? username,
      String? password,
      required BuildContext context}) async {
    try {
      var userObj = {"username": username, "password": password};
      RefreshToken _refreshTokenObj =
          await _authService.fetchUserTokens(userObj);
      await _authService.storeRefreshToken(_refreshTokenObj);
      await _authService.initHandle();
      UserProfile userProfile = (await fetchUserProfile(context))!;
      await _authService.registerNotificationToken();
      await _authService.storeProfile(userProfile);
      previousRoute = loginRoute;
      navigatorKey.currentState!.pushNamed(bottomNavigationRoute);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future checkIfAlreadySignedIn(String? initialNotice) async {
    RefreshToken refreshToken = await _authService.fetchRefreshToken();
    await Future.delayed(Duration(seconds: 1));
    previousRoute = launchingRoute;
    log(previousRoute);
    if (refreshToken.refreshToken != null) {
      await _authService.initHandle();
      if (initialNotice != null) {
        try {
          NoticeContent notice = await ApiService().fetchNoticeContent(
            int.parse(initialNotice),
          );
          NoticeIntro noticeIntro = NoticeIntro(
            id: notice.id,
            title: notice.title,
            dateCreated: notice.dateCreated,
            department: notice.department,
            read: notice.read,
            starred: notice.starred,
          );
          // This is to let the list_notices_bloc mark read sink no to not call update UI func
          noticeIntro.fromDeepLink = true;
          // print(notice.content);
          //If notice is accessed via deeplink , then also state shud be marked as read
          final ListNoticesBloc listNoticesBloc = ListNoticesBloc();
          listNoticesBloc.markReadSink.add(noticeIntro);
          navigatorKey.currentState!.pushNamed(
            noticeDetailRoute,
            arguments: noticeIntro,
          );
        } catch (e) {
          showGenericError();
          navigatorKey.currentState!.pushNamed(bottomNavigationRoute);
        }
      } else {
        navigatorKey.currentState!.pushNamed(bottomNavigationRoute);
      }
    } else {
      navigatorKey.currentState!.pushNamed(loginRoute);
    }
  }

  Future<UserProfile?> fetchUserProfile(BuildContext context) async {
    try {
      UserProfile userProfileObj = await _authService.fetchUserProfile();

      return userProfileObj;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Problem fetching profile"),
      ));
      return null;
    }
  }

  Future logout() async {
    try {
      await _authService.deRegisterNotificationToken();
      await _authService.deleteRefreshToken();
    } catch (e) {}
  }

  Future<UserProfile> fetchProfileFromStorage() async {
    UserProfile userProfile = await _authService.fetchProfileFromStorage();
    return userProfile;
  }
}
