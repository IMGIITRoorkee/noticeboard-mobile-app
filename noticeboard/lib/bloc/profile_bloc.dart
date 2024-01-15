import 'dart:async';
import 'dart:io';
import 'package:noticeboard/enum/dynamic_fetch_enum.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:noticeboard/routes/routing_constants.dart';
import 'package:noticeboard/services/endpoints/urls.dart';
import '../enum/profile_enum.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/global_constants.dart';

class ProfileBloc {
  late BuildContext context;

  final _eventController = StreamController<ProfileEvents>();
  StreamSink<ProfileEvents> get eventSink => _eventController.sink;
  Stream<ProfileEvents> get _eventStream => _eventController.stream;

  ProfileRepository _profileRepository = ProfileRepository();

  ProfileBloc() {
    _eventStream.listen((event) {
      if (event == ProfileEvents.logoutEvent) {
        _profileRepository.logout(context);
      } else if (event == ProfileEvents.bookmarksEvent) {
        pushBookmarkedNotices();
      } else if (event == ProfileEvents.feedbackEvent) {
        feedbackHandler();
      } else if (event == ProfileEvents.notificationSettingsEvent) {
        notificationSettingsHandler();
      } else if (event == ProfileEvents.aboutUsEvent) {
        aboutUsHandler();
      }
    });
  }

  void pushBookmarkedNotices() {
    ListNoticeMetaData bookmarkListNoticeMetaData = ListNoticeMetaData(
        appBarLabel: 'Bookmarked Notices',
        dynamicFetch: DynamicFetch.fetchBookmarkedNotices,
        noFilters: true,
        isSearch: false);
    previousRoute = profileRoute;
    navigatorKey.currentState!
        .pushNamed(listNoticesRoute, arguments: bookmarkListNoticeMetaData);
  }

  void feedbackHandler() async {
    const String playStoreurl =
        'https://play.google.com/store/apps/details?id=com.img.noticeboard&hl=en_US&gl=IN';
    const String iosUrl =
        "https://apps.apple.com/in/app/channel-i-noticeboard/id6443708603"; 

    late String url;

    if (Platform.isIOS) {
      url = iosUrl;
    } else {
      url = playStoreurl;
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void notificationSettingsHandler() async {
    const url = '${BASE_URL}settings/manage_notifications';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void aboutUsHandler() async {
    const url = "https://channeli.in/maintainer_site/";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    }
  }

  void disposeStreams() {
    _eventController.close();
  }
}
