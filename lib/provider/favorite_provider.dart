import 'package:flutter/material.dart';
import 'package:restaurant_app_new/data/database/favorite_database.dart';
import '../common/result_state.dart';
import '../data/model/favorite_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDatabase favoriteDatabase;

  FavoriteProvider({required this.favoriteDatabase}) {
    _readFavorites();
  }

  late ResultState _state;
  late List<Favorite> _favorites;

  ResultState get state => _state;
  List<Favorite> get favorites => _favorites;

  Future<void> _readFavorites() async {
    _state = ResultState.loading;
    notifyListeners();

    _favorites = await favoriteDatabase.readFavorites();

    _state = ResultState.hasData;
    notifyListeners();
  }

  Future<void> createFavorite(Favorite favorite) async {
    await favoriteDatabase.createFavorite(favorite);
    _readFavorites();
  }

  Future<void> deleteFavorite() async {
    await favoriteDatabase.deletedFavorite();
    _readFavorites();
  }

  Future<void> deleteFavoriteByRestaurantId(String restaurantId) async {
    await favoriteDatabase.deletedFavoriteByRestaurantId(restaurantId);
    _readFavorites();
  }

  Future<void> deleteFavoriteById(int id) async {
    await favoriteDatabase.deletedFavoriteById(id);
    _readFavorites();
  }

  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    return await favoriteDatabase.isFavoriteAlreadyExist(restaurantId);
  }
}
