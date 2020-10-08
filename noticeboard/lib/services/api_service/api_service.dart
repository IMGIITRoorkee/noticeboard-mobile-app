import '../../services/auth/auth_service.dart';
import '../../models/notice_intro.dart';
import '../../models/user_tokens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/endpoints/urls.dart';
import '../../models/notice_content.dart';
import '../../models/filters_list.dart';

class ApiService {
  AuthService _authService = AuthService();

  Future<List<NoticeIntro>> fetchallNotices() async {
    try {
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

  Future<List<NoticeIntro>> fetchFilteredNotices(String endpoint) async {
    try {
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh();
      final http.Response response = await http.get(BASE_URL + endpoint,
          headers: {
            AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
          });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        Iterable list = body['results'];
        return list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      throw Exception('Failed to load notices');
    }
  }

  Future markUnmarkNotice(var obj) async {
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

  Future<NoticeContent> fetchNoticeContent(int id) async {
    try {
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh();
      final http.Response contentResponse = await http
          .get(BASE_URL + ALL_NOTICES + id.toString() + '/', headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (contentResponse.statusCode == 200) {
        return NoticeContent.fromJSON(jsonDecode(contentResponse.body));
      } else {
        throw Exception('Failure fetching details');
      }
    } catch (e) {
      throw Exception('Failure fetching details');
    }
  }

  Future<List<Category>> fetchFilters() async {
    try {
      AccessToken accessTokenObj =
          await _authService.fetchAccessTokenFromRefresh();
      final http.Response filterListResponse = await http
          .get(BASE_URL + FILTERS_LIST, headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });

      if (filterListResponse.statusCode == 200) {
        final body = jsonDecode(filterListResponse.body);
        Iterable list = body;
        return list.map((category) => Category.fromJSON(category)).toList();
      } else {
        throw Exception('Error fetching filters');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
