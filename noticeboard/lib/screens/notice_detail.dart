import 'package:noticeboard/enum/notice_content_enum.dart';
import '../models/notice_intro.dart';
import 'package:flutter/material.dart';
import '../bloc/notice_content_bloc.dart';
import '../global/global_functions.dart';
import 'package:diagonal_scrollview/diagonal_scrollview.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeDetail extends StatefulWidget {
  final NoticeIntro noticeIntro;
  NoticeDetail({@required this.noticeIntro});

  @override
  _NoticeDetailState createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  final NoticeIntro noticeIntro;
  _NoticeDetailState({this.noticeIntro});

  NoticeContentBloc _noticeContentBloc = NoticeContentBloc();
  final String prefix = 'https://internet.channeli.in/';
  @override
  void initState() {
    _noticeContentBloc.noticeIntro = widget.noticeIntro;
    _noticeContentBloc.starred = widget.noticeIntro.starred;
    _noticeContentBloc.eventSink.add(NoticeContentEvents.fetchContent);
    super.initState();
  }

  @override
  void dispose() {
    _noticeContentBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(
          widget.noticeIntro.department,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: _width,
        height: _height * 0.88,
        child: Column(
          children: [buildNoticeIntro(_width), buildNoticeContent(_width)],
        ),
      ),
    );
  }

  Expanded buildNoticeContent(double width) {
    return Expanded(
      child: Container(
        width: width,
        child: Center(
          child: StreamBuilder(
            stream: _noticeContentBloc.contentStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildContent(snapshot);
              } else if (snapshot.hasError) {
                return buildErrorWidget(snapshot);
              }
              return buildLoadingWidget();
            },
          ),
        ),
      ),
    );
  }

  Container buildContent(AsyncSnapshot snapshot) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: DiagonalScrollView(
        enableZoom: true,
        child: Html(
          data: snapshot.data.content,
          onLinkTap: (link) {
            if (link.startsWith('/')) {
              String channeliLink = prefix;
              channeliLink += link;
              launchURL(channeliLink);
            } else {
              launchURL(link);
            }
          },
        ),
      ),
    );
  }

  Container buildLoadingWidget() =>
      Container(child: CircularProgressIndicator());

  Container buildErrorWidget(AsyncSnapshot snapshot) {
    return Container(
      child: Text(snapshot.error),
    );
  }

  Container buildNoticeIntro(double _width) {
    return Container(
      color: Colors.blue[200],
      width: _width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.noticeIntro.title),
                )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.noticeIntro.dateCreated),
                Row(
                  children: [
                    StreamBuilder(
                      stream: _noticeContentBloc.starStream,
                      initialData: widget.noticeIntro.starred,
                      builder: (context, snapshot) {
                        return GestureDetector(
                            onTap: () {
                              _noticeContentBloc.eventSink
                                  .add(NoticeContentEvents.toggleStar);
                            },
                            child: bookMarkIconDecider(snapshot.data));
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        _noticeContentBloc.eventSink
                            .add(NoticeContentEvents.shareNotice);
                      },
                      child: Icon(
                        Icons.share,
                        size: 30.0,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }
}
