import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/modals.dart';
import 'package:noticeboard/models/filters_list.dart';
import 'package:noticeboard/models/notice_intro.dart';
import 'package:noticeboard/services/auth/auth_repository.dart';
import '../enum/list_notices_enum.dart';
import '../bloc/list_notices_bloc.dart';
import '../global/global_functions.dart';
import 'package:focused_menu/focused_menu.dart';
import 'filters.dart';
import '../styles/list_notices_consts.dart';
import 'package:hexcolor/hexcolor.dart';

class ListNotices extends StatefulWidget {
  final ListNoticeMetaData listNoticeMetaData;
  ListNotices({@required this.listNoticeMetaData});
  @override
  _ListNoticesState createState() => _ListNoticesState();
}

class _ListNoticesState extends State<ListNotices> {
  final ListNoticesBloc _listNoticesBloc = ListNoticesBloc();
  final AuthRepository _authRepository = AuthRepository();
  TextEditingController _controller; // search

  @override
  void initState() {
    _controller = TextEditingController(); // search
    _listNoticesBloc.context = context;
    _listNoticesBloc.listNoticeMetaData = widget.listNoticeMetaData;
    _controller.addListener(_handleQueryChanges);
    _listNoticesBloc.dynamicFetch = widget.listNoticeMetaData.dynamicFetch;
    _listNoticesBloc.dynamicFetchNotices();
    super.initState();
  }

  Future<void> refreshNotices() async {
    _listNoticesBloc.refreshNotices();
    await Future.delayed(Duration(seconds: 1));
  }

  _handleQueryChanges() {
    _listNoticesBloc.querySink.add(_controller.text);
  }

  void clearSearch() {
    _controller.clear();
  }

  @override
  void dispose() {
    _listNoticesBloc.disposeStreams();
    _controller.dispose();
    super.dispose();
  }

