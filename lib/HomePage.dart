import 'package:first_flutter_app/models/Favourite.dart';
import 'package:first_flutter_app/widgets/ExpenseView.dart';
import 'package:first_flutter_app/widgets/FavouriteView.dart';
import 'package:first_flutter_app/widgets/InsightsView.dart';
import 'package:flutter/material.dart';

import 'AddExpensePage.dart';
import 'Constants.dart';
import 'DataRepository.dart';
import 'models/EditExpenseModel.dart';
import 'models/Expense.dart';
import 'models/NewExpense.dart';

class HomePage extends StatefulWidget {
  final DataRepository repository;

  const HomePage(this.repository, {super.key});

  @override
  _HomePageState createState() => _HomePageState(repository);
}

class _HomePageState extends State<HomePage> {
  final DataRepository repository;
  List<Expense> expenses = [];
  List<Favourite> favourites = [];
  bool isLoaded = false;

  _HomePageState(this.repository);

  void _showSnackBarMessage(String msg) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Widget _showDeleteAlertDialog(
      BuildContext context, int id, bool shouldRedirect) {
    return AlertDialog(
      title: const Text("Do you want to delete selected expense ?",
          style: TextStyle(fontSize: 16)),
      actions: [
        TextButton(
            onPressed: () async {
              _setExpenseState(await repository.deleteExpense(id));
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

  Future<int> _onDelete(
      BuildContext context, int id, bool shouldRedirect) async {
    showDialog(
        context: context,
        builder: (context) =>
            _showDeleteAlertDialog(context, id, shouldRedirect));
    return id;
  }

  Future<void> _onEdit(EditExpenseModel expense) async {
    _setExpenseState(await repository.editExpense(expense));
  }

  void _setExpenseState(List<Expense> list) {
    setState(() {
      expenses = list;
      isLoaded = true;
    });
  }

  Future<void> _loadAllExpenses() async {
    _setExpenseState(await repository.getAllExpenses());
  }

  Future<void> _loadAllFavourites() async {
    List<Favourite> list = await repository.getAllFavouriteExpenses();
    setState(() {
      favourites = list;
    });
  }

  void _onAddFavourite(NewExpense expense) async {
    List<Favourite> list = await repository.addNewFavouriteExpense(expense);
    setState(() {
      favourites = list;
    });
    var msg =
        'Favourite Expense: ${expense.title} added of amount ${expense.amount}';
    _showSnackBarMessage(msg);
  }

  Future<void> _navigateToAddExpensePage(BuildContext context) async {
    NewExpense expense = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddNewExpensePage()));
    if (!mounted) return;
    if (expense != null) {
      _setExpenseState(await repository.addNewExpense(expense));
      var msg = 'Expense: ${expense.title} added of amount ${expense.amount}';
      _showSnackBarMessage(msg);
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
            FavouritesView(favourites, _onAddFavourite)
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
