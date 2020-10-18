import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/modals.dart';
import 'package:noticeboard/models/notice_intro.dart';
import '../enum/list_notices_enum.dart';
import '../bloc/list_notices_bloc.dart';
import '../global/global_functions.dart';
import 'package:focused_menu/focused_menu.dart';

class ListNotices extends StatefulWidget {
  final ListNoticeMetaData listNoticeMetaData;
  ListNotices({@required this.listNoticeMetaData});
  @override
  _ListNoticesState createState() => _ListNoticesState();
}

class _ListNoticesState extends State<ListNotices> {
  final ScrollController _sc = new ScrollController();
  final ListNoticesBloc _listNoticesBloc = ListNoticesBloc();

  @override
  void initState() {
    _listNoticesBloc.context = context;
    _listNoticesBloc.listNoticeMetaData = widget.listNoticeMetaData;
    _listNoticesBloc.dynamicFetch = widget.listNoticeMetaData.dynamicFetch;
    _listNoticesBloc.dynamicFetchNotices();
    super.initState();
    // _sc.addListener(() {
    //   if (_sc.position.pixels == _sc.position.maxScrollExtent) {
    //     _listNoticesBloc.loadMore();
    //   }
    // });
  }

  Future<void> refreshNotices() async {
    _listNoticesBloc.dynamicFetchNotices();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    _listNoticesBloc.disposeStreams();
    super.dispose();
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    _listNoticesBloc.pushNoticeDetail(noticeIntro);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: () {
              _listNoticesBloc.eventSink.add(ListNoticesEvent.pushFilters);
            },
          )
        ],
        elevation: 4,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: StreamBuilder(
            initialData: widget.listNoticeMetaData.appBarLabel,
            stream: _listNoticesBloc.appBarLabelStream,
            builder: (context, snapshot) {
              return Text(
                snapshot.data,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              );
            }),
        automaticallyImplyLeading: false,
        leading: Container(
          padding: EdgeInsets.only(left: 11.0),
          child: GestureDetector(
            onTap: () {
              _listNoticesBloc.eventSink.add(ListNoticesEvent.pushProfileEvent);
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.account_circle,
                color: Colors.black,
                size: 45.0,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshNotices,
        child: ListView(
          children: [
            Container(
              height: height * 0.80,
              width: width,
              child: StreamBuilder(
                stream: _listNoticesBloc.listNoticesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) return buildNoResults();
                    return buildNoticesList(snapshot, width, height);
                  } else if (snapshot.hasError) {
                    return buildErrorWidget(snapshot);
                  }
                  return buildLoading();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildNoticesList(
      AsyncSnapshot snapshot, double width, double height) {
    return Container(
      width: width,
      child: RefreshIndicator(
        onRefresh: refreshNotices,
        child: ListView.separated(
            controller: _sc,
            separatorBuilder: (context, index) => Container(
                  width: width,
                  color: Colors.black,
                  height: 2.0,
                ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              NoticeIntro noticeIntroObj = snapshot.data[index];
              return buildListItem(noticeIntroObj, width, height);
            }),
      ),
    );
  }

  Container buildListItem(
      NoticeIntro noticeIntroObj, double width, double height) {
    return Container(
      color: !noticeIntroObj.read ? Colors.white : Colors.grey[400],
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              //pushNoticeDetail(noticeIntroObj);
              child: FocusedMenuHolder(
                onPressed: () {
                  pushNoticeDetail(noticeIntroObj);
                },
                menuWidth: MediaQuery.of(context).size.width * 0.50,
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                duration: Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                menuOffset:
                    10.0, // Offset value to show menuItem from the selected item
                bottomOffsetHeight:
                    80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                menuItems: <FocusedMenuItem>[
                  // Add Each FocusedMenuItem  for Menu Options
                  FocusedMenuItem(
                      title: Text(bookMarkTextDecider(noticeIntroObj.starred)),
                      trailingIcon: bookMarkIconDecider(noticeIntroObj.starred),
                      onPressed: () {
                        _listNoticesBloc.toggleBookMarkSink.add(noticeIntroObj);
                        HapticFeedback.lightImpact();
                      }),

                  !noticeIntroObj.read
                      ? FocusedMenuItem(
                          title: Text("Mark as Read"),
                          trailingIcon: Icon(Icons.visibility),
                          onPressed: () {
                            _listNoticesBloc.markReadSink.add(noticeIntroObj);
                            HapticFeedback.lightImpact();
                          })
                      : FocusedMenuItem(
                          title: Text("Mark as unread"),
                          trailingIcon: Icon(Icons.visibility_off),
                          onPressed: () {
                            _listNoticesBloc.markUnreadSink.add(noticeIntroObj);
                            HapticFeedback.lightImpact();
                          }),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: width,
                        child: Text(
                          noticeIntroObj.department,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: width,
                      child: Text(noticeIntroObj.dateCreated,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                        width: width,
                        child: Text(noticeIntroObj.title,
                            overflow: TextOverflow.ellipsis))
                  ],
                ),
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.only(left: 10.0),
            //     child: GestureDetector(
            //         onTap: () {
            //           _listNoticesBloc.noticeObjSink.add(noticeIntroObj);
            //         },
            //         child: bookMarkIconDecider(noticeIntroObj.starred)))
          ],
        ),
      ),
    );
  }

  Center buildNoResults() {
    return Center(
      child: Text('No Notices'),
    );
  }

  Center buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center buildErrorWidget(AsyncSnapshot snapshot) =>
      Center(child: Text(snapshot.error));
}
