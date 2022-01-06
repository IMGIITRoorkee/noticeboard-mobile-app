import '../services/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../global/global_functions.dart';

class ProfileRepository {
  AuthRepository _authRepository = AuthRepository();
  Future logout(BuildContext context) async {
    await _authRepository.logout();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, loginRoute);
    //showMyFlushBar(context, 'Logout successful', true);
  }
}
