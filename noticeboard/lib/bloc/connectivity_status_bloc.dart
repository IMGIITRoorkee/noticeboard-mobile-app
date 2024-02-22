import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noticeboard/enum/connectivity_status_enum.dart';

class ConnectivityStatusBloc {
  late BuildContext context;
  final _eventController = StreamController<ConnectivityStatus>();
  StreamSink<ConnectivityStatus> get eventSink => _eventController.sink;
  Stream<ConnectivityStatus> get _eventStream => _eventController.stream;
  ConnectivityStatus previousResult = ConnectivityStatus.connected;

  static final ConnectivityStatusBloc _connectivityStatusBloc =
      ConnectivityStatusBloc._();

  final networkSnackBar =
      const SnackBar(content: Text("Please check your internet connection!"));
  final backOnlineSnackbar = const SnackBar(content: Text("Back online!"));

  factory ConnectivityStatusBloc() => _connectivityStatusBloc;

  ConnectivityStatusBloc._() {
    _eventStream.listen((connectivityEvent) {
      if (connectivityEvent == ConnectivityStatus.notConnected &&
          previousResult == ConnectivityStatus.connected &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(networkSnackBar);
      } else if (connectivityEvent == ConnectivityStatus.connected &&
          previousResult == ConnectivityStatus.notConnected &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(backOnlineSnackbar);
      }
      previousResult = connectivityEvent;
    });
  }

  void disposeStream() {
    _eventController.close();
  }
}
