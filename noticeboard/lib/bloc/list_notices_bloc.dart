import 'dart:async';
import 'package:noticeboard/models/paginated_info.dart';
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
  bool lazyLoad = false;
  List<NoticeIntro> dynamicNoticeList;
  bool hasMore = true;

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
      _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchInstituteNotices(page);
        List<NoticeIntro> allInstituteNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allInstituteNotices;
        } else {
          dynamicNoticeList.addAll(allInstituteNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchPlacementNotices) {
      _appBarLabelSink.add(listNoticeMetaData.appBarLabel);
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchPlacementNotices(page);
        List<NoticeIntro> allPlacementNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allPlacementNotices;
        } else {
          dynamicNoticeList.addAll(allPlacementNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
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
        PaginatedInfo paginatedInfo = await _listNoticesRepository
            .fetchFilteredNotices(filterResult.endpoint, page);
        List<NoticeIntro> allFilteredNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allFilteredNotices;
        } else {
          dynamicNoticeList.addAll(allFilteredNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchImportantNotices) {
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchImportantNotices(page);
        List<NoticeIntro> allImportantNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allImportantNotices;
        } else {
          dynamicNoticeList.addAll(allImportantNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchExpiredNotices) {
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchExpiredNotices(page);
        List<NoticeIntro> allExpiredNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allExpiredNotices;
        } else {
          dynamicNoticeList.addAll(allExpiredNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
      } catch (e) {
        _listNoticesSink.addError(e.message.toString());
      }
    } else if (dynamicFetch == DynamicFetch.fetchBookmarkedNotices) {
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchBookmarkedNotices(page);
        List<NoticeIntro> allBookmarkedNotices = paginatedInfo.list;
        if (!paginatedInfo.hasMore) hasMore = false;
        if (!lazyLoad) {
          dynamicNoticeList = allBookmarkedNotices;
        } else {
          dynamicNoticeList.addAll(allBookmarkedNotices);
        }
        _listNoticesSink.add(dynamicNoticeList);
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

  void refreshNotices() {
    page = 1;
    lazyLoad = false;
    dynamicFetchNotices();
  }

  void loadMore() {
    if (hasMore) {
      page++;
      lazyLoad = true;
      dynamicFetchNotices();
    }
  }

  void pushFilters() async {
    Navigator.pushNamed(context, filterRoute).then((value) {
      page = 1;
      hasMore = true;
      lazyLoad = false;
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
