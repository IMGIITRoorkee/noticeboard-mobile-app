import '../services/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import '../routes/routing_constants.dart';
import '../global/toast.dart';

class ProfileRepository {
  AuthRepository _authRepository = AuthRepository();
  Future logout(BuildContext context) async {
    await _authRepository.logout();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, loginRoute);
    showToast('Logout Successful');
  }
}
