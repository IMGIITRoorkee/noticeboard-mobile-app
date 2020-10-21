import 'package:noticeboard/routes/routing_constants.dart';
import '../../models/user_tokens.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import '../../global/global_functions.dart';
import '../../models/user_profile.dart';

class AuthRepository {
  AuthService _authService = AuthService();

  Future signInWithUsernamePassword(
      {String username, String password, BuildContext context}) async {
    try {
      var userObj = {"username": username, "password": password};
      RefreshToken _refreshTokenObj =
          await _authService.fetchUserTokens(userObj);
      await _authService.storeRefreshToken(_refreshTokenObj);
      await _authService.initHandle();
      UserProfile userProfile = await fetchUserProfile(context);
      await _authService.storeProfile(userProfile);
      Navigator.pushReplacementNamed(context, bottomNavigationRoute);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future checkIfAlreadySignedIn(BuildContext context) async {
    RefreshToken refreshToken = await _authService.fetchRefreshToken();
    await Future.delayed(Duration(seconds: 1));
    if (refreshToken.refreshToken != null) {
      await _authService.initHandle();
      Navigator.pushReplacementNamed(context, bottomNavigationRoute);
    } else {
      Navigator.pushReplacementNamed(context, loginRoute);
    }
  }

  Future<UserProfile> fetchUserProfile(BuildContext context) async {
    try {
      UserProfile userProfileObj = await _authService.fetchUserProfile();

      return userProfileObj;
    } catch (e) {
      showMyFlushBar(context, 'Failure fetching profile', false);
      return null;
    }
  }

  Future logout() async {
    await _authService.deleteRefreshToken();
  }

  Future<UserProfile> fetchProfileFromStorage() async {
    UserProfile userProfile = await _authService.fetchProfileFromStorage();
    return userProfile;
  }
}
