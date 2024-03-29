import 'package:flutter/material.dart';

var globalLightBlueColor = Color(0xFFedf4ff);
var globalWhiteColor = Colors.white;
var globalBlueColor = Color(0xFF5288da);
var noticeCardColor = Color(0xFFd62727);
var noticeReadColor = Color(0xFFf2f2f2);
var noticeInroGapContainerColor = Color(0xFFC4C4C4);

Icon searchIcon = Icon(
  Icons.search,
  color: globalBlueColor,
  size: 30.0,
);

Text appHeading = Text(
  'Noticeboard',
  style: TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF5288da)),
);

Text impNoticesHeading = Text(
  'Important Notices',
  style: TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w700, color: Color(0xFF444444)),
);

TextStyle departmentTxtStyle = TextStyle(
  fontSize: 14.0,
  color: Color(0xFF444444),
  fontWeight: FontWeight.w700,
);
TextStyle dateTxtStyle = TextStyle(
    fontSize: 12.0, color: Color(0xFF444444), fontWeight: FontWeight.w400);

TextStyle appLabelTxtStyle =
    TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w700);

TextStyle unreadTxtStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12.0);

TextStyle noticeTitleTxtStyle =
    TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700);

Padding buildNoPic() {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 4.0, bottom: 4.0),
    child: Container(
      child: Image.asset('assets/images/user1.jpg'),
    ),
  );
}

BoxDecoration contextMenuDecoration = BoxDecoration(
    color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(15.0)));
