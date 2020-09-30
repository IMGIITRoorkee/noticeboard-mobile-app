import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../services/auth/auth_repository.dart';
import '../models/user_profile.dart';
import '../services/api_service/api_service.dart';
import '../models/notice_intro.dart';

class InstituteNoticesRepository {
  AuthRepository _authRepository = AuthRepository();
  ApiService _apiService = ApiService();

  Future pushProfileScreen(BuildContext context) async {
    UserProfile userProfile = await _authRepository.fetchUserProfile();
    Navigator.pushNamed(context, profileRoute, arguments: userProfile);
  }

  Future<List<NoticeIntro>> fetchInstituteNotices() async {
    try {
      List<NoticeIntro> allInstituteNotices =
          await _apiService.fetchallNotices();
      return allInstituteNotices;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
