import 'package:flutter/material.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../screens/list_notices.dart';
import '../models/notice_intro.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedIndex = 0;
  final widgetOptions = [
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Institute Notices',
            dynamicFetch: DynamicFetch.fetchInstituteNotices)),
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Placement and Internships',
            dynamicFetch: DynamicFetch.fetchPlacementNotices))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance,
                color: Colors.black,
                size: 30.0,
              ),
              label: 'Institute Notices'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
                color: Colors.black,
                size: 30.0,
              ),
              label: 'Placement and Internships'),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
