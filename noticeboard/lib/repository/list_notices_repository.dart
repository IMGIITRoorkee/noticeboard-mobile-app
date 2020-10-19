import 'package:flutter/material.dart';
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

  Future<List<NoticeIntro>> fetchInstituteNotices(int page) async {
    List<NoticeIntro> allInstituteNotices =
        await _apiService.fetchInstituteNotices(page);
    return allInstituteNotices;
  }

  Future<List<NoticeIntro>> fetchImportantNotices(int page) async {
    List<NoticeIntro> allImportantNotices =
        await _apiService.fetchImportantNotices(page);
    return allImportantNotices;
  }

  Future<List<NoticeIntro>> fetchExpiredNotices(int page) async {
    List<NoticeIntro> allExpiredNotices =
        await _apiService.fetchExpiredNotices(page);
    return allExpiredNotices;
  }

  Future<List<NoticeIntro>> fetchBookmarkedNotices(int page) async {
    List<NoticeIntro> allBookmarkedNotices =
        await _apiService.fetchBookmarkedNotices(page);
    return allBookmarkedNotices;
  }

  Future<List<NoticeIntro>> fetchPlacementNotices(int page) async {
    List<NoticeIntro> allPlacementNotices =
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
