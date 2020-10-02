class NoticeContent {
  final String content;
  NoticeContent({this.content});

  factory NoticeContent.fromJSON(dynamic json) {
    return NoticeContent(content: json['content']);
  }
}
