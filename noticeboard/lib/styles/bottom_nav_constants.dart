import 'package:flutter/material.dart';

var globalBlueColor = Color(0xFF5288da);
var globalWhiteColor = Colors.white;

BottomNavigationBarItem instituteNoticesBottomItem = BottomNavigationBarItem(
    icon: Icon(
      Icons.account_balance,
      color: Colors.white,
    ),
    label: 'Institute Notices');

BottomNavigationBarItem placementInternshipBottomItem = BottomNavigationBarItem(
    icon: Icon(
      Icons.school,
      color: Colors.white,
    ),
    label: 'Placement and Internships');

TextStyle fixedBottomItemTextStyle =
    TextStyle(color: Color(0xFFffffff), fontSize: 12.0);
