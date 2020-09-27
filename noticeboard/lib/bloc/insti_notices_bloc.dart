import 'dart:async';
import 'package:noticeboard/repository/insti_notices_repository.dart';

import '../enum/insti_notices_enum.dart';
import 'package:flutter/material.dart';

class InstituteNoticesBloc {
  BuildContext context;

  final _eventController = StreamController<InstituteNoticesEvent>();
  StreamSink<InstituteNoticesEvent> get eventSink => _eventController.sink;
  Stream<InstituteNoticesEvent> get _eventStream => _eventController.stream;

  InstituteNoticesRepository _instituteNoticesRepository =
      InstituteNoticesRepository();

  InstituteNoticesBloc() {
    _eventStream.listen((event) {
      if (event == InstituteNoticesEvent.pushProfileEvent) {
        _instituteNoticesRepository.pushProfileScreen(context);
      }
    });
  }

  void disposeStreams() {
    _eventController.close();
  }
}
