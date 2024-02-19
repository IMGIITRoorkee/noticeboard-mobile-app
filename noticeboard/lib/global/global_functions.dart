import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:noticeboard/enum/connectivity_status_enum.dart';
import 'package:noticeboard/global/global_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Icon bookMarkIconDecider(bool isBookmarked) {
  if (!isBookmarked)
    return Icon(
      Icons.bookmark_border,
      color: Color(0xFFF8C384),
      size: 25.0,
    );
  return Icon(
    Icons.bookmark,
    color: Color(0xFFF8C384),
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
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
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

SpinKitFadingCircle spinner() {
  return SpinKitFadingCircle(
    duration: Duration(milliseconds: 1000),
    color: globalBlue,
    size: 35.0,
  );
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
            color: Color(0xFF5288da),
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
    color: Color(0xFF5288da),
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
            color: Color(0xFF5288da),
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
    color: Color(0xFF5288da),
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

Icon screenPopIcon(Color color) {
  return Icon(
    Icons.keyboard_arrow_left,
    color: color,
    size: 35.0,
  );
}

var globalBlue = Color(0xFF5288da);

Widget themeFormTextField(
    String fieldName, String fieldHint, BuildContext context, bool isNumeric,
    {bool isPassword = false}) {
  return Container(
    margin: EdgeInsets.only(bottom: 15.0),
    child: FormBuilderTextField(
      obscureText: isPassword,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          isCollapsed: true,
          hintText: fieldHint),
      name: fieldName,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.name,
      validator: FormBuilderValidators.required(),
    ),
  );
}

void showGenericError() {
  snackKey.currentState!.showSnackBar(SnackBar(
    content: Text("Error!"),
  ));
}

Future<ConnectivityStatus> checkConnectivityStatus() async {
  try {
    final result = await InternetAddress.lookup("www.example.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return ConnectivityStatus.connected;
    }
    else{
      return ConnectivityStatus.notConnected;
    }
  } catch (e) {
    return ConnectivityStatus.notConnected;
  }
}
