import 'package:flutter/material.dart';
import 'package:noticeboard/styles/launching_constants.dart';
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
    _authRepository.checkIfAlreadySignedIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _width * 0.5,
            ),
            mainLaunchingLogo(_width, _height),
            sizedBox(_width * 0.5),
            spinner(),
            sizedBox(_width * 0.1),
            lotsOfLove(context, _width)
          ],
        ),
      ),
    );
  }
}
