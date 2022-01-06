import 'dart:async';
import 'package:flutter/material.dart';
import '../enum/login_enum.dart';
import '../services/auth/auth_repository.dart';
import '../global/global_functions.dart';

class LoginBloc {
  String _username;
  String _password;
  bool _showPassword = true;
  BuildContext context;

  final _usernameController = StreamController<String>.broadcast();
  StreamSink<String> get usernameSink => _usernameController.sink;
  Stream<String> get _usernameStream => _usernameController.stream;

  final _passwordController = StreamController<String>.broadcast();
  StreamSink<String> get passwordSink => _passwordController.sink;
  Stream<String> get _passwordStream => _passwordController.stream;

  final _allowController = StreamController<bool>.broadcast();
  StreamSink<bool> get _allowedSink => _allowController.sink;
  Stream<bool> get allowedStream => _allowController.stream;

  final _eventController = StreamController<LoginEvents>.broadcast();
  StreamSink<LoginEvents> get eventSink => _eventController.sink;
  Stream<LoginEvents> get _eventStream => _eventController.stream;

  final _showPasswordConroller = StreamController<bool>.broadcast();
  StreamSink<bool> get _showPasswordSink => _showPasswordConroller.sink;
  Stream<bool> get showPasswordStream => _showPasswordConroller.stream;

  final _progressController = StreamController<LoginState>();
  StreamSink<LoginState> get _progressSink => _progressController.sink;
  Stream<LoginState> get progressStream => _progressController.stream;

  AuthRepository _authRepository = AuthRepository();

  LoginBloc() {
    _usernameStream.listen((username) {
      usernameListner(username);
    });
    _passwordStream.listen((password) {
      passwordListener(password);
    });
    _eventStream.listen((event) {
      eventListener(event);
    });
  }

  void disposeStreams() {
    _usernameController.close();
    _passwordController.close();
    _allowController.close();
    _eventController.close();
    _showPasswordConroller.close();
    _progressController.close();
  }

  void checkAllowed() {
    if (_username != null && _password != null)
      _allowedSink.add(true);
    else
      _allowedSink.add(false);
  }

  void usernameListner(String username) {
    if (username != '')
      _username = username;
    else
      _username = null;

    checkAllowed();
  }

  void passwordListener(String password) {
    if (password != '')
      _password = password;
    else
      _password = null;
    checkAllowed();
  }

  void eventListener(LoginEvents event) async {
    if (event == LoginEvents.togglePasswordView) {
      _showPassword = !_showPassword;
      _showPasswordSink.add(_showPassword);
    } else if (event == LoginEvents.loginEvent) {
      try {
        _progressSink.add(LoginState.inProgress);
        await _authRepository.signInWithUsernamePassword(
            username: _username, password: _password, context: context);
      } catch (e) {
        _progressSink.add(LoginState.initLogin);
      }
    }
  }
}
