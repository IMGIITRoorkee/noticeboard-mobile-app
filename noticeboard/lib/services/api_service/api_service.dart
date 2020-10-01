import '../../services/auth/auth_service.dart';
import '../../models/notice_intro.dart';
import '../../models/user_tokens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/endpoints/urls.dart';

class ApiService {
  AuthService _authService = AuthService();

  Future<List<NoticeIntro>> fetchallNotices() async {
    try {
      print('apiiiiiiii');
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh();
      final http.Response allNoticesResponse = await http
          .get(BASE_URL + ALL_NOTICES, headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allNoticesResponse.body);
        Iterable list = body['results'];
        return list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      throw Exception('Failed to load notices');
    }
  }

  Future starReadNotice(var obj) async {
    try {
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh();
      final http.Response postResponse = await http.post(BASE_URL + STAR_READ,
          headers: {
            AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken,
            CONTENT_TYPE_KEY: CONTENT_TYPE
          },
          body: jsonEncode(obj));
      if (postResponse.statusCode != 201) {
        throw Exception('Failure');
      }
    } catch (e) {
      throw Exception('Failure');
    }
  }
}
