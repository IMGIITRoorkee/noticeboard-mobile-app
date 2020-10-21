import 'package:flutter/material.dart';
import 'package:noticeboard/models/paginated_info.dart';
import '../routes/routing_constants.dart';
import '../services/api_service/api_service.dart';
import '../models/notice_intro.dart';
import '../global/global_functions.dart';

class ListNoticesRepository {
  ApiService _apiService = ApiService();

  Future pushProfileScreen(BuildContext context) async {
    Navigator.pushNamed(context, profileRoute);
  }

  void noticeDetail(BuildContext context, NoticeIntro noticeIntro) {
    Navigator.pushNamed(context, noticeDetailRoute, arguments: noticeIntro);
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

  Future bookmarkNotice(var obj, BuildContext context) async {
    try {
      await _apiService.markUnmarkNotice(obj);

      showMyFlushBar(context, 'Notice marked', true);
    } catch (e) {
      showMyFlushBar(context, 'Failure marking', false);
    }
  }

  Future unbookmarkNotice(var obj, BuildContext context) async {
    try {
      await _apiService.markUnmarkNotice(obj);
      showMyFlushBar(context, 'Notice unmarked', true);
    } catch (e) {
      showMyFlushBar(context, 'Failure unmarking', false);
    }
  }

  Future markReadUnreadNotice(var obj) async {
    try {
      await _apiService.markReadUnreadNotice(obj);
    } catch (e) {}
  }
}
