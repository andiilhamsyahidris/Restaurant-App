import 'package:restaurant_app_new/data/model/item_menu.dart';

class MenusModel {
  final List<ItemMenu> foods;
  final List<ItemMenu> drinks;

  MenusModel({required this.foods, required this.drinks});

  factory MenusModel.fromMap(Map<String, dynamic> menu) {
    return MenusModel(
      foods: List<ItemMenu>.from(menu['foods']?.map((food) {
        return ItemMenu.fromMap(food);
      })),
      drinks: List<ItemMenu>.from(menu['drinks']?.map((drink) {
        return ItemMenu.fromMap(drink);
      })),
    );
  }
}
