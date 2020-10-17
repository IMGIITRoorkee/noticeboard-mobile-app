import 'package:flutter/material.dart';

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
