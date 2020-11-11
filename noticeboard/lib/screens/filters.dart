import 'package:flutter/material.dart';
import 'package:noticeboard/enum/filter_enum.dart';
import 'package:noticeboard/models/filters_list.dart';
import '../bloc/filters_bloc.dart';
import 'package:date_format/date_format.dart';
import '../styles/filter_consts.dart';
import '../global/global_functions.dart';

class Filters extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(FilterResult) onApplyFilters;
  Filters({@required this.onCancel, @required this.onApplyFilters});
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
    return Container(
      child: Column(children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.clear),
                color: Colors.black,
                onPressed: widget.onCancel,
              ),
              Expanded(
                child: selectFiltersHeading,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                      onTap: () {
                        _filtersBloc.eventSink
                            .add(FilterEvents.resetGlobalSlug);
                      },
                      child: clearAllHeading))
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: _width,
            child: StreamBuilder(
              stream: _filtersBloc.categoryStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Category category = snapshot.data;
                  return buildFilters(_width, _height, category);
                } else if (snapshot.hasError) {
                  return buildErrorWidget(snapshot);
                }
                return buildLoadingFilters();
              },
            ),
          ),
        ),
      ]),
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
              color: globalWhiteColor,
              padding: EdgeInsets.only(top: 6.0, bottom: 5.0, right: 5.0),
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
                        activeColor: globalBlueColor,
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
                  mainFilterDivider,
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
                                    activeColor: globalBlueColor,
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
                          separatorBuilder: (context, index) => filterDivider,
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
        color: globalLightBlueColor,
        child: StreamBuilder(
            initialData: 0,
            stream: _filtersBloc.indexStream,
            builder: (context, categoryIndexStream) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Categories'),
                      ],
                    ),
                  ),
                  categoryDivider,
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
                      categoryName: 'Campus Groups'),
                  buildCategoryItem(
                      width: width,
                      index: 3,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Centres'),
                  buildCategoryItem(
                      width: width,
                      index: 4,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Departments'),
                  categoryDivider,
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _filtersBloc.pushImportantNotices,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 15.0),
                        child: Text('Important')),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _filtersBloc.pushExpiredNotices,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 15.0),
                        child: Text('Expired')),
                  ),
                  categoryDivider,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: StreamBuilder(
                        stream: _filtersBloc.dateRangeStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return GestureDetector(
                              onTap: () {
                                _filtersBloc.eventSink
                                    .add(FilterEvents.pickDateRange);
                              },
                              child: dateHeading,
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
                                  style: dateTxtStyle,
                                ),
                                Text('|', style: dateTxtStyle),
                                Text(end, style: dateTxtStyle),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _filtersBloc.eventSink
                                          .add(FilterEvents.resetDateRange);
                                    },
                                    child: resetDate)
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
          color:
              selectedIndex == index ? globalWhiteColor : globalLightBlueColor,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
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
                      selectedCategoryIndicator
                    ],
                  );
                }
                return Text(categoryName);
              }),
        ));
  }

  Container buildButtons() {
    return Container(
      height: 48.0,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onApplyFilters(_filtersBloc.applyFilter()),
              child: buildApplyContainer(),
            ),
          )
        ],
      ),
    );
  }
}
