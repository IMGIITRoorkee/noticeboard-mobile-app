import 'package:flutter/material.dart';
import 'package:noticeboard/models/notice_intro.dart';
import '../enum/insti_notices_enum.dart';
import '../bloc/insti_notices_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final InstituteNoticesBloc _instituteNoticesBloc = InstituteNoticesBloc();

  @override
  void initState() {
    _instituteNoticesBloc.context = context;
    fetchNoticeEventSink();
    super.initState();
  }

  void fetchNoticeEventSink() {
    _instituteNoticesBloc.eventSink
        .add(InstituteNoticesEvent.fetchInstituteNotices);
  }

  Future refreshNotices() async {
    fetchNoticeEventSink();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    _instituteNoticesBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Institute Notices',
          style: TextStyle(color: Colors.black),
        ),
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
              height: _height * 0.88,
              width: _width,
              child: StreamBuilder(
                stream: _instituteNoticesBloc.instiNoticesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) return buildNoResults();
                    return buildNoticesList(snapshot, _width);
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

  Center buildNoticesList(AsyncSnapshot snapshot, double width) {
    return Center(
      child: Container(
        width: width * 0.9,
        child: RefreshIndicator(
          onRefresh: refreshNotices,
          child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                NoticeIntro noticeIntroObj = snapshot.data[index];
                return Text(noticeIntroObj.title);
              }),
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
