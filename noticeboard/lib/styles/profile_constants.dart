import 'package:flutter/material.dart';
import 'package:noticeboard/global/global_functions.dart';

var globalWhiteColor = Colors.white;

TextStyle blackSuperBoldMediumSizeText =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0);

TextStyle lightGreySmallSizeText =
    TextStyle(color: Color(0xFF999999), fontSize: 12.0);

TextStyle boldMediumGreyMediumSizeText = TextStyle(
    fontWeight: FontWeight.w400, color: Color(0xFF5288da), fontSize: 16.0);

SizedBox sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

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
Icon aboutUsIcon = Icon(
  Icons.person_search_sharp,
  color: globalBlue,
);

Container divider(double width) {
  return Container(
    color: Color(0xFF5288da),
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
