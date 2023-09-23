import 'package:flutter/material.dart';

import '../ViewSingleExpensePage.dart';
import '../models/CallBacks.dart';
import '../models/Favourite.dart';
import 'ExpenseCategoryBar.dart';
import 'ExpenseView.dart';

class FavouriteItem extends StatelessWidget {
  final Favourite favourite;
  final EditCallback onEdit;
  final DeleteCallback onDelete;
  final NewExpenseCallback onAddFromFavourite;

  const FavouriteItem(
      this.favourite, this.onEdit, this.onDelete, this.onAddFromFavourite,
      {super.key});

  Widget _showAlertDialog(BuildContext context) {
    return AlertDialog(
        content: ViewSingleFavouritePage(
            favourite, false, onDelete, onEdit, onAddFromFavourite));
  }

  @override
  Widget build(BuildContext context) {
    var categoryStyle = TextStyle(
        color: Colors.grey.shade800,
        fontSize: 12,
        overflow: TextOverflow.ellipsis,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500);
    var category = favourite.category;
    return Container(
        decoration: getBoxDecorationWithShadow(),
        margin: const EdgeInsets.all(5),
        child: GestureDetector(
            onTap: () {
              showDialog(context: context, builder: _showAlertDialog);
            },
            child: ListTile(
              title: Text(favourite.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black)),
              subtitle: Text(category.qualifiedName, style: categoryStyle),
              leading: ExpenseCategoryBar(category.icon, category.color),
              trailing: Text(favourite.amount.round().toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                      fontSize: 18)),
            )));
  }
}
