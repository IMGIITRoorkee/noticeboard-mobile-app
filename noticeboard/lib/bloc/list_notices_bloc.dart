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

  final _noticeObjController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get noticeObjSink => _noticeObjController.sink;
  Stream<NoticeIntro> get _noticeObjStream => _noticeObjController.stream;

  final _appBarLabelController = StreamController<String>();
  StreamSink<String> get _appBarLabelSink => _appBarLabelController.sink;
  Stream<String> get appBarLabelStream => _appBarLabelController.stream;

  ListNoticesRepository _listNoticesRepository = ListNoticesRepository();

  ListNoticesBloc() {
    _eventStream.listen((event) async {
      if (event == ListNoticesEvent.pushProfileEvent) {
        _listNoticesRepository.pushProfileScreen(context);
      } else if (event == ListNoticesEvent.pushFilters) {
        pushFilters();
      }
    });

    _noticeObjStream.listen((object) async {
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
    } else if (dynamicFetch == DynamicFetch.fetchFilterNotices) {
      try {
        if (filterResult.label != null)
          _appBarLabelSink.add(filterResult.label);
        else
          _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
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
    _noticeObjController.close();
    _appBarLabelController.close();
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
