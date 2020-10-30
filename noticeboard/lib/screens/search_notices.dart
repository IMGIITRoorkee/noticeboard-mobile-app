import 'package:flutter/material.dart';
import '../bloc/search_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller;
  SearchBloc searchBloc = SearchBloc();

  @override
  void initState() {
    _controller = TextEditingController();
    searchBloc.context = context;
    _controller.addListener(_handleQueryChanges);
    super.initState();
  }

  _handleQueryChanges() {
    searchBloc.querySink.add(_controller.text);
  }

  void clearSearch() {
    _controller.clear();
  }

  @override
  void dispose() {
    searchBloc.disposeStreams();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 5.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.name,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: StreamBuilder<Object>(
                          stream: searchBloc.isSearchingStream,
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
                GestureDetector(
                    child: Text(
                      'Close',
                      style:
                          TextStyle(fontSize: 14.0, color: HexColor('#5288da')),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Text('Happy Searching'),
        ),
      ),
    );
  }
}
