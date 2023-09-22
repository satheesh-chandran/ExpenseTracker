import 'ExpenseCategory.dart';

class NewExpense {
  final String title;
  final int amount;
  final ExpenseCategory category;

  const NewExpense(this.title, this.amount, this.category);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category.name,
    };
  }
}
