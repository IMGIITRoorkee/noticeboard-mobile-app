import 'dart:async';

import 'package:noticeboard/enum/current_widget_enum.dart';

class NoticeDetailBloc {
  final _eventController = StreamController<CurrentWidget>.broadcast();
  StreamSink<CurrentWidget> get eventSink => _eventController.sink;
  Stream<CurrentWidget> get eventStream => _eventController.stream;
  static final NoticeDetailBloc _noticeDetailBloc = NoticeDetailBloc._();
  factory NoticeDetailBloc() => _noticeDetailBloc;
  NoticeDetailBloc._();
}
