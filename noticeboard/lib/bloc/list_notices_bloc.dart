import 'dart:async';
import 'package:noticeboard/models/paginated_info.dart';
import 'package:noticeboard/repository/list_notices_repository.dart';
import '../global/global_constants.dart';
import '../models/notice_intro.dart';
import '../enum/list_notices_enum.dart';
import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../models/filters_list.dart';

class ListNoticesBloc {
  BuildContext? context;
  DynamicFetch? dynamicFetch;
  late FilterResult filterResult;
  ListNoticeMetaData? listNoticeMetaData;
  int page = 1;
  bool lazyLoad = false;
  List<NoticeIntro?>? dynamicNoticeList;
  bool hasMore = true;
  bool isLoading = false;
  bool filterVisibility = false;

  String searchQuery = ''; // search
  bool isSearching = false; // search

  final _eventController = StreamController<ListNoticesEvent>();
  StreamSink<ListNoticesEvent> get eventSink => _eventController.sink;
  Stream<ListNoticesEvent> get _eventStream => _eventController.stream;

  final _listNoticesController = StreamController<PaginatedInfo?>();
  StreamSink<PaginatedInfo?> get _listNoticesSink =>
      _listNoticesController.sink;
  Stream<PaginatedInfo?> get listNoticesStream => _listNoticesController.stream;

  final _toggleBookmarkController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get toggleBookMarkSink =>
      _toggleBookmarkController.sink;
  Stream<NoticeIntro> get _toggleBookMarkStream =>
      _toggleBookmarkController.stream;

  final _markReadController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get markReadSink => _markReadController.sink;
  Stream<NoticeIntro> get _markReadStream => _markReadController.stream;

  final _markUnreadController = StreamController<NoticeIntro>();
  StreamSink<NoticeIntro> get markUnreadSink => _markUnreadController.sink;
  Stream<NoticeIntro> get _markUnreadStream => _markUnreadController.stream;

  final _appBarLabelController = StreamController<String?>();
  StreamSink<String?> get _appBarLabelSink => _appBarLabelController.sink;
  Stream<String?> get appBarLabelStream => _appBarLabelController.stream;

  final _filterVisibilityController = StreamController<bool>();
  StreamSink<bool> get filterVisibilitySink => _filterVisibilityController.sink;
  Stream<bool> get filterVisibilityStream => _filterVisibilityController.stream;

  final _filterActiveController = StreamController<bool>();
  StreamSink<bool> get _filterActiveSink => _filterActiveController.sink;
  Stream<bool> get filterActiveStream => _filterActiveController.stream;

  final _unreadCountController = StreamController<String>();
  StreamSink<String> get _unreadCountSink => _unreadCountController.sink;
  Stream<String> get unreadCountStream => _unreadCountController.stream;

  final _isSearchingController = StreamController<bool>(); // search
  StreamSink<bool> get _isSearchingSink => _isSearchingController.sink;
  Stream<bool> get isSearchingStream => _isSearchingController.stream;

  final _queryController = StreamController<String>(); // search
  StreamSink<String> get querySink => _queryController.sink;
  Stream<String> get _queryStream => _queryController.stream;

  ListNoticesRepository _listNoticesRepository = ListNoticesRepository();

