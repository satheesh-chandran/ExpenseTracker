import 'EditExpenseModel.dart';
import 'Favourite.dart';
import 'NewExpense.dart';

typedef DeleteCallback = Future<int> Function(int id, bool shouldRedirect);
typedef EditCallback = void Function(EditExpenseModel model);
typedef AddFromFavouriteCallback = void Function(Favourite model);
typedef NewExpenseCallback = void Function(NewExpense model);
typedef DateSetter = void Function(DateTime date);
