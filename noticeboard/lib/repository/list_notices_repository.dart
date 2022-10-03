import 'package:flutter/material.dart';
import 'package:noticeboard/models/paginated_info.dart';
import '../global/global_constants.dart';
import '../routes/routing_constants.dart';
import '../services/api_service/api_service.dart';
import '../models/notice_intro.dart';

class ListNoticesRepository {
  ApiService _apiService = ApiService();

  Future pushProfileScreen(BuildContext context) async {
    previousRoute = bottomNavigationRoute;
    navigatorKey.currentState!.pushNamed(profileRoute);
  }

  void noticeDetail(BuildContext context, NoticeIntro noticeIntro) {
    previousRoute = bottomNavigationRoute;
    navigatorKey.currentState!
        .pushNamed(noticeDetailRoute, arguments: noticeIntro);
  }

  Future<PaginatedInfo> fetchInstituteNotices(int page) async {
    PaginatedInfo allInstituteNotices =
        await _apiService.fetchInstituteNotices(page);
    return allInstituteNotices;
  }

  Future<PaginatedInfo> fetchImportantNotices(int page) async {
    PaginatedInfo allImportantNotices =
        await _apiService.fetchImportantNotices(page);
    return allImportantNotices;
  }

  Future<PaginatedInfo> fetchExpiredNotices(int page) async {
    PaginatedInfo allExpiredNotices =
        await _apiService.fetchExpiredNotices(page);
    return allExpiredNotices;
  }

  Future<PaginatedInfo> fetchBookmarkedNotices(int page) async {
    PaginatedInfo allBookmarkedNotices =
        await _apiService.fetchBookmarkedNotices(page);
    return allBookmarkedNotices;
  }

  Future<PaginatedInfo> fetchPlacementNotices(int page) async {
    PaginatedInfo allPlacementNotices =
        await _apiService.fetchPlacementNotices(page);
    return allPlacementNotices;
  }

  Future<PaginatedInfo> fetchFilteredNotices(String endpoint, int page) async {
    PaginatedInfo filteredNotices =
        await _apiService.fetchFilteredNotices(endpoint, page);
    return filteredNotices;
  }

  Future<PaginatedInfo> fetchSearchFilteredNotices(
      String endpoint, int page, String keyword) async {
    PaginatedInfo searchFilteredNotices =
        await _apiService.fetchSearchFilteredResults(endpoint, page, keyword);
    return searchFilteredNotices;
  }

  Future bookmarkNotice(var obj, BuildContext? context) async {
    await _apiService.markUnmarkNotice(obj);
  }

  Future unbookmarkNotice(var obj, BuildContext? context) async {
    await _apiService.markUnmarkNotice(obj);
  }

  Future markReadUnreadNotice(var obj) async {
    await _apiService.markReadUnreadNotice(obj);
  }

  Future<String> importantUnreadCount() async {
    String unreadCount = await _apiService.fetchImpUnreadCount();
    return unreadCount;
  }

  Future<PaginatedInfo> fetchAllSearchResults(int page, String keyword) async {
    PaginatedInfo allSearchNotices =
        await _apiService.fetchSearchResultsAll(page, keyword);
    return allSearchNotices;
  }
}
