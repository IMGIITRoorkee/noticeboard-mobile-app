import 'package:flutter/material.dart';

Icon bookMarkIconDecider(bool isBookmarked) {
  if (isBookmarked)
    return Icon(
      Icons.bookmark,
      size: 30.0,
    );
  return Icon(
    Icons.bookmark_border,
    size: 30.0,
  );
}
