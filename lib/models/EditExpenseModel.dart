import 'ExpenseCategory.dart';

class EditExpenseModel {
  final int id;
  final String title;
  final int amount;
  final ExpenseCategory category;

  const EditExpenseModel(this.id, this.title, this.amount, this.category);
}