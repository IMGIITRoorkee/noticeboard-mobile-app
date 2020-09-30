import 'dart:async';
import 'package:noticeboard/repository/insti_notices_repository.dart';
import '../models/notice_intro.dart';
import '../enum/insti_notices_enum.dart';
import 'package:flutter/material.dart';

class InstituteNoticesBloc {
  BuildContext context;

  final _eventController = StreamController<InstituteNoticesEvent>();
  StreamSink<InstituteNoticesEvent> get eventSink => _eventController.sink;
  Stream<InstituteNoticesEvent> get _eventStream => _eventController.stream;

  final _instituteNoticesController = StreamController<List<NoticeIntro>>();
  StreamSink<List<NoticeIntro>> get _instiNoticesSink =>
      _instituteNoticesController.sink;
  Stream<List<NoticeIntro>> get instiNoticesStream =>
      _instituteNoticesController.stream;

  InstituteNoticesRepository _instituteNoticesRepository =
      InstituteNoticesRepository();

  InstituteNoticesBloc() {
    _eventStream.listen((event) async {
      if (event == InstituteNoticesEvent.pushProfileEvent) {
        _instituteNoticesRepository.pushProfileScreen(context);
      } else if (event == InstituteNoticesEvent.fetchInstituteNotices) {
        try {
          List<NoticeIntro> allinstituteNotices =
              await _instituteNoticesRepository.fetchInstituteNotices();
          _instiNoticesSink.add(allinstituteNotices);
        } catch (e) {
          _instiNoticesSink.addError(e.message.toString());
        }
      }
    });
  }

  void disposeStreams() {
    _eventController.close();
    _instituteNoticesController.close();
  }
}
