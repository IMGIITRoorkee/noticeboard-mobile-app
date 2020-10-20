import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

Container buildShimmerList(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    child: ListView.builder(
        itemCount: 3,
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
