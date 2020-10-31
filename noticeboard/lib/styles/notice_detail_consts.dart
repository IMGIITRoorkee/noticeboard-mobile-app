import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../global/global_functions.dart';

var globalLightBlue = Colors.blue[200];
var globalWhiteColor = Colors.white;
var globalBlue = HexColor('#5288da');

Icon shareIcon = Icon(
  Icons.share,
  size: 30.0,
);

Container buildErrorContainer(AsyncSnapshot snapshot) {
  return Container(
    child: Text(snapshot.error),
  );
}

Container buildLoadingWidget() => Container(child: spinner());

SizedBox sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}
