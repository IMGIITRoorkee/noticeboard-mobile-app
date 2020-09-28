import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../services/auth/auth_repository.dart';
import '../models/user_profile.dart';

class InstituteNoticesRepository {
  AuthRepository _authRepository = AuthRepository();
  Future pushProfileScreen(BuildContext context) async {
    UserProfile userProfile = await _authRepository.fetchUserProfile();
    Navigator.pushNamed(context, profileRoute, arguments: userProfile);
  }
}
