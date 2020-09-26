import 'dart:convert';
import 'package:noticeboard/models/user_profile.dart';
import '../endpoints/urls.dart';
import 'package:http/http.dart' as http;
import '../../models/user_tokens.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = new FlutterSecureStorage();

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

  Future<RefreshToken> fetchRefreshToken() async {
    String refreshToken = await storage.read(key: "refreshToken");

    return RefreshToken(refreshToken: refreshToken);
  }

  Future deleteRefreshToken() async {
    await storage.delete(key: "refreshToken");
  }

  Future<AccessToken> fetchAccessTokenFromRefresh(dynamic obj) async {
    final http.Response postResponse = await http.post(
        BASE_URL + EP_ACCESS_TOKEN,
        headers: {CONTENT_TYPE_KEY: CONTENT_TYPE},
        body: jsonEncode(obj));

    if (postResponse.statusCode == 200) {
      return AccessToken.fromJSON(jsonDecode(postResponse.body));
    } else {
      throw Exception('Unable to fetch Access Token');
    }
  }

  Future<UserProfile> fetchUserProfile(AccessToken accessToken) async {
    final http.Response userProfileResponse = await http
        .get(BASE_URL + EP_WHO_AM_I, headers: {
      AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessToken.accessToken
    });

    if (userProfileResponse.statusCode == 200) {
      return UserProfile.fromJSON(jsonDecode(userProfileResponse.body));
    } else {
      throw Exception('Unable to fetch profile of user');
    }
  }
}
