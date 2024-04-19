import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:noticeboard/bloc/connectivity_status_bloc.dart';
import 'package:noticeboard/bloc/list_notices_bloc.dart';
import 'package:noticeboard/bloc/notice_detail_bloc.dart';
import 'package:noticeboard/enum/current_widget_enum.dart';
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

// ignore: must_be_immutable
class NoticeDetail extends StatefulWidget {
  final NoticeIntro? noticeIntro;
  List<NoticeIntro?>? listOfNotices;
  ListNoticesBloc listNoticesBloc;
  NoticeDetail(
      {required this.noticeIntro,
      required this.listOfNotices,
      required this.listNoticesBloc});

  @override
  _NoticeDetailState createState() => _NoticeDetailState();
}

class _NoticeDetailState extends State<NoticeDetail> {
  final NoticeIntro? noticeIntro;
  // ignore: unused_element
  _NoticeDetailState({this.noticeIntro});
  final ConnectivityStatusBloc _connectivityStatusBloc =
      ConnectivityStatusBloc();
  NoticeContentBloc _noticeContentBloc = NoticeContentBloc();
  WebViewController _webViewController = WebViewController();
  NoticeDetailBloc _noticeDetailBloc = NoticeDetailBloc();
  bool pdfAlreadyOpened = false;
  bool snackBarShown = false;
  bool isGestureZoom = false;
  Offset currentScrollPos = Offset(0, 0);
  late Timer _timer;
  int currentIndex = 0;
  double currentScale = 1;
  late TransformationController _transformationController;
  Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = Set();
  Set<Factory<OneSequenceGestureRecognizer>> zoomgestureRecognizers = Set();
  @override
  void initState() {
    gestureRecognizers.add(Factory(() => TapAndPanGestureRecognizer()));
    //gestureRecognizers.add(Factory(() => VerticalDragGestureRecognizer()));
    zoomgestureRecognizers.add(Factory(() => PanGestureRecognizer()));
    //zoomgestureRecognizers.add(Factory(() => VerticalDragGestureRecognizer()));
    _transformationController = TransformationController();
    _noticeContentBloc.context = context;
    _connectivityStatusBloc.context = context;
    _connectivityStatusBloc.currentWidget = CurrentWidget.noticeDetail;
    _noticeContentBloc.noticeIntro = widget.noticeIntro;
    _noticeContentBloc.starred = widget.noticeIntro!.starred;
    _noticeContentBloc.eventSink.add(NoticeContentEvents.fetchContent);
    _timer = addConnectivityStatusToSink();
    _noticeDetailBloc.eventStream.listen((event) {
      if (event == CurrentWidget.noticeDetail) {
        _noticeContentBloc.eventSink.add(NoticeContentEvents.fetchContent);
        _webViewController.reload();
      }
    });
    for (int i = 0; i < widget.listOfNotices!.length; i++) {
      if (widget.listOfNotices?[i]?.id == widget.noticeIntro?.id) {
        currentIndex = i;
      }
    }
    if (currentIndex == widget.listOfNotices!.length - 1) {
      widget.listNoticesBloc.loadMore().whenComplete(() {
        setState(() {
          print("Set State called!");
          widget.listOfNotices = widget.listNoticesBloc.dynamicNoticeList;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _noticeContentBloc.disposeStreams();
    if (_timer.isActive) {
      _timer.cancel();
    }
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    isGestureZoom = currentScale > 1;
    print(currentScale);
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
      body: SizedBox.expand(
          child: GestureDetector(
              onHorizontalDragStart: isGestureZoom
                  ? null
                  : (details) {
                      if (isGestureZoom) {
                        return;
                      }
                      if (details.localPosition.dx < 75.0 && Platform.isIOS) {
                        if (previousRoute == launchingRoute) {
                          navigatorKey.currentState!
                              .pushReplacementNamed(bottomNavigationRoute);
                        } else {
                          navigatorKey.currentState!.pop();
                        }
                      }
                    },
              onHorizontalDragEnd: isGestureZoom
                  ? null
                  : (details) {
                      if (isGestureZoom) {
                        return;
                      }
                      if (details.primaryVelocity! > 0 && !isGestureZoom) {
                        // Forward swipe. Have to show previous notice
                        if (currentIndex > 0)
                          widget.listNoticesBloc.swipeBetweenNoticeDetail(
                              widget.listOfNotices![currentIndex - 1]!,
                              widget.listOfNotices,
                              widget.listNoticesBloc,
                              true);
                        else {
                          if (!snackBarShown) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(noprevNoticeSnackBar);
                            snackBarShown = true;
                          }
                        }
                      } else if (details.primaryVelocity! < 0) {
                        // Backward Swipe. Have to show next notice
                        widget.listNoticesBloc.swipeBetweenNoticeDetail(
                            widget.listOfNotices![currentIndex + 1]!,
                            widget.listOfNotices,
                            widget.listNoticesBloc,
                            false);
                      }
                    },
              child: PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  if (didPop) {
                    return;
                  }
                  if (previousRoute == launchingRoute) {
                    navigatorKey.currentState!
                        .pushReplacementNamed(bottomNavigationRoute);
                  } else {
                    navigatorKey.currentState!.pop();
                  }
                },
                child: Container(
                  width: _width,
                  height: _height * 0.88,
                  child: Column(
                    children: [
                      buildNoticeIntro(_width),
                      buildNoticeContent(_width, _height),
                    ],
                  ),
                ),
              ))),
      resizeToAvoidBottomInset: true,
    );
  }

  Expanded buildNoticeContent(double width, double height) {
    return Expanded(
      child: Container(
        color: Colors.white,
        width: width,
        height: height,
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
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (navigation) async {
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
      }))
      //..scrollTo(currentScrollPos.dx.toInt(), currentScrollPos.dy.toInt())
      ..loadRequest(uri).then((value) async {
        if (Platform.isAndroid) await _webViewController.enableZoom(true);
      });
    return Container(
        padding: EdgeInsets.all(10.0),
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          boundaryMargin: EdgeInsets.all(10),
          transformationController: _transformationController,
          onInteractionEnd: (details) {
            print(_transformationController.value.getMaxScaleOnAxis());
            if (_transformationController.value.getMaxScaleOnAxis() !=
                currentScale) {
              setState(() {
                print("Set State called!");

                currentScale =
                    _transformationController.value.getMaxScaleOnAxis();
              });
            }
          },
          child: WebViewWidget(
              controller: _webViewController,
              gestureRecognizers:
                  isGestureZoom ? zoomgestureRecognizers : gestureRecognizers),
        ));
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
