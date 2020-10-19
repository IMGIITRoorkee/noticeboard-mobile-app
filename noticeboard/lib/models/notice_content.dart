class NoticeContent {
  final String content;
  NoticeContent({this.content});

  static String htmlCorrector(String incorrectHTML) {
    String correctHTML = incorrectHTML.replaceAll(
        "src=\"/media/", "src=\"https://internet.channeli.in/media/");
    return correctHTML;
  }

  factory NoticeContent.fromJSON(dynamic json) {
    return NoticeContent(content: htmlCorrector(json['content']));
  }
}
