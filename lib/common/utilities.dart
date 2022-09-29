import 'package:flutter/material.dart';
import 'package:restaurant_app_new/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_new/data/model/restaurant_model.dart';
import 'package:restaurant_app_new/provider/favorite_provider.dart';
import 'package:restaurant_app_new/provider/icon_favorite_provider.dart';
import '../data/model/favorite_model.dart';

class Utilities {
  static Future<void> addToFavorite({
    required BuildContext context,
    required FavoriteProvider favoriteProvider,
    required IconFavoriteProvider iconFavoriteProvider,
    RestaurantModel? restaurantModel,
    RestaurantDetailModel? restaurantDetailModel,
  }) async {
    final id = restaurantModel?.id ?? restaurantDetailModel!.id;
    final name = restaurantModel?.name ?? restaurantDetailModel!.name;
    final pictureId =
        restaurantModel?.pictureId ?? restaurantDetailModel!.pictureId;
    final city = restaurantModel?.city ?? restaurantDetailModel!.city;
    final rating = restaurantModel?.rating ?? restaurantDetailModel!.rating;

    final favorite = Favorite(
        restaurantId: id,
        name: name,
        pictureId: pictureId,
        city: city,
        rating: rating.toString(),
        createdAt: DateTime.now());

    iconFavoriteProvider.icon = const Icon(
      Icons.favorite,
      color: Colors.red,
    );
    iconFavoriteProvider.isFavorite = true;
    showSnackBarMessage(
        context: context, text: 'Berhasil ditambahkan ke daftar favorit');

    await favoriteProvider.createFavorite(favorite);
  }

  static Future<void> removeFromFavorite(
      {required BuildContext context,
      required FavoriteProvider favoriteProvider,
      required IconFavoriteProvider iconFavoriteProvider,
      RestaurantModel? restaurantModel,
      RestaurantDetailModel? restaurantDetailModel}) async {
    final restaurantId = restaurantModel?.id ?? restaurantDetailModel!.id;
    await favoriteProvider.deleteFavoriteByRestaurantId(restaurantId);

    iconFavoriteProvider.icon = const Icon(
      Icons.favorite,
      color: Colors.white,
    );
    iconFavoriteProvider.isFavorite = false;
    showSnackBarMessage(
        context: context, text: 'Berhasil dihapus dari daftar favorite');
  }

  static void showSnackBarMessage(
      {required BuildContext context,
      required String text,
      SnackBarAction? action}) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      action: action,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
