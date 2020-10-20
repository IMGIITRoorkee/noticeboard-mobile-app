import '../models/notice_intro.dart';

class PaginatedInfo {
  final List<NoticeIntro> list;
  final bool hasMore;
  PaginatedInfo({this.list, this.hasMore});
}
