import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_new/data/data_category.dart';

class CategoryProvider extends ChangeNotifier {
  int _index = 0;
  String _category = '';

  int get index => _index;
  String get category =>
      _category == DataCategory.categories.first ? '' : _category;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  set category(String value) {
    _category = value;
    notifyListeners();
  }
}
