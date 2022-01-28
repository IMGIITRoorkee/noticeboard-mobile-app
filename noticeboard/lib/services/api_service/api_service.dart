import '../../services/auth/auth_service.dart';
import '../../models/notice_intro.dart';
import '../../models/user_tokens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/endpoints/urls.dart';
import '../../models/notice_content.dart';
import '../../models/filters_list.dart';
import '../../models/paginated_info.dart';

class ApiService {
  AuthService _authService = AuthService();

  Future<PaginatedInfo> fetchInstituteNotices(int page) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allNoticesResponse = await http
          .get(BASE_URL + ALL_NOTICES + page.toString(), headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allNoticesResponse.body);

        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];
        //   list = list.where((notice) => notice['banner']['id'] != 82).toList();
        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();

        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load notices');
    }
  }

  Future<PaginatedInfo> fetchSearchResultsAll(int page, String keyword) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allSearchResponse = await http.get(
          BASE_URL + ALL_NOTICES + page.toString() + '&keyword=$keyword',
          headers: {
            AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
          });
      if (allSearchResponse.statusCode == 200) {
        final body = jsonDecode(allSearchResponse.body);

        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];
        //   list = list.where((notice) => notice['banner']['id'] != 82).toList();
        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();

        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Failed to load search results');
    }
  }

  Future<PaginatedInfo> fetchSearchFilteredResults(
      String endpoint, int page, String keyword) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allSearchFilteredResponse = await http.get(
          BASE_URL +
              endpoint +
              '&page=${page.toString()}' +
              '&keyword=$keyword',
          headers: {
            AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
          });
      if (allSearchFilteredResponse.statusCode == 200) {
        final body = jsonDecode(allSearchFilteredResponse.body);

        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];
        //   list = list.where((notice) => notice['banner']['id'] != 82).toList();
        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();

        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load search filtered results');
      }
    } catch (e) {
      throw Exception('Failed to load search filtered results');
    }
  }

  Future<PaginatedInfo> fetchImportantNotices(int page) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allImportantNoticesResponse = await http
          .get(BASE_URL + IMPORTANT_NOTICES + page.toString(), headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allImportantNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allImportantNoticesResponse.body);
        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];

        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load important notices');
      }
    } catch (e) {
      throw Exception('Failed to load important notices');
    }
  }

  Future<PaginatedInfo> fetchExpiredNotices(int page) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allExpiredNoticesResponse = await http
          .get(BASE_URL + EXPIRED_NOTICES + page.toString(), headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allExpiredNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allExpiredNoticesResponse.body);
        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];

        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load expired notices');
      }
    } catch (e) {
      throw Exception('Failed to load expired notices');
    }
  }

  Future<PaginatedInfo> fetchBookmarkedNotices(int page) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allBookmarkedNoticesResponse = await http
          .get(BASE_URL + BOOKMARKED_NOTICES + page.toString(), headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allBookmarkedNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allBookmarkedNoticesResponse.body);
        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];

        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load bookmarked notices');
      }
    } catch (e) {
      throw Exception('Failed to load bookmarked notices');
    }
  }

  Future<PaginatedInfo> fetchPlacementNotices(int page) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response placementNoticesResponse = await http.get(
          BASE_URL + PLACEMENT_NOTICES + '&page=${page.toString()}',
          headers: {
            AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
          });

      if (placementNoticesResponse.statusCode == 200) {
        final body = jsonDecode(placementNoticesResponse.body);
        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];

        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
        return PaginatedInfo(list: list, hasMore: hasMore);
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      throw Exception('Failed to load notices');
    }
  }

  Future<PaginatedInfo> fetchFilteredNotices(String endpoint, int page) async {
    try {
      AccessToken accessTokenObj =
          //     await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response response = await http
          .get(BASE_URL + endpoint + '&page=${page.toString()}', headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        bool hasMore = body['next'] == null ? false : true;

        Iterable list = body['results'];

        list = list.map((notice) => NoticeIntro.fromJSON(notice)).toList();
        return PaginatedInfo(list: list, hasMore: hasMore);
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
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
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

  Future markReadUnreadNotice(var obj) async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
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
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response contentResponse = await http
          .get(BASE_URL + NOTICE_DETAIL + id.toString() + '/', headers: {
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
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
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

  Future<String> fetchImpUnreadCount() async {
    try {
      AccessToken accessTokenObj =
          // await _authService.fetchAccessTokenFromRefresh();
          await _authService.fetchAccessToken();
      final http.Response allNoticesResponse = await http
          .get(BASE_URL + ALL_NOTICES + '1', headers: {
        AUTHORIZAION_KEY: AUTHORIZATION_PREFIX + accessTokenObj.accessToken
      });
      if (allNoticesResponse.statusCode == 200) {
        final body = jsonDecode(allNoticesResponse.body);
        return body['importantUnreadCount'].toString();
      } else {
        throw Exception('Failed to load unread count');
      }
    } catch (e) {
      throw Exception('Failed to load unread count');
    }
  }
}
