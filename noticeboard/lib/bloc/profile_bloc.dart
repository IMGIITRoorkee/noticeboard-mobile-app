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
      }
    });
  }

  void pushBookmarkedNotices() {
    ListNoticeMetaData bookmarkListNoticeMetaData = ListNoticeMetaData(
        appBarLabel: 'Bookmarked Notices',
        dynamicFetch: DynamicFetch.fetchBookmarkedNotices,
        noFilters: true,
        isSearch: false);
    Navigator.pushNamed(context, listNoticesRoute,
        arguments: bookmarkListNoticeMetaData);
  }

  void feedbackHandler() async {
    const String playStoreurl =
        'https://play.google.com/store/apps/details?id=com.img.noticeboard&hl=en_US&gl=IN';
    const String iosUrl =
        "https://www.apple.com/in/app-store/"; // TODO: Change to actual app url on app store

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

  void disposeStreams() {
    _eventController.close();
  }
}
