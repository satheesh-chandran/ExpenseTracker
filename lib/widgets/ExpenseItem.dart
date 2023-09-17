import 'package:flutter/material.dart';

import '../Expense.dart';
import 'ExpenseCategoryBar.dart';

class ExpenseItem extends StatelessWidget {
  late RawExpenseModel expense;

  ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    var categoryStyle = TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500);
    var category = expense.category;
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(expense.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black)),
          subtitle: Text(category.name.toUpperCase(), style: categoryStyle),
          leading:
              ExpenseCategoryBar(category.icon, category.color),
          trailing: Text(expense.amount.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade800,
                  fontSize: 18)),
        ));
  }
}
