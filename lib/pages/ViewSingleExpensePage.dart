import 'package:expense_tracker/widgets/ExpenseCategoryBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Constants.dart';
import '../models/CallBacks.dart';
import '../models/EditExpenseModel.dart';
import '../models/Expense.dart';
import '../models/ExpenseCategory.dart';
import '../models/Favourite.dart';
import '../models/NewExpense.dart';
import 'AddExpensePage.dart';

abstract class ViewSinglePage extends StatelessWidget {
  final int id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final String? paidDate;

  final DeleteCallback onDelete;
  final EditCallback onEdit;
  final NewExpenseCallback? onAddFromFavourite;
  final bool shouldRedirect;

  const ViewSinglePage(this.id, this.title, this.amount, this.category,
      {super.key,
      required this.onDelete,
      required this.onEdit,
      required this.shouldRedirect,
      this.onAddFromFavourite,
      this.paidDate});

  void _toEditPage(BuildContext context);

  void _performEdit(BuildContext context, WidgetBuilder builder) async {
    Navigator.pop(context);
    NewExpense newExpense =
        await Navigator.push(context, MaterialPageRoute(builder: builder));
    if (newExpense != null) {
      var editExpenseModel = EditExpenseModel(
          id, newExpense.title, newExpense.amount, newExpense.category);
      onEdit(editExpenseModel);
    }
  }

  List<Widget> _getDateTile(BuildContext context, TextStyle textStyle) {
    if (paidDate == null) {
      return [];
    }

    return [
      const ContainerSizeBox(),
      ListTile(
        leading: ExpenseCategoryBar(
            const Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            Theme.of(context).primaryColor),
        title: Text(DateFormat(DATE_FORMAT).format(DateTime.parse(paidDate!)),
            style: textStyle),
      ),
    ];
  }

  List<Widget> _getFavouriteOnlyOptions(BuildContext context) {
    if (paidDate == null) {
      return [
        const ContainerSizeBox(),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onAddFromFavourite!(NewExpense(title, amount.round(), category));
            },
            icon: const Icon(Icons.add),
            label: const Text("ADD TO EXPENSE"))
      ];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontStyle: FontStyle.italic);
    return SizedBox(
      height: 390,
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic)),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(
                const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                Theme.of(context).primaryColor),
            title: Text(amount.round().toString(), style: textStyle),
          ),
          ..._getDateTile(context, textStyle),
          const ContainerSizeBox(),
          ListTile(
            leading: ExpenseCategoryBar(category.icon, category.color),
            title: Text(category.qualifiedName, style: textStyle),
          ),
          ..._getFavouriteOnlyOptions(context),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {
                _toEditPage(context);
              },
              icon: const Icon(Icons.edit),
              label:
                  Text(paidDate != null ? "EDIT EXPENSE" : "EDIT FAVOURITE")),
          const ContainerSizeBox(),
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDelete(id, shouldRedirect);
              },
              icon: const Icon(Icons.delete),
              label: const Text("DELETE"))
        ],
      ),
    );
  }
}

class ViewSingleExpensePage extends ViewSinglePage {
  final Expense expense;

  ViewSingleExpensePage(this.expense, bool shouldRedirect,
      DeleteCallback onDelete, EditCallback onEdit, {super.key})
      : super(expense.id, expense.title, expense.amount, expense.category,
            onDelete: onDelete,
            onEdit: onEdit,
            shouldRedirect: shouldRedirect,
            paidDate: expense.paidDate);

  @override
  void _toEditPage(BuildContext context) {
    _performEdit(context, (_) => EditExpensePage(expense));
  }
}

class ViewSingleFavouritePage extends ViewSinglePage {
  final Favourite expense;

  ViewSingleFavouritePage(
      this.expense,
      bool shouldRedirect,
      DeleteCallback onDelete,
      EditCallback onEdit,
      NewExpenseCallback onAddFromFavourite,
      {super.key})
      : super(
          expense.id,
          expense.title,
          expense.amount,
          expense.category,
          onDelete: onDelete,
          onEdit: onEdit,
          onAddFromFavourite: onAddFromFavourite,
          shouldRedirect: shouldRedirect,
        );

  @override
  void _toEditPage(BuildContext context) {
    _performEdit(context, (_) => EditFavouritePage(expense));
  }
}
