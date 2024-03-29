import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noticeboard/global/global_functions.dart';
import '../enum/dynamic_fetch_enum.dart';
import '../screens/list_notices.dart';
import '../models/notice_intro.dart';
import '../bloc/bottom_navigator_bloc.dart';
import '../styles/bottom_nav_constants.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  BottomNavigatorBloc _bottomNavigatorBloc = BottomNavigatorBloc();
  late Timer _timer;
  final widgetOptions = [
    ListNotices(
      listNoticeMetaData: ListNoticeMetaData(
        appBarLabel: 'Institute Notices',
        dynamicFetch: DynamicFetch.fetchInstituteNotices,
        noFilters: false,
        isSearch: false,
      ),
    ),
    ListNotices(
      listNoticeMetaData: ListNoticeMetaData(
        appBarLabel: 'Placement and Internships',
        dynamicFetch: DynamicFetch.fetchPlacementNotices,
        noFilters: false,
        isSearch: false,
      ),
    ),
  ];

  void onItemTapped(int index) {
    _bottomNavigatorBloc.indexSink.add(index);
  }

  @override
  void initState() {
    _timer = addConnectivityStatusToSink();
    super.initState();
  }

  @override
  void dispose() {
    _bottomNavigatorBloc.disposeStreams();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        await Future.delayed(
          Duration(milliseconds: 500),
        );
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
        }
      },
      child: StreamBuilder<int>(
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
              backgroundColor: globalBlueColor,
              items: <BottomNavigationBarItem>[
                instituteNoticesBottomItem,
                placementInternshipBottomItem,
              ],
              unselectedItemColor: Color(0XFFD4D4D4),
              currentIndex: snapshot.data!,
              fixedColor: globalWhiteColor,
              onTap: onItemTapped,
              iconSize: 25.0,
              unselectedLabelStyle: fixedBottomItemTextStyle,
              selectedLabelStyle: fixedBottomItemTextStyle,
            ),
          );
        },
      ),
    );
  }
}
