import 'package:flutter/material.dart';

TextStyle launchingTextStyle =
    TextStyle(color: Colors.blue, fontSize: 25.0, fontWeight: FontWeight.bold);

Container mainLaunchingLogo(double width, double height) {
  return Container(
    width: width * 0.60,
    height: width * 0.60,
    child: FittedBox(
      child: Image.asset('assets/images/splash_logo.png'),
      fit: BoxFit.fill,
    ),
  );
}
