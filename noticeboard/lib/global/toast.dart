import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  cancelToast();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blue[700],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void cancelToast() {
  Fluttertoast.cancel();
}
