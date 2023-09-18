import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Expense.dart';
import 'ExpenseItem.dart';

class ChartData {
  ExpenseCategory category;
  int total;

  ChartData(this.category, this.total);
}

class InsightsView extends StatelessWidget {
  List<RawExpenseModel> expenses;

  InsightsView(this.expenses, {super.key});

  List<ChartData> _prepareChartData() {
    Map<ExpenseCategory, int> map = <ExpenseCategory, int>{};
    for (var element in expenses) {
      map.putIfAbsent(element.category, () => 0);
      map[element.category] = (map[element.category]! + element.amount.round());
    }
    return map.entries.map((el) => ChartData(el.key, el.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = _prepareChartData();
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height,
        width: size.width,
        child: Column(children: [
          SfCircularChart(series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.category.color,
                xValueMapper: (ChartData data, _) => data.category.name,
                yValueMapper: (ChartData data, _) => data.total)
          ])
        ]),
      ),
    );
  }
}

class ExpenseView extends StatelessWidget {
  List<RawExpenseModel> expenses;

  ExpenseView(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<RawExpenseModel, String>(
      elements: expenses,
      groupBy: (element) => element.paidDate.split(" ")[0],
      groupSeparatorBuilder: (String groupByValue) {
        var totalGroupExpense = expenses
            .where((element) => element.paidDate.split(" ")[0] == groupByValue)
            .map((e) => e.amount)
            .reduce((value, element) => value + element);

        var separatorStyle = TextStyle(
            color: Colors.grey.shade700,
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            fontWeight: FontWeight.w400);
        return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            color: Colors.pink.shade50,
            child: Row(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                    child: Text(groupByValue,
                        textAlign: TextAlign.left, style: separatorStyle)),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 160, bottom: 10, top: 10),
                    child: Text("Expense: $totalGroupExpense /-",
                        style: separatorStyle)),
              ],
            ));
      },
      itemBuilder: (context, RawExpenseModel element) => ExpenseItem(element),
      itemComparator: (item1, item2) =>
          item1.paidDate.compareTo(item2.paidDate),
      useStickyGroupSeparators: true,
      floatingHeader: true,
      order: GroupedListOrder.DESC,
    );
  }
}
