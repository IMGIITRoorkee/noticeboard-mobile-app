import 'dart:async';
import 'package:noticeboard/repository/list_notices_repository.dart';
import '../models/notice_intro.dart';
import '../enum/list_notices_enum.dart';
import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../models/filters_list.dart';

class ListNoticesBloc {
  BuildContext context;
  DynamicFetch dynamicFetch;
  FilterResult filterResult;
  ListNoticeMetaData listNoticeMetaData;

  final _eventController = StreamController<ListNoticesEvent>();
  StreamSink<ListNoticesEvent> get eventSink => _eventController.sink;
  Stream<ListNoticesEvent> get _eventStream => _eventController.stream;

  final _listNoticesController = StreamController<List<NoticeIntro>>();
  StreamSink<List<NoticeIntro>> get _listNoticesSink =>
      _listNoticesController.sink;
  Stream<List<NoticeIntro>> get listNoticesStream =>
      _listNoticesController.stream;

  final _toggleBookmarkController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get toggleBookMarkSink =>
      _toggleBookmarkController.sink;
  Stream<NoticeIntro> get _toggleBookMarkStream =>
      _toggleBookmarkController.stream;

  final _appBarLabelController = StreamController<String>();
  StreamSink<String> get _appBarLabelSink => _appBarLabelController.sink;
  Stream<String> get appBarLabelStream => _appBarLabelController.stream;

  final _markReadController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get markReadSink => _markReadController.sink;
  Stream<NoticeIntro> get _markReadStream => _markReadController.stream;

  final _markUnreadController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get markUnreadSink => _markUnreadController.sink;
  Stream<NoticeIntro> get _markUnreadStream => _markUnreadController.stream;

  ListNoticesRepository _listNoticesRepository = ListNoticesRepository();

  ListNoticesBloc() {
    _eventStream.listen((event) async {
      if (event == ListNoticesEvent.pushProfileEvent) {
        _listNoticesRepository.pushProfileScreen(context);
      } else if (event == ListNoticesEvent.pushFilters) {
        pushFilters();
      }
    });

    _markReadStream.listen((object) async {
      var obj = {
        "keyword": "read",
        "notices": [object.id]
      };
      await _listNoticesRepository.markReadUnreadNotice(obj);
      dynamicFetchNotices();
    });

    _markUnreadStream.listen((object) async {
      var obj = {
        "keyword": "unread",
        "notices": [object.id]
      };
      await _listNoticesRepository.markReadUnreadNotice(obj);
      dynamicFetchNotices();
    });

    _toggleBookMarkStream.listen((object) async {
      if (object.starred) {
        var obj = {
          "keyword": "unstar",
          "notices": [object.id]
        };
        await _listNoticesRepository.unbookmarkNotice(obj);
      } else {
        var obj = {
          "keyword": "star",
          "notices": [object.id]
        };
        await _listNoticesRepository.bookmarkNotice(obj);
      }
      dynamicFetchNotices();
    });
  }

  void dynamicFetchNotices() async {
    if (dynamicFetch == DynamicFetch.fetchInstituteNotices) {
      try {
        List<NoticeIntro> allinstituteNotices =
            await _listNoticesRepository.fetchInstituteNotices();
        _listNoticesSink.add(allinstituteNotices);
        _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchPlacementNotices) {
      try {
        List<NoticeIntro> allPlacementNotices =
            await _listNoticesRepository.fetchPlacementNotices();
        _listNoticesSink.add(allPlacementNotices);
        _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchFilterNotices) {
      try {
        if (filterResult.label != null)
          _appBarLabelSink.add(filterResult.label);
        else {
          _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
          if (listNoticeMetaData.dynamicFetch ==
              DynamicFetch.fetchPlacementNotices)
            filterResult.endpoint += '&banner=1';
        }
        print(filterResult.endpoint);
        List<NoticeIntro> allFilteredNotices = await _listNoticesRepository
            .fetchFilteredNotices(filterResult.endpoint);
        _listNoticesSink.add(allFilteredNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    }
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    Navigator.pushNamed(context, noticeDetailRoute, arguments: noticeIntro)
        .then((value) => dynamicFetchNotices());
  }

  void disposeStreams() {
    _eventController.close();
    _listNoticesController.close();
    _toggleBookmarkController.close();
    _appBarLabelController.close();
    _markReadController.close();
    _markUnreadController.close();
  }

  void pushFilters() async {
    Navigator.pushNamed(context, filterRoute).then((value) {
      if (value != null) {
        filterResult = value;
        dynamicFetch = DynamicFetch.fetchFilterNotices;
        dynamicFetchNotices();
      } else {
        dynamicFetch = listNoticeMetaData.dynamicFetch;
        dynamicFetchNotices();
      }
    });
  }
}
