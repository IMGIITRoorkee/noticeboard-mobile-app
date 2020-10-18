import 'dart:async';

class BottomNavigatorBloc {
  final _indexController = StreamController<int>();
  StreamSink<int> get indexSink => _indexController.sink;
  Stream<int> get indexStream => _indexController.stream;

  void disposeStreams() {
    _indexController.close();
  }
}
