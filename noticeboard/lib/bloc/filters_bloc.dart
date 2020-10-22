import 'dart:async';
import 'package:noticeboard/enum/filter_enum.dart';
import '../repository/filters_repository.dart';
import '../models/filters_list.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class FiltersBloc {
  BuildContext context;
  List<Category> categories;
  Category category;
  DateTimeRange dateTimeRange;
  GlobalSelection globalSelection;

  final _categoryIndexController = StreamController<int>.broadcast();
  StreamSink<int> get indexSink => _categoryIndexController.sink;
  Stream<int> get indexStream => _categoryIndexController.stream;

  final _eventController = StreamController<FilterEvents>();
  StreamSink<FilterEvents> get eventSink => _eventController.sink;
  Stream<FilterEvents> get _eventStream => _eventController.stream;

  final _categoryController = StreamController<Category>();
  StreamSink<Category> get _categorySink => _categoryController.sink;
  Stream<Category> get categoryStream => _categoryController.stream;

  final _dateRangeController = StreamController<DateTimeRange>();
  StreamSink<DateTimeRange> get _dateRangeSink => _dateRangeController.sink;
  Stream<DateTimeRange> get dateRangeStream => _dateRangeController.stream;

  final _globalSelectionController =
      StreamController<GlobalSelection>.broadcast();
  StreamSink<GlobalSelection> get globalSelectionSink =>
      _globalSelectionController.sink;
  Stream<GlobalSelection> get globalSelectionStream =>
      _globalSelectionController.stream;

  final _selectedCatController = StreamController<int>.broadcast();
  StreamSink<int> get _selectedCatSink => _selectedCatController.sink;
  Stream<int> get selectedCatStream => _selectedCatController.stream;

  FiltersRepository _filtersRepository = FiltersRepository();

  void disposeStreams() {
    _categoryIndexController.close();
    _eventController.close();
    _categoryController.close();
    _categoryController.close();
    _dateRangeController.close();
    _globalSelectionController.close();
    _selectedCatController.close();
  }

  FiltersBloc() {
    indexStream.listen((index) {
      indexHandler(index);
    });

    _eventStream.listen((event) {
      if (event == FilterEvents.fetchFilters)
        fetchFilters();
      else if (event == FilterEvents.pickDateRange)
        pickDateRange();
      else if (event == FilterEvents.resetDateRange)
        resetDateRange();
      else if (event == FilterEvents.resetGlobalSlug) resetGlobalSlug();
    });

    globalSelectionStream.listen((selection) {
      globalSlugHandler(selection);
    });
  }

  void fetchFilters() async {
    try {
      categories = await _filtersRepository.fetchAllFilters();
      category = categories[0];
      _categorySink.add(category);
    } catch (e) {
      _categorySink.addError(e.message);
    }
  }

  void globalSlugHandler(GlobalSelection selection) {
    globalSelection = selection;
    if (globalSelection != null) {
      if (globalSelection.globalDisplayName == 'Authorities') {
        _selectedCatSink.add(0);
      } else if (globalSelection.globalDisplayName == 'Bhawans') {
        _selectedCatSink.add(1);
      } else if (globalSelection.globalDisplayName == 'Centres') {
        _selectedCatSink.add(2);
      } else if (globalSelection.globalDisplayName == 'Departments') {
        _selectedCatSink.add(3);
      }
    }
  }

  void indexHandler(int x) {
    switch (x) {
      case 0:
        category = categories[0];
        _categorySink.add(category);
        break;
      case 1:
        category = categories[1];
        _categorySink.add(category);
        break;
      case 2:
        category = categories[2];
        _categorySink.add(category);
        break;
      case 3:
        category = categories[3];
        _categorySink.add(category);
        break;
      default:
    }
  }

  void pickDateRange() async {
    DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: DateTimeRange(
        start: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 13),
        end: DateTime.now(),
      ),
    );
    dateTimeRange = picked;
    _dateRangeSink.add(dateTimeRange);
  }

  void resetGlobalSlug() {
    globalSelectionSink.add(null);
    _selectedCatSink.add(null);
  }

  void resetDateRange() {
    dateTimeRange = null;
    _dateRangeSink.add(dateTimeRange);
  }

  FilterResult applyFilter() {
    if (globalSelection == null && dateTimeRange == null) {
      return null;
    } else if (globalSelection == null) {
      String start = formatDate(dateTimeRange.start, [yyyy, '-', mm, '-', dd]);
      String end = formatDate(dateTimeRange.end, [yyyy, '-', mm, '-', dd]);
      String dateFilterEndpoint =
          'api/noticeboard/date_filter_view/?start=$start&end=$end';
      FilterResult filterResult = FilterResult(endpoint: dateFilterEndpoint);
      return filterResult;
    } else if (dateTimeRange == null) {
      FilterResult filterResult = FilterResult(
          endpoint: globalSelection.globalSlug, label: globalSelection.display);
      return filterResult;
    } else {
      String start = formatDate(dateTimeRange.start, [yyyy, '-', mm, '-', dd]);
      String end = formatDate(dateTimeRange.end, [yyyy, '-', mm, '-', dd]);
      String endPoint =
          'api/noticeboard/date_filter_view/?start=$start&end=$end&${globalSelection.globalSlug.substring(24)}';
      FilterResult filterResult =
          FilterResult(label: globalSelection.display, endpoint: endPoint);
      return filterResult;
    }
  }
}
