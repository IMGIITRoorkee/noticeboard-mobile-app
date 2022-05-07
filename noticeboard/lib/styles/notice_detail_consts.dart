import 'package:flutter/material.dart';
import '../global/global_functions.dart';

var globalLightBlueColor = Color(0xFFedf4ff);
var globalWhiteColor = Colors.white;
var globalBlueColor = Color(0xFF5288da);

Icon shareIcon = Icon(
  Icons.share,
  size: 25.0,
);

Container buildErrorContainer(AsyncSnapshot snapshot) {
  return Container(
    child: Text(snapshot.error as String),
  );
}

Container buildLoadingWidget() => Container(child: spinner());

SizedBox sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}
