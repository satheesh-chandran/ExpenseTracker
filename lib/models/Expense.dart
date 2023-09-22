import 'ExpenseCategory.dart';

class Expense {
  final int id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final String paidDate;
  final bool isRefundable;
  final double refundedAmount;
  final bool deletionMarker;

  const Expense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.category,
      required this.paidDate,
      required this.isRefundable,
      required this.refundedAmount,
      required this.deletionMarker});
}
