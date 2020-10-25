import 'package:flutter/material.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../screens/list_notices.dart';
import '../models/notice_intro.dart';
import '../bloc/bottom_navigator_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

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
              backgroundColor: HexColor('#5288da'),
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_balance,
                      color: Colors.white,
                    ),
                    label: 'Institute notices'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                    label: 'Placement and Internships'),
              ],
              unselectedItemColor: Colors.white,
              currentIndex: snapshot.data,
              fixedColor: Colors.white,
              onTap: onItemTapped,
              iconSize: 25.0,
              unselectedLabelStyle:
                  TextStyle(color: HexColor('#ffffff'), fontSize: 12.0),
            ),
          );
        });
  }

  void onItemTapped(int index) {
    _bottomNavigatorBloc.indexSink.add(index);
  }
}
