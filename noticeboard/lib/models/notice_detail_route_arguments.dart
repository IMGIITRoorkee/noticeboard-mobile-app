import 'package:noticeboard/bloc/list_notices_bloc.dart';
import 'package:noticeboard/models/notice_intro.dart';

class NoticeDetailArgument {
  NoticeIntro noticeIntro;
  List<NoticeIntro?>? listOfNotices;
  ListNoticesBloc listNoticesBloc;
  bool goingtoPrevNotice = false;

  NoticeDetailArgument(
      this.noticeIntro, this.listOfNotices, this.listNoticesBloc , this.goingtoPrevNotice);
}
