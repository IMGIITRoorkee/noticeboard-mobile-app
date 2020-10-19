import 'package:flutter/material.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../screens/list_notices.dart';
import '../models/notice_intro.dart';
import '../bloc/bottom_navigator_bloc.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  BottomNavigatorBloc _bottomNavigatorBloc = BottomNavigatorBloc();
  final widgetOptions = [
    ListNotices(
      listNoticeMetaData: ListNoticeMetaData(
          appBarLabel: 'Institute Notices',
          dynamicFetch: DynamicFetch.fetchInstituteNotices,
          noFilters: false),
    ),
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Placement and Internships',
            dynamicFetch: DynamicFetch.fetchPlacementNotices,
            noFilters: false)),
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Important Notices',
            dynamicFetch: DynamicFetch.fetchImportantNotices,
            noFilters: true)),
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Bookmarked Notices',
            dynamicFetch: DynamicFetch.fetchBookmarkedNotices,
            noFilters: true)),
    ListNotices(
        listNoticeMetaData: ListNoticeMetaData(
            appBarLabel: 'Expired Notices',
            dynamicFetch: DynamicFetch.fetchExpiredNotices,
            noFilters: true))
  ];

  @override
  void dispose() {
    _bottomNavigatorBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: 0,
        stream: _bottomNavigatorBloc.indexStream,
        builder: (context, snapshot) {
          return Scaffold(
            body: IndexedStack(
              index: snapshot.data,
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
                    ),
                    label: 'Institute'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                    label: 'Placement and Internships'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.stars,
                      color: Colors.black,
                    ),
                    label: 'Important'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.bookmarks,
                      color: Colors.black,
                    ),
                    label: 'Bookmarked'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.history,
                      color: Colors.black,
                    ),
                    label: 'Expired')
              ],
              currentIndex: snapshot.data,
              fixedColor: Colors.deepPurple,
              onTap: onItemTapped,
            ),
          );
        });
  }

  void onItemTapped(int index) {
    _bottomNavigatorBloc.indexSink.add(index);
  }
}
