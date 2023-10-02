import 'package:expense_tracker/models/FilterCategory.dart';
import 'package:expense_tracker/widgets/ExpenseCategoryBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../DataRepository.dart';
import '../models/CallBacks.dart';
import '../models/Expense.dart';
import '../models/ExpenseCategory.dart';
import 'ChartIndicatorTile.dart';

class CircularChartData {
  ExpenseCategory category;
  int total;

  CircularChartData(this.category, this.total);
}

class InsightsView extends StatefulWidget {
  final DataRepository repository;
  final DeleteCallback onDelete;
  final EditCallback onEdit;

  const InsightsView(this.repository, this.onDelete, this.onEdit, {super.key});

  @override
  State<StatefulWidget> createState() {
    return InsightsViewState(repository, onDelete, onEdit);
  }
}

class InsightsViewState extends State<InsightsView> {
  final DataRepository repository;
  final DeleteCallback onDelete;
  final EditCallback onEdit;

  late List<Expense> expenses = [];
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();
  late FilterCategory categoryFilter = FilterCategory.lastMonth;

  InsightsViewState(this.repository, this.onDelete, this.onEdit);

  List<CircularChartData> _prepareCircularChartData() {
    Map<ExpenseCategory, int> map = <ExpenseCategory, int>{};
    for (var element in expenses) {
      map.putIfAbsent(element.category, () => 0);
      map[element.category] = (map[element.category]! + element.amount.round());
    }
    var list =
        map.entries.map((el) => CircularChartData(el.key, el.value)).toList();
    list.sort((a, b) => a.total - b.total);
    return list.reversed.toList();
  }

  TextStyle _buildTextStyle(double fontSize) {
    return TextStyle(
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontSize: fontSize,
        color: Theme.of(context).primaryColor);
  }

  List<CircularChartAnnotation> _getChartAnnotations(int total) {
    return <CircularChartAnnotation>[
      CircularChartAnnotation(
          widget: const PhysicalModel(
              shape: BoxShape.circle,
              elevation: 10.0,
              shadowColor: Colors.black,
              color: Color.fromRGBO(250, 208, 208, 1.0),
              child: SizedBox(
                height: 120,
                width: 120,
              ))),
      CircularChartAnnotation(
          widget: Text('- $total', style: _buildTextStyle(16)))
    ];
  }

  void _initialiseState() async {
    var expensesList = await repository.getAllExpenses();
    var start = await repository.startDate;
    var end = await repository.endDate;
    var filterCategory = await repository.filterCategory;
    if (mounted) {
      setState(() {
        expenses = expensesList;
        startDate = start;
        endDate = end;
        categoryFilter = filterCategory;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initialiseState();
  }

  void _showDatePickerDialog(DateTime initialDate, DateSetter setter) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2010),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setter(pickedDate);
    }
    _initialiseState();
  }

  ElevatedButton _datePickerButton(String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(label, style: _buildTextStyle(14)),
      icon: const Icon(Icons.calendar_month),
    );
  }

  List<Widget> _setStartAndEndDate(DateTime start, DateTime end) {
    repository.setStartDate(start);
    repository.setEndDate(end);
    _initialiseState();
    return [];
  }

  List<Widget> _buildDatePickerButtonRow() {
    Jiffy now = Jiffy.now();
    switch (categoryFilter) {
      case FilterCategory.dateRange:
        return [
          _datePickerButton("From", () {
            _showDatePickerDialog(startDate, repository.setStartDate);
          }),
          const SizedBox(width: 20),
          _datePickerButton("To", () {
            _showDatePickerDialog(endDate, repository.setEndDate);
          }),
        ];
      case FilterCategory.since:
        repository.setEndDate(now.dateTime);
        _initialiseState();
        return [
          _datePickerButton("From", () {
            _showDatePickerDialog(startDate, repository.setStartDate);
          })
        ];
      case FilterCategory.thisMonth:
        return _setStartAndEndDate(
            DateTime(now.year, now.month, 1), now.dateTime);
      case FilterCategory.lastWeek:
        return _setStartAndEndDate(
            now.subtract(days: 7).dateTime, now.dateTime);
      case FilterCategory.lastMonth:
        return _setStartAndEndDate(
            now.subtract(months: 1).dateTime, now.dateTime);
      case FilterCategory.lastThreeMonths:
        return _setStartAndEndDate(
            now.subtract(months: 3).dateTime, now.dateTime);
      case FilterCategory.lastSixMonths:
        return _setStartAndEndDate(
            now.subtract(months: 6).dateTime, now.dateTime);
      default:
        return _setStartAndEndDate(startDate, now.dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('dd/MM/yyyy');
    List<CircularChartData> chartData = _prepareCircularChartData();
    var totalsList = chartData.map((e) => e.total);
    var grandTotal = totalsList.isNotEmpty
        ? totalsList.reduce((value, element) => value + element)
        : 0;
    var progressIndicators = chartData.map((data) =>
        ChartIndicatorTile(data, repository, onEdit, onDelete, grandTotal));
    var textStyle = _buildTextStyle(14);
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          child: ListTile(
            subtitle: categoryFilter == FilterCategory.all
                ? null
                : Text(
                    "${formatter.format(startDate)}  -  ${formatter.format(endDate)}",
                    style: textStyle,
                  ),
            title: DropdownButton(
                style: textStyle,
                value: categoryFilter,
                alignment: AlignmentDirectional.center,
                isExpanded: true,
                items: _buildCategoryDropdownList(),
                onChanged: (newCategory) {
                  repository.setFilterCategory(newCategory!);
                  _initialiseState();
                }),
            trailing: ExpenseCategoryBar(
                const Icon(Icons.file_download, color: Colors.white),
                Theme.of(context).primaryColor),
          )),
      Padding(
          padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Row(children: _buildDatePickerButtonRow())),
      SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<CircularChartData, String>(
              animationDuration: 1000,
              dataSource: chartData,
              pointColorMapper: (CircularChartData data, _) =>
                  data.category.color,
              xValueMapper: (CircularChartData data, _) => data.category.name,
              yValueMapper: (CircularChartData data, _) => data.total,
              radius: '90%',
              innerRadius: '60%'),
        ],
        annotations: _getChartAnnotations(grandTotal),
      ),
      ...progressIndicators
    ]));
  }

  List<DropdownMenuItem<FilterCategory>> _buildCategoryDropdownList() {
    return FilterCategory.values
        .map((FilterCategory value) => DropdownMenuItem<FilterCategory>(
              value: value,
              child: Text(value.qualifiedName),
            ))
        .toList();
  }
}
