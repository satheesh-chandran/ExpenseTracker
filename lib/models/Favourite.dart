import 'ExpenseCategory.dart';

class Favourite {
  final int id;
  final String title;
  final double amount;
  final ExpenseCategory category;

  const Favourite(
      {required this.id,
      required this.title,
      required this.amount,
      required this.category});
}
