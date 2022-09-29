import 'package:restaurant_app_new/data/model/menus_model.dart';

class RestaurantDetailModel {
  final String address;
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final MenusModel menu;

  RestaurantDetailModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating,
      required this.address,
      required this.menu});

  factory RestaurantDetailModel.fromMap(Map<String, dynamic> detail) {
    return RestaurantDetailModel(
        id: detail['id'] ?? '',
        name: detail['name'] ?? '',
        description: detail['description'] ?? '',
        pictureId: detail['pictureId'] ?? '',
        city: detail['city'] ?? '',
        rating: detail['rating']?.toDouble() ?? 0.0,
        address: detail['address'] ?? '',
        menu: MenusModel.fromMap(detail['menus'])
        // categories:
        //     detail['categories'].map((e) => CategoryModel.fromMap(e)).toList(),
        );
  }
}
