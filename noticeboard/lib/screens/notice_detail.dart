import 'dart:convert';
import 'package:noticeboard/enum/notice_content_enum.dart';
import 'package:noticeboard/routes/routing_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../global/global_constants.dart';
import '../models/notice_intro.dart';
import 'package:flutter/material.dart';
import '../bloc/notice_content_bloc.dart';
import '../global/global_functions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../styles/notice_detail_consts.dart';

class NoticeDetail extends StatefulWidget {
  final NoticeIntro? noticeIntro;
  NoticeDetail({required this.noticeIntro});

  @override
  _NoticeDetailState createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  final NoticeIntro? noticeIntro;
  _NoticeDetailState({this.noticeIntro});

  NoticeContentBloc _noticeContentBloc = NoticeContentBloc();
  bool pdfAlreadyOpened = false;

  @override
  void initState() {
    _noticeContentBloc.context = context;
    _noticeContentBloc.noticeIntro = widget.noticeIntro;
    _noticeContentBloc.starred = widget.noticeIntro!.starred;
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
        elevation: 0.0,
        leadingWidth: 30.0,
        leading: IconButton(
          icon: screenPopIcon(Colors.white),
          onPressed: () {
            if (previousRoute == launchingRoute) {
              navigatorKey.currentState!
                  .pushReplacementNamed(bottomNavigationRoute);
            } else {
              navigatorKey.currentState!.pop();
            }
          },
        ),
        backgroundColor: globalBlueColor,
        centerTitle: false,
        title: Text(
          widget.noticeIntro!.department!,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (previousRoute == launchingRoute) {
            navigatorKey.currentState!
                .pushReplacementNamed(bottomNavigationRoute);
          } else {
            navigatorKey.currentState!.pop();
          }
          return false;
        },
        child: Container(
          width: _width,
          height: _height * 0.88,
          child: Column(
            children: [buildNoticeIntro(_width), buildNoticeContent(_width)],
          ),
        ),
      ),
    );
  }

  Expanded buildNoticeContent(double width) {
    return Expanded(
      child: Container(
        color: Colors.white,
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
    Uri uri = Uri.dataFromString(
      snapshot.data.content,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
    return Container(
      padding: EdgeInsets.all(10.0),
      child: WebView(
        initialUrl: uri.toString(),
        zoomEnabled: true,
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        navigationDelegate: (navigation) async {
          print(navigation.url);
          if (navigation.url.endsWith("pdf") && !pdfAlreadyOpened) {
            if (await canLaunchUrlString(navigation.url)) {
              String newUrl =
                  "https://docs.google.com/gview?embedded=true&url=${navigation.url}";
              await launchUrlString(newUrl);
            }
            return NavigationDecision.prevent;
          } else {
            if (await canLaunchUrlString(navigation.url)) {
              await launchUrlString(
                navigation.url,
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  Container buildNoticeIntro(double _width) {
    return Container(
      color: globalLightBlueColor,
      width: _width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.noticeIntro!.title!,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            sizedBox(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.noticeIntro!.dateCreated!),
                Row(
                  children: [
                    StreamBuilder<bool?>(
                      stream: _noticeContentBloc.starStream,
                      initialData: widget.noticeIntro!.starred,
                      builder: (context, snapshot) {
                        return GestureDetector(
                            onTap: () {
                              _noticeContentBloc.eventSink
                                  .add(NoticeContentEvents.toggleStar);
                            },
                            child: bookMarkIconDecider(snapshot.data!));
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
                      child: shareIcon,
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
}
