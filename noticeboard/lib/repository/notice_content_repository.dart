import '../services/api_service/api_service.dart';
import '../models/notice_content.dart';

class NoticeContentRepository {
  ApiService _apiService = ApiService();

  Future<NoticeContent> fetchNoticeContent(int id) async {
    NoticeContent noticeContent = await _apiService.fetchNoticeContent(id);
    return noticeContent;
  }

  Future bookmarkNotice(var obj) async {
    await _apiService.markUnmarkNotice(obj);
  }

  Future unbookmarkNotice(var obj) async {
    await _apiService.markUnmarkNotice(obj);
  }
}
