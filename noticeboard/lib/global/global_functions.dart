import 'package:flutter/material.dart';

Icon bookMarkIconDecider(bool isBookmarked) {
  if (isBookmarked)
    return Icon(
      Icons.bookmark,
    );
  return Icon(
    Icons.bookmark_border,
  );
}
