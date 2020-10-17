import 'package:noticeboard/routes/routing_constants.dart';
import '../../models/user_tokens.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import '../../global/toast.dart';
import '../../models/user_profile.dart';

class AuthRepository {
  AuthService _authService = AuthService();

  Future signInWithUsernamePassword(
      {String username, String password, BuildContext context}) async {
    try {
      showToast('Attempting Login');
      var userObj = {"username": username, "password": password};
      RefreshToken _refreshTokenObj =
          await _authService.fetchUserTokens(userObj);
      await _authService.storeRefreshToken(_refreshTokenObj);

      Navigator.pushReplacementNamed(context, bottomNavigationRoute);
      cancelToast();
    } catch (e) {
      showToast('Login failed');
    }
  }

  Future checkIfAlreadySignedIn(BuildContext context) async {
    RefreshToken refreshToken = await _authService.fetchRefreshToken();
    await Future.delayed(Duration(seconds: 1));
    if (refreshToken.refreshToken != null) {
      Navigator.pushReplacementNamed(context, bottomNavigationRoute);
    } else {
      Navigator.pushReplacementNamed(context, loginRoute);
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    try {
      UserProfile userProfileObj = await _authService.fetchUserProfile();

      return userProfileObj;
    } catch (e) {
      showToast('Unable to fetch Profile');
      return null;
    }
  }

  Future logout() async {
    await _authService.deleteRefreshToken();
  }
}
