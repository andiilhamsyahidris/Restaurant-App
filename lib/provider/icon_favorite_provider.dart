import 'package:flutter/material.dart';
import 'package:restaurant_app_new/data/database/favorite_database.dart';

class IconFavoriteProvider extends ChangeNotifier {
  final FavoriteDatabase favoriteDatabase;
  IconFavoriteProvider({required this.favoriteDatabase});

  late Icon _icon;
  late bool _isFavorite;

  Icon get icon => _icon;
  bool get isFavorite => _isFavorite;

  set icon(Icon value) {
    _icon = value;
    notifyListeners();
  }

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  Future<void> setFavoriteIcon(String restaurantId) async {
    final isExist = await favoriteDatabase.isFavoriteAlreadyExist(restaurantId);

    if (isExist) {
      _icon = const Icon(
        Icons.favorite,
        color: Colors.red,
      );
      _isFavorite = true;
    } else {
      _icon = const Icon(
        Icons.favorite,
        color: Colors.white,
      );
      _isFavorite = false;
    }
  }
}
