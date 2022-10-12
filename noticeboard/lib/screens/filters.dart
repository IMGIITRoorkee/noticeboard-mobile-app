import 'package:flutter/material.dart';
import 'package:noticeboard/enum/filter_enum.dart';
import 'package:noticeboard/models/filters_list.dart';
import '../bloc/filters_bloc.dart';
import 'package:date_format/date_format.dart';
import '../styles/filter_consts.dart';
import '../global/global_functions.dart';

class Filters extends StatefulWidget {
  final VoidCallback onCancel;
  final void Function(FilterResult?) onApplyFilters;
  Filters({required this.onCancel, required this.onApplyFilters});
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late FiltersBloc _filtersBloc = FiltersBloc();
  ValueNotifier<bool> isFilterSelected = ValueNotifier(false);

  @override
  void initState() {
    _filtersBloc.context = context;
    _filtersBloc.onFilterTap = onFilterSelect;
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
                    _filtersBloc.eventSink.add(FilterEvents.resetGlobalSlug);
                    WidgetsBinding.instance!.addPostFrameCallback((time) {
                      onFilterClear();
                    });
                  },
                  child: clearAllHeading,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: _width,
            child: StreamBuilder<Category?>(
              stream: _filtersBloc.categoryStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Category? category = snapshot.data;
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

  void onFilterSelect() {
    isFilterSelected.value = true;
  }

  void onFilterClear() {
    isFilterSelected.value = false;
  }

  Column buildFilters(double width, double height, Category? category) {
    return Column(
      children: [
        buildFilterList(width, category, height),
        buildButtons(),
      ],
    );
  }

  Expanded buildFilterList(double width, Category? category, double height) {
    return Expanded(
      child: Row(
        children: [buildCategoryList(width, height), buildCategory(category)],
      ),
    );
  }

  Expanded buildCategory(Category? category) {
    return Expanded(
      flex: 5,
      child: StreamBuilder<GlobalSelection?>(
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
                      value: category!.mainSlug,
                      groupValue: globalSelectionStream.data == null
                          ? null
                          : globalSelectionStream.data!.globalSlug,
                      onChanged: (dynamic value) {
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
                        'All ' + category.mainDisplay!,
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
                                  value: category.bannerList![index].slug,
                                  groupValue: globalSelectionStream.data == null
                                      ? null
                                      : globalSelectionStream.data!.globalSlug,
                                  onChanged: (dynamic value) {
                                    GlobalSelection selection = GlobalSelection(
                                        globalDisplayName: category
                                            .bannerList![index].mainDisplay,
                                        globalSlug: value,
                                        display: category
                                            .bannerList![index].display);
                                    _filtersBloc.globalSelectionSink
                                        .add(selection);
                                  },
                                  activeColor: globalBlueColor,
                                ),
                                Expanded(
                                  child: Text(
                                    category.bannerList![index].display!,
                                    style: TextStyle(fontSize: 13.0),
                                    overflow: TextOverflow.clip,
                                  ),
                                )
                              ],
                            ),
                        separatorBuilder: (context, index) => filterDivider,
                        itemCount: category.bannerList!.length),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded buildCategoryList(double width, double height) {
    return Expanded(
      flex: 4,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height * 0.8),
          child: Container(
            color: globalLightBlueColor,
            padding: const EdgeInsets.only(bottom: 10),
            child: StreamBuilder<int?>(
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
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    categoryDivider,
                    buildCategoryItem(
                      width: width,
                      index: 0,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Authorities',
                    ),
                    buildCategoryItem(
                      width: width,
                      index: 1,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Bhawans',
                    ),
                    buildCategoryItem(
                      width: width,
                      index: 2,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Campus Groups',
                    ),
                    buildCategoryItem(
                      width: width,
                      index: 3,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Centres',
                    ),
                    buildCategoryItem(
                      width: width,
                      index: 4,
                      selectedIndex: categoryIndexStream.data,
                      categoryName: 'Departments',
                    ),
                    categoryDivider,
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _filtersBloc.pushImportantNotices,
                      child: ListTile(
                        title: Text(
                          'Important',
                          style: TextStyle(fontSize: 13.5),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _filtersBloc.pushExpiredNotices,
                      child: ListTile(
                        title: Text(
                          'Expired',
                          style: TextStyle(fontSize: 13.5),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    categoryDivider,
                    StreamBuilder<DateTimeRange?>(
                      stream: _filtersBloc.dateRangeStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return GestureDetector(
                            onTap: () {
                              _filtersBloc.eventSink.add(
                                FilterEvents.pickDateRange,
                              );
                            },
                            child: ListTile(
                              title: dateHeading,
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            ),
                          );
                        } else {
                          String start = formatDate(
                              snapshot.data!.start, [yyyy, '-', mm, '-', dd]);
                          String end = formatDate(
                              snapshot.data!.end, [yyyy, '-', mm, '-', dd]);
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
                                  _filtersBloc.eventSink.add(
                                    FilterEvents.resetDateRange,
                                  );
                                },
                                child: resetDate,
                              )
                            ],
                          );
                        }
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buildCategoryItem(
      {double? width, int? index, int? selectedIndex, String? categoryName}) {
    return GestureDetector(
      onTap: () {
        _filtersBloc.indexSink.add(index);
      },
      child: Container(
        width: width,
        color: selectedIndex == index ? globalWhiteColor : globalLightBlueColor,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: StreamBuilder<Object?>(
          stream: _filtersBloc.selectedCatStream,
          builder: (context, snapshot) {
            if (snapshot.data == index) {
              return Row(
                children: [
                  Text(categoryName!),
                  SizedBox(
                    width: 10.0,
                  ),
                  selectedCategoryIndicator
                ],
              );
            }
            return Text(categoryName!);
          },
        ),
      ),
    );
  }

  GestureDetector buildButtons() {
    return GestureDetector(
      onTap: () => widget.onApplyFilters(_filtersBloc.applyFilter()),
      child: ValueListenableBuilder<bool>(
        valueListenable: isFilterSelected,
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            color: isFilterSelected.value ? globalBlue : Color(0xFFD5E1F4),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: isFilterSelected.value
                          ? Colors.white
                          : Color(0xFF797F89),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
// 797F89