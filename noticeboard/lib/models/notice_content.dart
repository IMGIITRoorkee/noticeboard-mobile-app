class NoticeContent {
  final String content;
  NoticeContent({this.content});

  static String htmlCorrector(String incorrectHTML) {
    String correctHTML = incorrectHTML.replaceAll(
        "/media/noticeboard", "https://internet.channeli.in/media/noticeboard");
    return correctHTML;
  }

  factory NoticeContent.fromJSON(dynamic json) {
    return NoticeContent(content: htmlCorrector(json['content']));
  }
}
