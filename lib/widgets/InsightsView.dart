import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../DataRepository.dart';
import '../models/CallBacks.dart';
import '../models/Expense.dart';
import '../models/ExpenseCategory.dart';
import 'ChartIndicatorTile.dart';

class ChartData {
  ExpenseCategory category;
  int total;

  ChartData(this.category, this.total);
}

class InsightsView extends StatelessWidget {
  final List<Expense> expenses;
  final DataRepository repository;
  final DeleteCallback onDelete;
  final EditCallback onEdit;

  const InsightsView(this.expenses, this.repository, this.onDelete, this.onEdit,
      {super.key});

  List<ChartData> _prepareChartData() {
    Map<ExpenseCategory, int> map = <ExpenseCategory, int>{};
    for (var element in expenses) {
      map.putIfAbsent(element.category, () => 0);
      map[element.category] = (map[element.category]! + element.amount.round());
    }
    var list = map.entries.map((el) => ChartData(el.key, el.value)).toList();
    list.sort((a, b) => a.total - b.total);
    return list.reversed.toList();
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
          widget: Text('- $total',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                  fontSize: 16)))
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = _prepareChartData();
    var totalsList = chartData.map((e) => e.total);
    var grandTotal = totalsList.isNotEmpty
        ? totalsList.reduce((value, element) => value + element)
        : 0;
    var progressIndicators = chartData.map((data) =>
        ChartIndicatorTile(data, repository, onEdit, onDelete, grandTotal));
    return Center(
      child: SingleChildScrollView(
          child: Column(children: [
        SfCircularChart(
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
                animationDuration: 1000,
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.category.color,
                xValueMapper: (ChartData data, _) => data.category.name,
                yValueMapper: (ChartData data, _) => data.total,
                radius: '90%',
                innerRadius: '60%'),
          ],
          annotations: _getChartAnnotations(grandTotal),
        ),
        ...progressIndicators
      ])),
    );
  }
}
