import 'dart:async';
import 'package:noticeboard/enum/notice_content_enum.dart';
import '../models/notice_content.dart';
import '../models/notice_intro.dart';
import '../repository/notice_content_repository.dart';
import '../global/toast.dart';
import 'package:share/share.dart';

class NoticeContentBloc {
  NoticeIntro noticeIntro;
  bool starred;

  final NoticeContentRepository noticeContentRepository =
      NoticeContentRepository();

  final _eventController = StreamController<NoticeContentEvents>();
  StreamSink<NoticeContentEvents> get eventSink => _eventController.sink;
  Stream<NoticeContentEvents> get _eventStream => _eventController.stream;

  final _noticeContentController = StreamController<NoticeContent>();
  StreamSink<NoticeContent> get _contentSink => _noticeContentController.sink;
  Stream<NoticeContent> get contentStream => _noticeContentController.stream;

  final _starController = StreamController<bool>();
  StreamSink<bool> get _starSink => _starController.sink;
  Stream<bool> get starStream => _starController.stream;

  NoticeContentBloc() {
    _eventStream.listen((event) async {
      if (event == NoticeContentEvents.fetchContent) {
        try {
          NoticeContent noticeContent =
              await noticeContentRepository.fetchNoticeContent(noticeIntro.id);
          _contentSink.add(noticeContent);
          if (!noticeIntro.read) {
            var obj = {
              "keyword": "read",
              "notices": [noticeIntro.id]
            };
            await noticeContentRepository.readNotice(obj);
          }
        } catch (e) {
          _contentSink.addError(e.message.toString());
        }
      } else if (event == NoticeContentEvents.toggleStar) {
        if (starred) {
          var obj = {
            "keyword": "unstar",
            "notices": [noticeIntro.id]
          };
          try {
            await noticeContentRepository.unbookmarkNotice(obj);
            starred = !starred;
            _starSink.add(starred);
            showToast('Notice unmarked');
          } catch (e) {
            showToast('Failure unmarking');
          }
        } else {
          var obj = {
            "keyword": "star",
            "notices": [noticeIntro.id]
          };
          try {
            await noticeContentRepository.bookmarkNotice(obj);
            starred = !starred;
            _starSink.add(starred);
            showToast('Notice marked');
          } catch (e) {
            showToast('Failure marking');
          }
        }
      } else if (event == NoticeContentEvents.shareNotice) {
        Share.share(
            'http://internet.channeli.in/noticeboard/notice/' +
                noticeIntro.id.toString(),
            subject: 'Share notice');
      }
    });
  }

  void disposeStreams() {
    _eventController.close();
    _noticeContentController.close();
    _starController.close();
  }
}