  void pushNoticeDetail(NoticeIntro noticeIntro) {
    _listNoticesBloc.pushNoticeDetail(noticeIntro);
  }

  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _listNoticesBloc.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: widget.listNoticeMetaData.noFilters
          ? buildNoFiltersAppBar()
          : widget.listNoticeMetaData.isSearch
              ? buildSearchBar(context)
              : buildFiltersAppBar(),
      body: widget.listNoticeMetaData.noFilters
          ? buildListNoticesBox(height, width)
          : buildAdvanceNoticesBox(height, width),
    );
  }

  PreferredSize buildSearchBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(65),
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 2.0,
                offset: Offset(0.0, 0.30))
          ], color: Colors.white),
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Expanded(
                child: TextField(
                  onSubmitted: (String val) {
                    _listNoticesBloc.searchHandler();
                  },
                  controller: _controller,
                  keyboardType: TextInputType.name,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: StreamBuilder<Object>(
                        stream: _listNoticesBloc.isSearchingStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (snapshot.data) {
                            return IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: HexColor('#5288da'),
                              ),
                              onPressed: clearSearch,
                            );
                          }
                          return Icon(
                            Icons.search,
                            color: HexColor('#5288da'),
                          );
                        }),
                    filled: true,
                    fillColor: HexColor('#edf4ff'),
                    hintText: 'Search all notices',
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              IconButton(
                icon: StreamBuilder(
                    stream: _listNoticesBloc.filterActiveStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return buildSearchFilterActive(snapshot.data);
                    }),
                onPressed: () {
                  _listNoticesBloc.toggleVisibility();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildFiltersAppBar() {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
            icon: searchIcon,
            onPressed: () {
              _listNoticesBloc.pushSearch();
            }),
        IconButton(
          icon: StreamBuilder(
              stream: _listNoticesBloc.filterActiveStream,
              initialData: false,
              builder: (context, snapshot) {
                return buildFilterActive(snapshot.data);
              }),
          onPressed: () {
            _listNoticesBloc.toggleVisibility();
          },
        )
      ],
      backgroundColor: globalWhiteColor,
      title: appHeading,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          _listNoticesBloc.eventSink.add(ListNoticesEvent.pushProfileEvent);
        },
        child: Center(child: buildProfilePic()),
      ),
    );
  }

  AppBar buildNoFiltersAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
          size: 35.0,
        ),
      ),
      leadingWidth: 40.0,
      title: Text(widget.listNoticeMetaData.appBarLabel,
          style: TextStyle(
              color: globalBlueColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700)),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  StreamBuilder<bool> buildAdvanceNoticesBox(double height, double width) {
    return StreamBuilder(
        stream: _listNoticesBloc.filterVisibilityStream,
        initialData: false,
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  flex: snapshot.data ? 1 : 0,
                  child: Visibility(
                      visible: snapshot.data,
                      maintainState: true,
                      child: Container(
                        height: height * 0.5,
                        child: Filters(
                          onApplyFilters: !widget.listNoticeMetaData.isSearch
                              ? (FilterResult filterResult) =>
                                  _listNoticesBloc.applyFilters(filterResult)
                              : (FilterResult filterResult) => _listNoticesBloc
                                  .applySearchFilters(filterResult),
                          onCancel: _listNoticesBloc.toggleVisibility,
                        ),
                      )),
                ),
                Expanded(
                  flex: !snapshot.data ? 1 : 0,
                  child: Visibility(
                    visible: !snapshot.data,
                    maintainState: true,
                    child: Container(
                        height: height * 0.5,
                        child: buildListNoticesBox(height, width)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Container buildListNoticesBox(double height, double width) {
    return Container(
      child: RefreshIndicator(
        onRefresh: refreshNotices,
        child: Stack(children: [
          ListView(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !widget.listNoticeMetaData.noFilters &&
                      !widget.listNoticeMetaData.isSearch
                  ? StreamBuilder(
                      initialData: widget.listNoticeMetaData.appBarLabel,
                      stream: _listNoticesBloc.appBarLabelStream,
                      builder: (context, snapshot) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 19.0, right: 19.0, top: 15.0, bottom: 15.0),
                          child: Text(
                            snapshot.data,
                            style: appLabelTxtStyle,
                          ),
                        );
                      })
                  : Container(),
              !widget.listNoticeMetaData.noFilters &&
                      !widget.listNoticeMetaData.isSearch
                  ? StreamBuilder(
                      stream: _listNoticesBloc.unreadCountStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == '0') return Container();
                          return GestureDetector(
                            onTap: _listNoticesBloc.pushImportantNotices,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 19.0),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      impNoticesHeading,
                                      Container(
                                          padding: EdgeInsets.all(5.0),
                                          color: noticeCardColor,
                                          child: Text(snapshot.data + ' Unread',
                                              style: unreadTxtStyle))
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    width: width * 0.95,
                                    color: noticeInroGapContainerColor,
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      })
                  : Container(),
              Expanded(
                child: Container(
                  width: width,
                  child: StreamBuilder(
                    stream: _listNoticesBloc.listNoticesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.list.length == 0)
                          return buildNoResults();
                        return buildNoticesList(snapshot, width, height);
                      } else if (snapshot.hasError) {
                        return buildErrorWidget(snapshot);
                      }
                      if (widget.listNoticeMetaData.isSearch &&
                          _listNoticesBloc.searchQuery == '')
                        return Container();
                      return buildShimmerList(context, 3); //buildLoading();
                    },
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  FutureBuilder buildProfilePic() {
    return FutureBuilder(
        future: _authRepository.fetchProfileFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.picUrl != "") {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 6.0, bottom: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.fill,
                        placeholder: 'assets/images/user1.jpg',
                        image: snapshot.data.picUrl),
                  ),
                ),
              );
            } else {
              return buildNoPic();
            }
          } else if (snapshot.hasError) {
            return buildNoPic();
          }
          return buildNoPic();
        });
  }

  Container buildNoticesList(
      AsyncSnapshot snapshot, double width, double height) {
    return Container(
      width: width,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: ListView.builder(
            itemCount: snapshot.data.hasMore
                ? snapshot.data.list.length + 1
                : snapshot.data.list.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                NoticeIntro noticeIntroObj = snapshot.data.list[0];
                return buildListItem(noticeIntroObj, width, height, true);
              }
              if (index == snapshot.data.list.length) {
                return buildShimmerList(context, 1);
              }
              NoticeIntro noticeIntroObj = snapshot.data.list[index];
              return buildListItem(noticeIntroObj, width, height, false);
            }),
      ),
    );
  }

  FocusedMenuHolder buildListItem(
      NoticeIntro noticeIntroObj, double width, double height, bool isTop) {
    return FocusedMenuHolder(
      onPressed: () {
        pushNoticeDetail(noticeIntroObj);
      },
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: contextMenuDecoration,
      duration: Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      menuOffset: 10.0,
      bottomOffsetHeight: 80.0,
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
      child: buildNoticeIntroContainer(noticeIntroObj, width, isTop),
    );
  }

  Container buildNoticeIntroContainer(
      NoticeIntro noticeIntroObj, double width, bool isTop) {
    return Container(
      color: !noticeIntroObj.read ? globalWhiteColor : noticeReadColor,
      width: width,
      child: Padding(
        padding: !isTop
            ? EdgeInsets.only(left: 19.0, right: 19.0, top: 16.0)
            : EdgeInsets.only(left: 19.0, right: 19.0, top: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                noticeIntroObj.starred
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Icon(
                                          Icons.double_arrow,
                                          color: noticeCardColor,
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Container(
                                    width: width,
                                    child: Text(noticeIntroObj.department,
                                        overflow: TextOverflow.ellipsis,
                                        style: departmentTxtStyle),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: width,
                              child: Text(noticeIntroObj.dateCreated,
                                  style: dateTxtStyle,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                              onTap: () {
                                _listNoticesBloc.toggleBookMarkSink
                                    .add(noticeIntroObj);
                              },
                              child:
                                  bookMarkIconDecider(noticeIntroObj.starred)))
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      width: width,
                      child: Text(noticeIntroObj.title,
                          style: noticeTitleTxtStyle,
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis)),
                  SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      width: width * 0.95,
                      color: noticeInroGapContainerColor,
                      height: 0.3,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
