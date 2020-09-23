import 'dart:async';
import '../enum/login_enum.dart';

class LoginBloc {
  String _email;
  String _password;
  bool _showPassword = true;

  final _emailController = StreamController<String>();
  StreamSink<String> get emailSink => _emailController.sink;
  Stream<String> get _emailStream => _emailController.stream;

  final _passwordController = StreamController<String>();
  StreamSink<String> get passwordSink => _passwordController.sink;
  Stream<String> get _passwordStream => _passwordController.stream;

  final _allowController = StreamController<bool>();
  StreamSink<bool> get _allowedSink => _allowController.sink;
  Stream<bool> get allowedStream => _allowController.stream;

  final _eventController = StreamController<LoginEvents>();
  StreamSink<LoginEvents> get eventSink => _eventController.sink;
  Stream<LoginEvents> get _eventStream => _eventController.stream;

  final _showPasswordConroller = StreamController<bool>();
  StreamSink<bool> get _showPasswordSink => _showPasswordConroller.sink;
  Stream<bool> get showPasswordStream => _showPasswordConroller.stream;

  LoginBloc() {
    _emailStream.listen((email) {
      if (email != '')
        _email = email;
      else
        _email = null;

      checkAllowed();
    });
    _passwordStream.listen((password) {
      if (password != '')
        _password = password;
      else
        _password = null;
      checkAllowed();
    });
    _eventStream.listen((event) {
      if (event == LoginEvents.togglePasswordView) {
        _showPassword = !_showPassword;
        _showPasswordSink.add(_showPassword);
      }
    });
  }

  void disposeStreams() {
    _emailController.close();
    _passwordController.close();
    _allowController.close();
    _eventController.close();
    _showPasswordConroller.close();
  }

  void checkAllowed() {
    if (_email != null && _password != null)
      _allowedSink.add(true);
    else
      _allowedSink.add(false);
  }
}
