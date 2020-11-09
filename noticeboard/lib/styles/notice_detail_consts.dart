import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../global/global_functions.dart';

var globalLightBlueColor = HexColor('#edf4ff');
var globalWhiteColor = Colors.white;
var globalBlueColor = HexColor('#5288da');

Icon shareIcon = Icon(
  Icons.share,
  size: 25.0,
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
