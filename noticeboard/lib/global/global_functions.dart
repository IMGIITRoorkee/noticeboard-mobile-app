import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flushbar/flushbar.dart';

Icon bookMarkIconDecider(bool isBookmarked) {
  if (!isBookmarked)
    return Icon(
      Icons.bookmark_border,
    );
  return Icon(
    Icons.bookmark,
  );
}

String bookMarkTextDecider(bool isBookmarked) {
  if (!isBookmarked) return 'Bookmark';
  return 'Unmark Notice';
}

Container buildShimmerList(BuildContext context, int notices) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    height: 80.0,
    child: ListView.builder(
        itemCount: notices,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.grey[200],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.9,
                    height: 10.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: width * 0.4,
                    height: 10.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: width * 0.9,
                    height: 10.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }),
  );
}

SpinKitFadingCube spinner() {
  return SpinKitFadingCube(
    color: Colors.blue[900],
    size: 40.0,
  );
}

void showMyFlushBar(BuildContext context, String message, bool success) {
  Flushbar(
    margin: EdgeInsets.only(top: 50.0, left: 100.0, right: 100.0),
    padding: EdgeInsets.all(10.0),
    borderRadius: 3.0,
    backgroundColor: success ? Colors.green[400] : Colors.red[400],
    boxShadows: [
      BoxShadow(color: Colors.black45, offset: Offset(3, 3), blurRadius: 3)
    ],
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    duration: Duration(seconds: 2),
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ],
    ),
    flushbarPosition: FlushbarPosition.TOP,
  )..show(context);
}
