import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

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
  final DateFormat dateFormatter = DateFormat('yyyy/MM/dd E, hh:mm aaa');

  ExpenseView(this.expenses, this.shouldRedirect, this.onDelete, this.onEdit,
      {super.key});

  String _getDateOnly(String fullDateFormat) {
    return dateFormatter.format(DateTime.parse(fullDateFormat)).split(",")[0];
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Expense, String>(
      elements: expenses,
      shrinkWrap: true,
      groupBy: (element) {
        return _getDateOnly(element.paidDate);
      },
      groupSeparatorBuilder: (String groupByValue) {
        var totalGroupExpense = expenses
            .where((element) => _getDateOnly(element.paidDate) == groupByValue)
            .map((e) => e.amount)
            .reduce((value, element) => value + element);

        var separatorStyle = TextStyle(
            color: Theme.of(context).primaryColor,
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
                        const EdgeInsets.only(left: 170, bottom: 2, top: 2),
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
