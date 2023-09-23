import 'package:flutter/material.dart';

import '../AddExpensePage.dart';
import '../models/CallBacks.dart';
import '../models/Favourite.dart';
import '../models/NewExpense.dart';
import 'FavouriteItem.dart';

class FavouritesView extends StatelessWidget {
  final List<Favourite> favourites;
  final NewExpenseCallback onAddFavourite;
  final NewExpenseCallback onAddFromFavourite;
  final EditCallback onEdit;
  final DeleteCallback onDelete;

  const FavouritesView(this.favourites, this.onAddFavourite, this.onEdit,
      this.onAddFromFavourite, this.onDelete,
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
    var favouriteItemList = favourites
        .map((fav) => FavouriteItem(fav, onEdit, onDelete, onAddFromFavourite));
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
