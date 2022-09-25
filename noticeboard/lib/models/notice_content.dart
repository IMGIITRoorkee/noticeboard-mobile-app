import 'package:date_format/date_format.dart';
import 'package:noticeboard/services/endpoints/urls.dart';

class NoticeContent {
  final int? id;
  final String? title;
  final String? dateCreated;
  final String? department;
  bool? read;
  bool? starred;

  final String? content;
  NoticeContent({
    this.id,
    this.title,
    this.content,
    this.dateCreated,
    this.department,
    this.read,
    this.starred,
  });

  static String htmlCorrector(String incorrectHTML) {
    String correctHTML = incorrectHTML.replaceAll(
        "/media/noticeboard", "${BASE_URL}media/noticeboard");
    return correctHTML;
  }

  static String convertDateToRequiredFormat(String dateOriginal) {
    DateTime dateObj = DateTime.parse(dateOriginal).toLocal();
    List<String> format = [hh, ':', nn, ' ', am, ', ', M, ' ', dd, ', ', yy];
    String formattedDateString = formatDate(dateObj, format);
    return formattedDateString;
  }

  factory NoticeContent.fromJSON(dynamic json) {
    return NoticeContent(
      content: htmlCorrector(json['content']),
      id: json['id'],
      title: json['title'],
      dateCreated: convertDateToRequiredFormat(json['datetimeModified']),
      department: json['banner']['name'],
      read: json['read'],
      starred: json['starred'],
    );
  }
}
