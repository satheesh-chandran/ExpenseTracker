import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../Expense.dart';
import 'ExpenseItem.dart';

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
