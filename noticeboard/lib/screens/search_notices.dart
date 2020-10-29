import 'package:flutter/material.dart';
import '../bloc/search_bloc.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();
  SearchBloc searchBloc = SearchBloc();

  @override
  void initState() {
    searchBloc.context = context;
    super.initState();
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
      appBar: AppBar(
        title: Container(
          height: 50.0,
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: (text) {
              searchBloc.querySink.add(text);
            },
            decoration: new InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              suffixIcon: StreamBuilder<Object>(
                  stream: searchBloc.isSearchingStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (snapshot.data) {
                      return IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {},
                      );
                    }
                    return Container();
                  }),
              filled: true,
              fillColor: Colors.grey[300],
              hintText: 'Search all notices',
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        child: Text('Happy Searching'),
      ),
    );
  }
}
