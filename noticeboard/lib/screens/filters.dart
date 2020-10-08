import 'package:flutter/material.dart';
import 'package:noticeboard/enum/filter_enum.dart';
import 'package:noticeboard/models/filters_list.dart';
import '../bloc/filters_bloc.dart';
import 'package:date_format/date_format.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final FiltersBloc _filtersBloc = FiltersBloc();

  @override
  void initState() {
    _filtersBloc.context = context;
    _filtersBloc.eventSink.add(FilterEvents.fetchFilters);
    super.initState();
  }

  @override
  void dispose() {
    _filtersBloc.disposeStreams();
    super.dispose();
  }

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
        child: StreamBuilder(
          stream: _filtersBloc.categoryStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Category category = snapshot.data;
              return buildFilters(_width, _height, category);
            } else if (snapshot.hasError) {
              return buildErrorFetchingFilters(snapshot);
            }
            return buildLoadingFilters();
          },
        ),
      ),
    );
  }

  Column buildFilters(double width, double height, Category category) {
    return Column(
      children: [buildFilterList(width, category), buildButtons()],
    );
  }

  Expanded buildFilterList(double width, Category category) {
    return Expanded(
      child: Row(
        children: [buildCategoryList(width), buildCategory(category)],
      ),
    );
  }

  Expanded buildCategory(Category category) {
    return Expanded(
      flex: 5,
      child: StreamBuilder(
          stream: _filtersBloc.globalSelectionStream,
          builder: (context, globalSelectionStream) {
            return Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 5.0, left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: category.mainSlug,
                        groupValue: globalSelectionStream.data == null
                            ? null
                            : globalSelectionStream.data.globalSlug,
                        onChanged: (value) {
                          GlobalSelection selection = GlobalSelection(
                              globalDisplayName: category.mainDisplay,
                              globalSlug: value,
                              display: category.mainDisplay);
                          _filtersBloc.globalSelectionSink.add(selection);
                        },
                        activeColor: Colors.blue,
                      ),
                      Expanded(
                        child: Text(
                          'All ' + category.mainDisplay,
                          style: TextStyle(fontSize: 13.0),
                          overflow: TextOverflow.clip,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    height: 15.0,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.separated(
                          itemBuilder: (context, index) => Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: category.bannerList[index].slug,
                                    groupValue: globalSelectionStream.data ==
                                            null
                                        ? null
                                        : globalSelectionStream.data.globalSlug,
                                    onChanged: (value) {
                                      GlobalSelection selection =
                                          GlobalSelection(
                                              globalDisplayName: category
                                                  .bannerList[index]
                                                  .mainDisplay,
                                              globalSlug: value,
                                              display: category
                                                  .bannerList[index].display);
                                      _filtersBloc.globalSelectionSink
                                          .add(selection);
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  Expanded(
                                    child: Text(
                                      category.bannerList[index].display,
                                      style: TextStyle(fontSize: 13.0),
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                          separatorBuilder: (context, index) => Divider(
                                height: 7.0,
                                color: Colors.black,
                              ),
                          itemCount: category.bannerList.length),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Expanded buildCategoryList(double width) {
    return Expanded(
      flex: 4,
      child: Container(
        color: Colors.blue[50],
        child: StreamBuilder(
            initialData: 0,
            stream: _filtersBloc.indexStream,
            builder: (context, categoryIndexStream) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 23.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Categories'),
                        GestureDetector(
                          onTap: () {
                            _filtersBloc.eventSink
                                .add(FilterEvents.resetGlobalSlug);
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        )
                      ],
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
                  buildCategoryItem(
                      width: width,
                      index: 0,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Authorities'),
                  buildCategoryItem(
                      width: width,
                      index: 1,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Bhawans'),
                  buildCategoryItem(
                      width: width,
                      index: 2,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Centres'),
                  buildCategoryItem(
                      width: width,
                      index: 3,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Departments'),
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
                    child: StreamBuilder(
                        stream: _filtersBloc.dateRangeStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return GestureDetector(
                              onTap: () {
                                _filtersBloc.eventSink
                                    .add(FilterEvents.pickDateRange);
                              },
                              child: Text(
                                'Date',
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            String start = formatDate(
                                snapshot.data.start, [yyyy, '-', mm, '-', dd]);
                            String end = formatDate(
                                snapshot.data.end, [yyyy, '-', mm, '-', dd]);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  start,
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                                Text('|',
                                    style: TextStyle(color: Colors.blue[900])),
                                Text(end,
                                    style: TextStyle(color: Colors.blue[900])),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _filtersBloc.eventSink
                                          .add(FilterEvents.resetDateRange);
                                    },
                                    child: Text('Reset Date filter',
                                        style:
                                            TextStyle(color: Colors.grey[500])))
                              ],
                            );
                          }
                        }),
                  )
                ],
              );
            }),
      ),
    );
  }

  GestureDetector buildCategoryItem(
      {double width, int index, int selectedIndex, String categoryName}) {
    return GestureDetector(
        onTap: () {
          _filtersBloc.indexSink.add(index);
        },
        child: Container(
          width: width,
          color: selectedIndex == index ? Colors.white : Colors.blue[50],
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: StreamBuilder<Object>(
              stream: _filtersBloc.selectedCatStream,
              builder: (context, snapshot) {
                if (snapshot.data == index) {
                  return Row(
                    children: [
                      Text(categoryName),
                      SizedBox(
                        width: 10.0,
                      ),
                      CircleAvatar(
                        radius: 5.0,
                        backgroundColor: Colors.blue[500],
                      )
                    ],
                  );
                }
                return Text(categoryName);
              }),
        ));
  }

  Container buildButtons() {
    return Container(
      height: 50.0,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                _filtersBloc.eventSink.add(FilterEvents.cancelFilter);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border:
                      Border(top: BorderSide(color: Colors.black, width: 0.5)),
                ),
                child: Center(
                  child: Text('Cancel',
                      style:
                          TextStyle(color: Colors.blue[700], fontSize: 17.0)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                _filtersBloc.eventSink.add(FilterEvents.applyFilter);
              },
              child: Container(
                color: Colors.blue[700],
                child: Center(
                  child: Text(
                    'Apply',
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Center buildErrorFetchingFilters(AsyncSnapshot snapshot) {
    return Center(
      child: Text(snapshot.error),
    );
  }

  Center buildLoadingFilters() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
