import 'package:flutter/material.dart';
import 'package:noticeboard/routes/routing_constants.dart';
import 'package:noticeboard/styles/launching_constants.dart';
import 'package:noticeboard/styles/profile_constants.dart';
import '../services/auth/auth_repository.dart';
import '../global/global_functions.dart';
import '../styles/launching_constants.dart';
import '../styles/login_constants.dart';

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  final _authRepository = AuthRepository();

  @override
  void initState() {
    initiateBrain();
    super.initState();
  }

  Future initiateBrain() async {
    try {
      await _authRepository.checkIfAlreadySignedIn(context);
    } catch (e) {
      showGenericError(context);
      logout();
    }
  }

  Future logout() async {
    await _authRepository.logout();
    Navigator.pushReplacementNamed(context, loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: globalWhiteColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: _width,
          height: _height,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: mainLaunchingLogo(_width, _height))),
              Positioned(left: 0, right: 0, bottom: 80, child: spinner()),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: lotsOfLove(context, _width))
            ],
          ),
        ),
      ),
    );
  }
}
