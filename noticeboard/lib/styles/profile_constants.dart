import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noticeboard/global/global_functions.dart';

var globalWhiteColor = Colors.white;
var globalBlue = HexColor('#5288da');

TextStyle blackSuperBoldMediumSizeText =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0);

TextStyle lightGreySmallSizeText =
    TextStyle(color: HexColor('#999999'), fontSize: 12.0);

TextStyle boldMediumGreyMediumSizeText = TextStyle(
    fontWeight: FontWeight.w400, color: HexColor('#5288da'), fontSize: 16.0);

SizedBox sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Icon screenPopIcon = Icon(
  Icons.keyboard_arrow_left,
  color: Colors.black,
  size: 35.0,
);

Icon bookmarkIcon = Icon(
  Icons.collections_bookmark,
  color: globalBlue,
);
Icon feedbackIcon = Icon(
  Icons.feedback,
  color: globalBlue,
);
Icon notificationSettingsIcon = Icon(
  Icons.settings,
  color: globalBlue,
);
Icon logoutIcon = Icon(
  Icons.exit_to_app,
  color: globalBlue,
);

Container divider(double width) {
  return Container(
    color: HexColor('#5288da'),
    width: width,
    height: 2.0,
  );
}

Center inProgress = Center(
  child: spinner(),
);

Center errorFetchingProfile(String text) {
  return Center(
    child: Text(text),
  );
}

Container noOverFlowTextContainer(double width, String text, TextStyle style) {
  return Container(
    width: width,
    child: Center(
      child: Text(
        text,
        style: style,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
      ),
    ),
  );
}
