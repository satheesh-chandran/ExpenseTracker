import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../models/CallBacks.dart';
import '../models/Expense.dart';
import 'ExpenseItem.dart';

BoxDecoration getBoxDecorationWithShadow() {
  return const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Color(0xffDDDDDD),
        blurRadius: 6.0,
        spreadRadius: 2.0,
        offset: Offset(0.0, 0.0),
      )
    ],
  );
}

class ExpenseView extends StatelessWidget {
  final List<Expense> expenses;
  final bool shouldRedirect;
  final DeleteCallback onDelete;
  final EditCallback onEdit;

  const ExpenseView(
      this.expenses, this.shouldRedirect, this.onDelete, this.onEdit,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Expense, String>(
      elements: expenses,
      shrinkWrap: true,
      groupBy: (element) => element.paidDate.split(" ")[0],
      groupSeparatorBuilder: (String groupByValue) {
        var totalGroupExpense = expenses
            .where((element) => element.paidDate.split(" ")[0] == groupByValue)
            .map((e) => e.amount)
            .reduce((value, element) => value + element);

        var separatorStyle = TextStyle(
            color: Colors.green.shade800,
            overflow: TextOverflow.ellipsis,
            fontStyle: FontStyle.italic,
            fontSize: 12,
            fontWeight: FontWeight.w600);
        return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            color: Colors.pink.shade50,
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 2, top: 2),
                    child: Text(groupByValue,
                        textAlign: TextAlign.left, style: separatorStyle)),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 190, bottom: 2, top: 2),
                    child: Text("Expense: ${totalGroupExpense.round()} /-",
                        style: separatorStyle)),
              ],
            ));
      },
      itemBuilder: (context, Expense element) =>
          ExpenseItem(element, expenses.length <= 1, onDelete, onEdit),
      itemComparator: (item1, item2) =>
          item1.paidDate.compareTo(item2.paidDate),
      useStickyGroupSeparators: true,
      floatingHeader: true,
      order: GroupedListOrder.DESC,
    );
  }
}
