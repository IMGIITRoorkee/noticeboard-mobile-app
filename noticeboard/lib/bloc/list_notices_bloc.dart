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
  int page = 1;

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
    _listNoticesSink.add(null);
    if (dynamicFetch == DynamicFetch.fetchInstituteNotices) {
      _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      try {
        List<NoticeIntro> allinstituteNotices =
            await _listNoticesRepository.fetchInstituteNotices(page);
        _listNoticesSink.add(allinstituteNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchPlacementNotices) {
      _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      try {
        List<NoticeIntro> allPlacementNotices =
            await _listNoticesRepository.fetchPlacementNotices(page);
        _listNoticesSink.add(allPlacementNotices);
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
            filterResult.endpoint += '&banner=82';
        }

        List<NoticeIntro> allFilteredNotices = await _listNoticesRepository
            .fetchFilteredNotices(filterResult.endpoint, page);
        _listNoticesSink.add(allFilteredNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchImportantNotices) {
      try {
        List<NoticeIntro> allImportantNotices =
            await _listNoticesRepository.fetchImportantNotices(page);
        _listNoticesSink.add(allImportantNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchExpiredNotices) {
      try {
        List<NoticeIntro> allExpiredNotices =
            await _listNoticesRepository.fetchExpiredNotices(page);
        _listNoticesSink.add(allExpiredNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchBookmarkedNotices) {
      try {
        List<NoticeIntro> allBookmarkedNotices =
            await _listNoticesRepository.fetchBookmarkedNotices(page);
        _listNoticesSink.add(allBookmarkedNotices);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    }
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    Navigator.pushNamed(context, noticeDetailRoute, arguments: noticeIntro);
  }

  void disposeStreams() {
    _eventController.close();
    _listNoticesController.close();
    _toggleBookmarkController.close();
    _appBarLabelController.close();
    _markReadController.close();
    _markUnreadController.close();
  }

  void loadMore() {
    page++;
    dynamicFetchNotices();
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
