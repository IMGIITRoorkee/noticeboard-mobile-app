import 'dart:async';
import 'package:noticeboard/enum/notice_content_enum.dart';
import '../models/notice_content.dart';
import '../models/notice_intro.dart';
import '../repository/notice_content_repository.dart';

class NoticeContentBloc {
  NoticeIntro noticeIntro;

  final NoticeContentRepository noticeContentRepository =
      NoticeContentRepository();

  final _eventController = StreamController<NoticeContentEvents>();
  StreamSink<NoticeContentEvents> get eventSink => _eventController.sink;
  Stream<NoticeContentEvents> get _eventStream => _eventController.stream;

  final _noticeContentController = StreamController<NoticeContent>();
  StreamSink<NoticeContent> get _contentSink => _noticeContentController.sink;
  Stream<NoticeContent> get contentStream => _noticeContentController.stream;

  NoticeContentBloc() {
    _eventStream.listen((event) async {
      if (event == NoticeContentEvents.fetchContent) {
        try {
          NoticeContent noticeContent =
              await noticeContentRepository.fetchNoticeContent(noticeIntro.id);
          _contentSink.add(noticeContent);
        } catch (e) {
          _contentSink.addError(e.message.toString());
        }
      }
    });
  }

  void disposeStreams() {
    _eventController.close();
    _noticeContentController.close();
  }
}