  ListNoticesBloc() {
    _queryStream.listen((query) {
      searchQuery = query;

      if (searchQuery == '') {
        disableClear();
      } else {
        enableClear();
      }
    });
    _eventStream.listen((event) async {
      if (event == ListNoticesEvent.pushProfileEvent) {
        _listNoticesRepository.pushProfileScreen(context!);
      }
    });

    _markReadStream.listen((object) async {
      object.read = true;
      updateUi(object);
      var obj = {
        "keyword": "read",
        "notices": [object.id]
      };
      try {
        await _listNoticesRepository.markReadUnreadNotice(obj);
      } catch (e) {
        object.read = false;
        updateUi(object);
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Error!"),
        ));
      }
    });

    _markUnreadStream.listen((object) async {
      object.read = false;
      updateUi(object);
      var obj = {
        "keyword": "unread",
        "notices": [object.id]
      };

      try {
        await _listNoticesRepository.markReadUnreadNotice(obj);
      } catch (e) {
        object.read = true;
        updateUi(object);
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
          content: Text("Error!"),
        ));
      }
    });

    _toggleBookMarkStream.listen((object) async {
      if (object.starred!) {
        object.starred = false;
        updateUi(object);
        var obj = {
          "keyword": "unstar",
          "notices": [object.id]
        };
        try {
          await _listNoticesRepository.unbookmarkNotice(obj, context);
        } catch (e) {
          object.starred = true;
          updateUi(object);
          ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
            content: Text("Error unmarking"),
          ));
        }
      } else {
        object.starred = true;
        updateUi(object);
        var obj = {
          "keyword": "star",
          "notices": [object.id]
        };
        try {
          await _listNoticesRepository.bookmarkNotice(obj, context);
        } catch (e) {
          object.starred = false;
          updateUi(object);
          ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
            content: Text("Error bookmarking"),
          ));
        }
      }
    });
  }

  Future dynamicFetchNotices() async {
    if (!listNoticeMetaData!.isSearch && !listNoticeMetaData!.noFilters)
      updateUnreadCount();
    if (!lazyLoad) _listNoticesSink.add(null);
    if (dynamicFetch == DynamicFetch.fetchSearchResults)
      await fetchAllSearch();
    else if (dynamicFetch == DynamicFetch.fetchSearchFilteredResults)
      await fetchFilteredSearch();
    else if (dynamicFetch == DynamicFetch.fetchInstituteNotices)
      await fetchInstituteNotices();
    else if (dynamicFetch == DynamicFetch.fetchPlacementNotices)
      await fetchPlacementNotices();
    else if (dynamicFetch == DynamicFetch.fetchFilterNotices) {
      await fetchFilteredNotices();
    } else if (dynamicFetch == DynamicFetch.fetchImportantNotices)
      await fetchImportantNotices();
    else if (dynamicFetch == DynamicFetch.fetchExpiredNotices)
      await fetchExpiredNotices();
    else if (dynamicFetch == DynamicFetch.fetchBookmarkedNotices)
      await fetchBookmarkedNotices();
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    if (!noticeIntro.read!) markReadSink.add(noticeIntro);
    navigatorKey.currentState!
        .pushNamed(noticeDetailRoute, arguments: noticeIntro)
        .then((value) => updateUi(value as NoticeIntro?));
  }

  void handleAfterFetch(bool doesItHasMore, List<NoticeIntro?>? list) {
    if (!doesItHasMore) hasMore = false;
    if (!lazyLoad) {
      dynamicNoticeList = list;
    } else {
      dynamicNoticeList!.addAll(list!);
    }
    _listNoticesSink
        .add(PaginatedInfo(list: dynamicNoticeList, hasMore: hasMore));
  }

  void searchHandler() async {
    page = 1;
    hasMore = true;
    lazyLoad = false;
    isLoading = false;
    dynamicFetchNotices();
  }

  void disposeStreams() {
    _eventController.close();
    _listNoticesController.close();
    _toggleBookmarkController.close();
    _appBarLabelController.close();
    _markReadController.close();
    _markUnreadController.close();
    _filterVisibilityController.close();
    _filterActiveController.close();
    _unreadCountController.close();
    _isSearchingController.close();
    _queryController.close();
  }

  Future refreshNotices() async {
    page = 1;
    hasMore = true;
    lazyLoad = false;
    isLoading = false;
    await dynamicFetchNotices();
  }

  Future loadMore() async {
    if (!isLoading && hasMore) {
      isLoading = true;
      page++;
      lazyLoad = true;
      await dynamicFetchNotices();
      isLoading = false;
    }
  }

  Future fetchAllSearch() async {
    if (searchQuery != '') {
      try {
        PaginatedInfo paginatedInfo = await _listNoticesRepository
            .fetchAllSearchResults(page, searchQuery);
        List<NoticeIntro?>? allSearchResults = paginatedInfo.list;
        handleAfterFetch(paginatedInfo.hasMore!, allSearchResults);
      } catch (e) {
        if (!_listNoticesController.isClosed)
          _listNoticesSink.addError(e.toString());
      }
    }
  }

  Future fetchFilteredSearch() async {
    if (searchQuery != '') {
      try {
        PaginatedInfo paginatedInfo =
            await _listNoticesRepository.fetchSearchFilteredNotices(
                filterResult.endpoint!, page, searchQuery);
        List<NoticeIntro?>? allSearchFilteredNotices = paginatedInfo.list;
        handleAfterFetch(paginatedInfo.hasMore!, allSearchFilteredNotices);
      } catch (e) {
        if (!_listNoticesController.isClosed)
          _listNoticesSink.addError(e.toString());
      }
    }
  }

  Future fetchInstituteNotices() async {
    _appBarLabelSink.add(listNoticeMetaData!.appBarLabel);
    try {
      PaginatedInfo paginatedInfo =
          await _listNoticesRepository.fetchInstituteNotices(page);
      List<NoticeIntro?>? allInstituteNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allInstituteNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  Future fetchPlacementNotices() async {
    _appBarLabelSink.add(listNoticeMetaData!.appBarLabel);
    try {
      PaginatedInfo paginatedInfo =
          await _listNoticesRepository.fetchPlacementNotices(page);
      List<NoticeIntro?>? allPlacementNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allPlacementNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  Future fetchFilteredNotices() async {
    try {
      if (filterResult.label != null)
        _appBarLabelSink.add(filterResult.label);
      else {
        _appBarLabelSink.add(listNoticeMetaData!.appBarLabel);
        if (listNoticeMetaData!.dynamicFetch ==
            DynamicFetch.fetchPlacementNotices)
          filterResult.endpoint = filterResult.endpoint! + '&banner=82';
        if (listNoticeMetaData!.dynamicFetch ==
            DynamicFetch.fetchInstituteNotices)
          filterResult.endpoint =
              'api/noticeboard/institute_notices/?start=${filterResult.startDate}&end=${filterResult.endDate}';
        // TODO: Add the if condition for Institute Notices case
      }
      PaginatedInfo paginatedInfo = await _listNoticesRepository
          .fetchFilteredNotices(filterResult.endpoint!, page);
      List<NoticeIntro?>? allFilteredNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allFilteredNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  Future fetchImportantNotices() async {
    try {
      PaginatedInfo paginatedInfo =
          await _listNoticesRepository.fetchImportantNotices(page);
      List<NoticeIntro?>? allImportantNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allImportantNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  Future fetchExpiredNotices() async {
    try {
      PaginatedInfo paginatedInfo =
          await _listNoticesRepository.fetchExpiredNotices(page);
      List<NoticeIntro?>? allExpiredNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allExpiredNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  Future fetchBookmarkedNotices() async {
    try {
      PaginatedInfo paginatedInfo =
          await _listNoticesRepository.fetchBookmarkedNotices(page);
      List<NoticeIntro?>? allBookmarkedNotices = paginatedInfo.list;
      handleAfterFetch(paginatedInfo.hasMore!, allBookmarkedNotices);
    } catch (e) {
      if (!_listNoticesController.isClosed)
        _listNoticesSink.addError(e.toString());
    }
  }

  void applySearchFilters(FilterResult? value) async {
    page = 1;
    hasMore = true;
    lazyLoad = false;
    isLoading = false;
    toggleVisibility();
    if (value != null) {
      filterResult = value;
      dynamicFetch = DynamicFetch.fetchSearchFilteredResults;
      dynamicFetchNotices();
    } else {
      dynamicFetch = listNoticeMetaData!.dynamicFetch;
      dynamicFetchNotices();
    }
    if (dynamicFetch == DynamicFetch.fetchSearchFilteredResults)
      _filterActiveSink.add(true);
    else
      _filterActiveSink.add(false);
  }

  void applyFilters(FilterResult? value) async {
    page = 1;
    hasMore = true;
    lazyLoad = false;
    isLoading = false;
    toggleVisibility();

    if (value != null) {
      filterResult = value;
      dynamicFetch = DynamicFetch.fetchFilterNotices;
      dynamicFetchNotices();
    } else {
      dynamicFetch = listNoticeMetaData!.dynamicFetch;
      dynamicFetchNotices();
    }
    if (dynamicFetch == DynamicFetch.fetchFilterNotices)
      _filterActiveSink.add(true);
    else
      _filterActiveSink.add(false);
  }

  void toggleVisibility() {
    filterVisibility = !filterVisibility;
    filterVisibilitySink.add(filterVisibility);
  }

  void updateUnreadCount() async {
    try {
      String unreadCount = await _listNoticesRepository.importantUnreadCount();
      _unreadCountSink.add(unreadCount);
    } catch (e) {}
  }

  void pushImportantNotices() {
    ListNoticeMetaData impListNoticeMetaData = ListNoticeMetaData(
        appBarLabel: 'Important Notices',
        dynamicFetch: DynamicFetch.fetchImportantNotices,
        noFilters: true,
        isSearch: false);
    navigatorKey.currentState!
        .pushNamed(listNoticesRoute, arguments: impListNoticeMetaData);
  }

  void pushSearch() {
    ListNoticeMetaData listNoticeMetaData = ListNoticeMetaData(
        appBarLabel: '',
        dynamicFetch: DynamicFetch.fetchSearchResults,
        noFilters: false,
        isSearch: true);
    navigatorKey.currentState!
        .pushNamed(listNoticesRoute, arguments: listNoticeMetaData);
  }

  void enableClear() {
    isSearching = true;
    _isSearchingSink.add(isSearching);
  }

  void disableClear() {
    isSearching = false;
    _isSearchingSink.add(isSearching);
  }

  void updateUi(NoticeIntro? object) {
    dynamicNoticeList![dynamicNoticeList!
        .indexWhere((noticeIntro) => noticeIntro!.id == object!.id)] = object;
    _listNoticesSink
        .add(PaginatedInfo(list: dynamicNoticeList, hasMore: hasMore));
  }
}
