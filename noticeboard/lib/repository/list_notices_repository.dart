import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../services/auth/auth_repository.dart';
import '../models/user_profile.dart';
import '../services/api_service/api_service.dart';
import '../models/notice_intro.dart';
import '../global/toast.dart';

class ListNoticesRepository {
  AuthRepository _authRepository = AuthRepository();
  ApiService _apiService = ApiService();

  Future pushProfileScreen(BuildContext context) async {
    UserProfile userProfile = await _authRepository.fetchUserProfile();
    Navigator.pushNamed(context, profileRoute, arguments: userProfile);
  }

  void noticeDetail(BuildContext context, NoticeIntro noticeIntro) {
    Navigator.pushNamed(context, noticeDetailRoute, arguments: noticeIntro);
  }

  Future<List<NoticeIntro>> fetchInstituteNotices() async {
    List<NoticeIntro> allInstituteNotices = await _apiService.fetchallNotices();
    return allInstituteNotices;
  }

  Future<List<NoticeIntro>> fetchFilteredNotices(String endpoint) async {
    List<NoticeIntro> filteredNotices =
        await _apiService.fetchFilteredNotices(endpoint);
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
