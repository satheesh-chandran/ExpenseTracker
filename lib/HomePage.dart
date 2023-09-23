import 'package:expense_tracker/widgets/ExpenseView.dart';
import 'package:expense_tracker/widgets/FavouriteView.dart';
import 'package:expense_tracker/widgets/InsightsView.dart';
import 'package:flutter/material.dart';

import 'AddExpensePage.dart';
import 'Constants.dart';
import 'DataRepository.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'models/Favourite.dart';
import 'models/NewExpense.dart';

class HomePage extends StatefulWidget {
  final DataRepository repository;

  const HomePage(this.repository, {super.key});

  @override
  HomePageState createState() => HomePageState(repository);
}

class HomePageState extends State<HomePage> {
  final DataRepository repository;
  List<Expense> expenses = [];
  List<Favourite> favourites = [];
  bool isLoaded = false;

  HomePageState(this.repository);

  void _showSnackBarMessage(String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Widget _showDialogs(BuildContext context, bool shouldRedirect,
      String dialogTitle, VoidCallback callback) {
    return AlertDialog(
      title: Text("Do you want to delete the selected $dialogTitle ?",
          style: const TextStyle(fontSize: 16)),
      actions: [
        TextButton(
            onPressed: () async {
              callback();
              if (context.mounted) {
                Navigator.pop(context);
                if (shouldRedirect) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Yes")),
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text("No"))
      ],
    );
  }

  Widget _showExpenseDeleteAlertDialog(
      BuildContext context, int id, bool shouldRedirect) {
    return _showDialogs(context, shouldRedirect, "expense", () async {
      _setExpenseState(await repository.deleteExpense(id));
    });
  }

  Widget _showFavouriteDeleteAlertDialog(
      BuildContext context, int id, bool shouldRedirect) {
    return _showDialogs(context, shouldRedirect, "favourite", () async {
      _setFavouriteState(await repository.deleteFavouriteExpense(id));
    });
  }

  Future<int> _onDelete(
      BuildContext context, int id, bool shouldRedirect) async {
    showDialog(
        context: context,
        builder: (context) =>
            _showExpenseDeleteAlertDialog(context, id, shouldRedirect));
    return id;
  }

  Future<int> _onFavouriteDelete(
      BuildContext context, int id, bool shouldRedirect) async {
    showDialog(
        context: context,
        builder: (context) =>
            _showFavouriteDeleteAlertDialog(context, id, shouldRedirect));
    return id;
  }

  Future<void> _onEdit(EditExpenseModel expense) async {
    _setExpenseState(await repository.editExpense(expense));
  }

  Future<void> _onFavouriteEdit(EditExpenseModel expense) async {
    _setFavouriteState(await repository.editFavouriteExpense(expense));
  }

  void _setExpenseState(List<Expense> list) {
    setState(() {
      expenses = list;
      isLoaded = true;
    });
  }

  void _setFavouriteState(List<Favourite> list) {
    setState(() {
      favourites = list;
    });
  }

  Future<void> _loadAllExpenses() async {
    _setExpenseState(await repository.getAllExpenses());
  }

  Future<void> _loadAllFavourites() async {
    _setFavouriteState(await repository.getAllFavouriteExpenses());
  }

  void _onAddFavourite(NewExpense expense) async {
    _setFavouriteState(await repository.addNewFavouriteExpense(expense));
    var msg =
        'Favourite Expense: ${expense.title} added of amount ${expense.amount}';
    _showSnackBarMessage(msg);
  }

  void _onAddNewExpense(NewExpense expense) async {
    _setExpenseState(await repository.addNewExpense(expense));
    var msg = 'Expense: ${expense.title} added of amount ${expense.amount}';
    _showSnackBarMessage(msg);
  }

  Future<void> _navigateToAddExpensePage(BuildContext context) async {
    NewExpense expense = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewExpensePage()));
    if (!mounted) return;
    if (expense != null) {
      _onAddNewExpense(expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadAllFavourites();
    _loadAllExpenses();
    deleteAction(id, shouldRedirect) => _onDelete(context, id, shouldRedirect);
    const tabHeaderTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(APP_TITLE),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(10),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Text("Expenses", style: tabHeaderTextStyle),
              Text("Insights", style: tabHeaderTextStyle),
              Text("Favourites", style: tabHeaderTextStyle),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isLoaded
                ? ExpenseView(expenses, false, deleteAction, _onEdit)
                : const Center(child: CircularProgressIndicator()),
            isLoaded
                ? InsightsView(expenses, repository, deleteAction, _onEdit)
                : const Center(child: CircularProgressIndicator()),
            FavouritesView(
                favourites,
                _onAddFavourite,
                _onFavouriteEdit,
                _onAddNewExpense,
                (id, shouldRedirect) =>
                    _onFavouriteDelete(context, id, shouldRedirect))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateToAddExpensePage(context);
          },
          tooltip: 'Add Expense',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
