import 'package:flutter/material.dart';
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
    _instituteNoticesBloc.eventSink
        .add(InstituteNoticesEvent.fetchInstituteNotices);
    super.initState();
  }

  @override
  void dispose() {
    _instituteNoticesBloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _instituteNoticesBloc.eventSink
              .add(InstituteNoticesEvent.fetchInstituteNotices);
        },
      ),
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
      body: StreamBuilder(
        stream: _instituteNoticesBloc.instiNoticesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data.length.toString()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
