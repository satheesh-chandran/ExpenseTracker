import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:flutter/material.dart';

import '../Expense.dart';
import 'ExpenseCategoryBar.dart';

class ExpenseItem extends StatelessWidget {
  final RawExpenseModel expense;

  const ExpenseItem(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    var categoryStyle = TextStyle(
        color: Colors.grey.shade800,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500);
    var category = expense.category;
    return Container(
        decoration: getBoxDecorationWithShadow(),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Text(expense.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black)),
          subtitle: Text(category.qualifiedName, style: categoryStyle),
          leading: ExpenseCategoryBar(category.icon, category.color),
          trailing: Text(expense.amount.round().toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18)),
        ));
  }
}
