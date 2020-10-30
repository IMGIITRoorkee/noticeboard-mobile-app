import 'dart:async';
import 'package:flutter/material.dart';
import '../enum/search_enum.dart';

class SearchBloc {
  String searchQuery;
  BuildContext context;
  bool isSearching = false;

  final _eventController = StreamController<SearchEvents>();
  StreamSink<SearchEvents> get eventSink => _eventController.sink;
  Stream<SearchEvents> get _eventStream => _eventController.stream;

  final _isSearchingController = StreamController<bool>();
  StreamSink<bool> get _isSearchingSink => _isSearchingController.sink;
  Stream<bool> get isSearchingStream => _isSearchingController.stream;

  final _queryController = StreamController<String>();
  StreamSink<String> get querySink => _queryController.sink;
  Stream<String> get _queryStream => _queryController.stream;

  void enableClear() {
    isSearching = true;
    _isSearchingSink.add(isSearching);
  }

  void disableClear() {
    isSearching = false;
    _isSearchingSink.add(isSearching);
  }

  SearchBloc() {
    _queryStream.listen((query) {
      searchQuery = query;
      print(searchQuery);
      if (searchQuery == '') {
        disableClear();
      } else {
        enableClear();
      }
    });
    _eventStream.listen((event) {});
  }

  void disposeStreams() {
    _eventController.close();
    _isSearchingController.close();
    _queryController.close();
  }
}
