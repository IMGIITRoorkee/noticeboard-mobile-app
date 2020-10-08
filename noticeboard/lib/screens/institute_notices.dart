import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_intro.dart';
import '../enum/insti_notices_enum.dart';
import '../bloc/insti_notices_bloc.dart';
import '../global/global_functions.dart';

class Home extends StatefulWidget {
  final ListNoticeMetaData listNoticeMetaData;
  Home({@required this.listNoticeMetaData});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final InstituteNoticesBloc _instituteNoticesBloc = InstituteNoticesBloc();

  @override
  void initState() {
    _instituteNoticesBloc.context = context;
    _instituteNoticesBloc.listNoticeMetaData = widget.listNoticeMetaData;
    _instituteNoticesBloc.dynamicFetch = widget.listNoticeMetaData.dynamicFetch;
    _instituteNoticesBloc.dynamicFetchNotices();
    super.initState();
  }

  Future<void> refreshNotices() async {
    _instituteNoticesBloc.dynamicFetchNotices();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    _instituteNoticesBloc.disposeStreams();
    super.dispose();
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    _instituteNoticesBloc.pushNoticeDetail(noticeIntro);
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
              _instituteNoticesBloc.eventSink
                  .add(InstituteNoticesEvent.pushFilters);
            },
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: StreamBuilder(
            initialData: widget.listNoticeMetaData.appBarLabel,
            stream: _instituteNoticesBloc.appBarLabelStream,
            builder: (context, snapshot) {
              return Text(
                snapshot.data,
                style: TextStyle(color: Colors.black),
              );
            }),
        automaticallyImplyLeading: false,
        leading: Container(
          padding: EdgeInsets.only(left: 11.0, top: 5.0),
          child: GestureDetector(
            onTap: () {
              _instituteNoticesBloc.eventSink
                  .add(InstituteNoticesEvent.pushProfileEvent);
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[500],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshNotices,
        child: ListView(
          children: [
            Container(
              height: height * 0.88,
              width: width,
              child: StreamBuilder(
                stream: _instituteNoticesBloc.instiNoticesStream,
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
      color: !noticeIntroObj.read ? Colors.white : Colors.grey[200],
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  pushNoticeDetail(noticeIntroObj);
                },
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
            Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                    onTap: () {
                      _instituteNoticesBloc.instituteNoticeObjSink
                          .add(noticeIntroObj);
                    },
                    child: bookMarkIconDecider(noticeIntroObj.starred)))
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
