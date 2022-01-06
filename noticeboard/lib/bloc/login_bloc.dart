import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../enum/login_enum.dart';
import '../services/auth/auth_repository.dart';

class LoginBloc {
  BuildContext context;
  AuthRepository _authRepository = AuthRepository();
  final formKey = GlobalKey<FormBuilderState>();

  final _progressController = StreamController<LoginState>();
  StreamSink<LoginState> get _progressSink => _progressController.sink;
  Stream<LoginState> get progressStream => _progressController.stream;

  void disposeStreams() {
    _progressController.close();
  }

  Future<void> login() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _progressSink.add(LoginState.inProgress);
      try {
        String username = formKey.currentState.fields['username'].value;
        String password = formKey.currentState.fields['password'].value;
        await _authRepository.signInWithUsernamePassword(
            username: username, password: password, context: context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid credentials"),
        ));
        _progressSink.add(LoginState.initLogin);
      }
    }
  }
}
