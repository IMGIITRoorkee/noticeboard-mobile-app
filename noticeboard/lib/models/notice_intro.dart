import 'package:date_format/date_format.dart';

class NoticeIntro {
  final int id;
  final String title;
  final String dateCreated;
  final String department;
  final bool read;
  final bool starred;

  NoticeIntro(
      {this.id,
      this.title,
      this.dateCreated,
      this.department,
      this.read,
      this.starred});

  static String convertDateToRequiredFormat(String dateOriginal) {
    DateTime dateObj = DateTime.parse(dateOriginal);
    List format = [hh, ':', nn, ' ', am, ', ', M, ' ', dd, ', ', yy];
    String formattedDateString = formatDate(dateObj, format);
    return formattedDateString;
  }

  factory NoticeIntro.fromJSON(dynamic json) {
    return NoticeIntro(
        id: json['id'],
        title: json['title'],
        dateCreated: convertDateToRequiredFormat(json['datetimeCreated']),
        department: json['banner']['name'],
        read: json['read'],
        starred: json['starred']);
  }
}
