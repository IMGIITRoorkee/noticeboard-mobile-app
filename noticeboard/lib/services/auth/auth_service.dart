import 'dart:convert';
import 'package:noticeboard/models/user_profile.dart';
import '../endpoints/urls.dart';
import 'package:http/http.dart' as http;
import '../../models/user_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = new FlutterSecureStorage();

  initHandle() async {
    AccessToken accessTokenObj = await fetchAccessTokenFromRefresh();
    storeAccessToken(accessTokenObj);
  }

  Future<RefreshToken> fetchUserTokens(dynamic obj) async {
    final http.Response postResponse = await http.post(
        BASE_URL + EP_REFRESH_TOKEN,
        headers: {CONTENT_TYPE_KEY: CONTENT_TYPE},
        body: jsonEncode(obj));
    if (postResponse.statusCode == 200) {
      return RefreshToken.fromJSON(jsonDecode(postResponse.body));
    } else {
      throw Exception('Login Failed');
    }
  }

  Future storeRefreshToken(RefreshToken userRefreshToken) async {
    await storage.write(
        key: "refreshToken", value: userRefreshToken.refreshToken);
  }

  Future storeAccessToken(AccessToken userAccessToken) async {
    await storage.write(key: "accessToken", value: userAccessToken.accessToken);
  }

  Future<RefreshToken> fetchRefreshToken() async {
    String refreshToken = await storage.read(key: "refreshToken");

    return RefreshToken(refreshToken: refreshToken);
  }

  Future<AccessToken> fetchAccessToken() async {
    String accessToken = await storage.read(key: "accessToken");

    return AccessToken(accessToken: accessToken);
  }

  Future deleteRefreshToken() async {
    await storage.deleteAll();
  }

  Future<AccessToken> fetchAccessTokenFromRefresh() async {
    RefreshToken refreshTokenObj = await fetchRefreshToken();

    var refreshObj = {"refresh": refreshTokenObj.refreshToken};
    final http.Response postResponse = await http.post(
        BASE_URL + EP_ACCESS_TOKEN,
        headers: {CONTENT_TYPE_KEY: CONTENT_TYPE},
        body: jsonEncode(refreshObj));

    if (postResponse.statusCode == 200) {
      return AccessToken.fromJSON(jsonDecode(postResponse.body));
    } else {
      throw Exception('Unable to fetch Access Token');
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    //AccessToken accessTokenObj = await fetchAccessTokenFromRefresh();
    AccessToken accessTokenObj = await fetchAccessToken();
    final http.Response userProfileResponse = await http
        .get(BASE_URL + EP_WHO_AM_I, headers: {
      AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
    });

    if (userProfileResponse.statusCode == 200) {
      return UserProfile.fromJSON(jsonDecode(userProfileResponse.body));
    } else {
      throw Exception('Unable to fetch profile of user');
    }
  }
}
