import '../global/global_constants.dart';
import '../services/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../global/global_functions.dart';

class ProfileRepository {
  AuthRepository _authRepository = AuthRepository();
  Future logout(BuildContext context) async {
    try {
      await _authRepository.logout();
      navigatorKey.currentState!.pop();
      navigatorKey.currentState!.pushNamed(loginRoute);
    } catch (e) {
      showGenericError();
    }
  }
}
