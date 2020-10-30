import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

var globalBlueColor = HexColor('#5288da');
var globalWhiteColor = Colors.white;

BottomNavigationBarItem instituteNoticesBottomItem = BottomNavigationBarItem(
    icon: Icon(
      Icons.account_balance,
      color: Colors.white,
    ),
    label: 'Institute notices');

BottomNavigationBarItem placementInternshipBottomItem = BottomNavigationBarItem(
    icon: Icon(
      Icons.school,
      color: Colors.white,
    ),
    label: 'Placement and Internships');

TextStyle fixedBottomItemTextStyle =
    TextStyle(color: HexColor('#ffffff'), fontSize: 12.0);
