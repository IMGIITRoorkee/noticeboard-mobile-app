import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hexcolor/hexcolor.dart';

Icon bookMarkIconDecider(bool isBookmarked) {
  if (!isBookmarked)
    return Icon(
      Icons.bookmark_border,
      color: HexColor('#F8C384'),
      size: 25.0,
    );
  return Icon(
    Icons.bookmark,
    color: HexColor('#F8C384'),
    size: 25.0,
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
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 19.0, vertical: 20.0),
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

SpinKitChasingDots spinner() {
  return SpinKitChasingDots(
    duration: Duration(milliseconds: 1000),
    color: Colors.blue[900],
    size: 35.0,
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

Container buildSearchBar() {
  return Container(
    height: 50.0,
    padding: EdgeInsets.symmetric(vertical: 6.0),
    child: TextField(
      decoration: new InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        filled: true,
        fillColor: Colors.grey[300],
        hintText: 'Search all notices',
      ),
    ),
  );
}

Widget buildFilterActive(bool filterActive) {
  if (filterActive) {
    return Container(
      margin: EdgeInsets.only(top: 4.0),
      child: Stack(
        children: [
          Icon(
            Icons.filter_list,
            color: HexColor('#5288da'),
            size: 30.0,
          ),
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 6.0,
              backgroundColor: Colors.red,
            ),
          )
        ],
      ),
    );
  }
  return Icon(
    Icons.filter_list,
    color: HexColor('#5288da'),
    size: 30.0,
  );
}

Widget buildSearchFilterActive(bool filterActive) {
  if (filterActive) {
    return Container(
      child: Stack(
        children: [
          Icon(
            Icons.filter_list,
            color: HexColor('#5288da'),
            size: 30.0,
          ),
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 6.0,
              backgroundColor: Colors.red,
            ),
          )
        ],
      ),
    );
  }
  return Icon(
    Icons.filter_list,
    color: HexColor('#5288da'),
    size: 30.0,
  );
}

Center buildNoResults() {
  return Center(
    child: Container(
        width: 250.0,
        height: 250.0,
        child: Image.asset('assets/images/no_notices.png')),
  );
}

Center buildErrorWidget(AsyncSnapshot snapshot) => Center(
    child: Container(
        width: 250.0,
        height: 250.0,
        child: Image.asset('assets/images/error.png')));
