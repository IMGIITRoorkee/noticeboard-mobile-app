import 'package:flutter/material.dart';

Icon visibilityOnIcon = Icon(Icons.visibility);
Icon visibilityOffIcon = Icon(Icons.visibility_off);

Text loginHeading = Text(
  "Log In",
  style: TextStyle(fontSize: 17.0, color: Colors.white),
);

const InputDecoration usernameDecoration =
    InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person));
SizedBox sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget containsBranding(BuildContext context, double _width, double _height) {
  return Container(
    width: _width * 0.75,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Icon(
            Icons.feedback,
            size: _width * 0.15,
            color: Colors.blueAccent[200],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Channel i',
            style: TextStyle(
                color: Colors.blueAccent[200], fontSize: _width * 0.1),
          ),
        ),
      ],
    ),
  );
}

Container buildContactImgContainer(double _width) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Having trouble signing in?",
          style: TextStyle(fontSize: 12.0),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "Contact IMG",
          overflow: TextOverflow.fade,
          style: TextStyle(
              fontSize: 12.0,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget lotsOfLove(BuildContext context, double _width) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Made With ",
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      Icon(
        Icons.favorite,
        color: Colors.red[900],
      ),
      Text(
        " by IMG",
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
    ],
  );
}
