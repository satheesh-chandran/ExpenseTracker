import 'package:first_flutter_app/AddExpensePage.dart';
import 'package:first_flutter_app/ViewSingleExpensePage.dart';
import 'package:flutter/material.dart';

import '../models/CallBacks.dart';
import '../models/Favourite.dart';
import '../models/NewExpense.dart';
import 'ExpenseCategoryBar.dart';
import 'ExpenseView.dart';

class FavouriteItem extends StatelessWidget {
  final Favourite favourite;
  final EditCallback onEdit;
  final DeleteCallback onDelete;

  const FavouriteItem(this.favourite, this.onEdit, this.onDelete, {super.key});

  Widget _showAlertDialog(BuildContext context) {
    return AlertDialog(
        content: ViewSingleFavouritePage(favourite, false, onDelete, onEdit));
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

class FavouritesView extends StatelessWidget {
  final List<Favourite> favourites;
  final NewExpenseCallback onAddFavourite;
  final EditCallback onEdit;
  final DeleteCallback onDelete;

  const FavouritesView(
      this.favourites, this.onAddFavourite, this.onEdit, this.onDelete,
      {super.key});

  void _addNewFavourite(BuildContext context) async {
    NewExpense expense = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewFavouritePage()));
    if (expense != null) {
      onAddFavourite(expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    var favouriteItemList =
        favourites.map((fav) => FavouriteItem(fav, onEdit, onDelete));
    const welcomeNote =
        "Keep your favourites saved here to add expenses in a single click !";
    const btnText = "Add New Favourite";
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            welcomeNote,
            semanticsLabel: "Welcome Note",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w800),
          )),
      const ContainerSizeBox(),
      ElevatedButton(
          onPressed: () {
            _addNewFavourite(context);
          },
          child: const Text(btnText)),
      const ContainerSizeBox(),
      ...favouriteItemList,
    ]));
  }
}
