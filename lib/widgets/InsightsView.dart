import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../CategorisedExpenseViewPage.dart';
import '../DataRepository.dart';
import '../models/CallBacks.dart';
import '../models/Expense.dart';
import '../models/ExpenseCategory.dart';
import 'ExpenseCategoryBar.dart';
import 'ExpenseView.dart';

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

  Widget _createBarChartIndicator(
      BuildContext context, ChartData data, int grandTotal) {
    return Container(
      decoration: getBoxDecorationWithShadow(),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(bottom: 5, top: 5, left: 15, right: 15),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return CategorisedExpenseView(
                    repository, data.category, onDelete, onEdit);
              }),
            );
          },
          child: ListTile(
            leading:
                ExpenseCategoryBar(data.category.icon, data.category.color),
            trailing: Column(
              children: [
                Text('${((data.total / grandTotal) * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                Text('${data.total}',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor))
              ],
            ),
            subtitle: Text(
              data.category.qualifiedName,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
            title: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  value: data.total / grandTotal,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(data.category.color),
                )),
          )),
    );
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
    var progressIndicators = chartData
        .map((data) => _createBarChartIndicator(context, data, grandTotal));
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
