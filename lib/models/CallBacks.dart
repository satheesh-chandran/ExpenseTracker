import 'package:first_flutter_app/models/Favourite.dart';

import 'EditExpenseModel.dart';

typedef DeleteCallback = Future<int> Function(int id, bool shouldRedirect);
typedef EditCallback = void Function(EditExpenseModel model);
typedef AddFromFavouriteCallback = void Function(Favourite model);
