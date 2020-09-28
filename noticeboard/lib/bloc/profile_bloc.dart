import 'dart:async';
import 'package:noticeboard/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import '../enum/profile_enum.dart';

class ProfileBloc {
  BuildContext context;

  final _eventController = StreamController<ProfileEvents>();
  StreamSink<ProfileEvents> get eventSink => _eventController.sink;
  Stream<ProfileEvents> get _eventStream => _eventController.stream;

  ProfileRepository _profileRepository = ProfileRepository();

  ProfileBloc() {
    _eventStream.listen((event) {
      if (event == ProfileEvents.logoutEvent) {
        _profileRepository.logout(context);
      }
    });
  }

  void disposeStreams() {
    _eventController.close();
  }
}
