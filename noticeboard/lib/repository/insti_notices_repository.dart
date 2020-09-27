import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../services/auth/auth_repository.dart';
import '../models/user_profile.dart';

class InstituteNoticesRepository {
  AuthRepository authRepository = AuthRepository();
  Future pushProfileScreen(BuildContext context) async {
    UserProfile userProfile = await authRepository.fetchUserProfile();
    Navigator.pushReplacementNamed(context, profileRoute,
        arguments: userProfile);
  }
}
