import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select Filter'),
      ),
      body: Container(
          width: _width,
          height: _height * 0.9,
          child: buildFilters(_width, _height)
          //StreamBuilder(
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //     } else if (snapshot.hasError) {
          //       return buildErrorFetchingFilters();
          //     }
          //     return buildLoadingFilters();
          //   },
          // ),
          ),
    );
  }

  Column buildFilters(double width, double height) {
    return Column(
      children: [buildFilterList(width), buildButtons()],
    );
  }

  Expanded buildFilterList(double width) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Categories'), Text('Reset')],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 40.0,
                      thickness: 1.0,
                    ),
                  ),
                  Container(
                    width: width,
                    color: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Text('Authorities'),
                  ),
                  Container(
                    width: width,
                    color: Colors.blue[50],
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Text('Bhawans'),
                  ),
                  Container(
                    width: width,
                    color: Colors.blue[50],
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Text('Centres'),
                  ),
                  Container(
                    width: width,
                    color: Colors.blue[50],
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Text('Departments'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 30.0,
                      thickness: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Date'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(
                  top: 30.0, bottom: 5.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Categories'),
                  Divider(
                    color: Colors.black,
                    height: 40.0,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.amberAccent,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildButtons() {
    return Container(
      height: 50.0,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border(top: BorderSide(color: Colors.black, width: 1)),
              ),
              child: Center(
                child: Text('Cancel'),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue[700],
              child: Center(
                child: Text('Apply'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Center buildErrorFetchingFilters() {
    return Center(
      child: Text('Error fetching filters'),
    );
  }

  Center buildLoadingFilters() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
