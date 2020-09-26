import '../../models/user_tokens.dart';
import '../../models/user_profile.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import '../../screens/profile.dart';

class AuthRepository {
  AuthService _authService = AuthService();

  Future signInWithUsernamePassword(
      {String username, String password, BuildContext context}) async {
    try {
      var userObj = {"username": username, "password": password};
      RefreshToken _refreshTokenObj =
          await _authService.fetchUserTokens(userObj);
      await _authService.storeRefreshToken(_refreshTokenObj);

      UserProfile userProfile = await fetchUserProfile();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(
              userProfile: userProfile,
            ),
          ));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    try {
      RefreshToken refreshTokenObj = await _authService.fetchRefreshToken();

      var refreshObj = {"refresh": refreshTokenObj.refreshToken};
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh(refreshObj);

      UserProfile userProfileObj =
          await _authService.fetchUserProfile(accessTokenObj);

      return userProfileObj;
    } catch (e) {
      print(e.toString());
    }
  }
}
