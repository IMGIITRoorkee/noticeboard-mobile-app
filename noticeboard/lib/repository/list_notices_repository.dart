import 'package:flutter/material.dart';
import 'package:noticeboard/models/paginated_info.dart';
import '../routes/routing_constants.dart';
import '../services/api_service/api_service.dart';
import '../models/notice_intro.dart';
import '../global/toast.dart';

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

  Future<List<NoticeIntro>> fetchFilteredNotices(
      String endpoint, int page) async {
    List<NoticeIntro> filteredNotices =
        await _apiService.fetchFilteredNotices(endpoint, page);
    return filteredNotices;
  }

  Future bookmarkNotice(var obj) async {
    try {
      await _apiService.markUnmarkNotice(obj);
      showToast('Notice marked');
    } catch (e) {
      showToast('Failure marking');
    }
  }

  Future unbookmarkNotice(var obj) async {
    try {
      await _apiService.markUnmarkNotice(obj);
      showToast('Notice unmarked');
    } catch (e) {
      showToast('Failure unmarking');
    }
  }

  Future markReadUnreadNotice(var obj) async {
    try {
      await _apiService.markReadUnreadNotice(obj);
    } catch (e) {}
  }
}
