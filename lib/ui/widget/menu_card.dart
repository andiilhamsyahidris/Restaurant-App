import 'package:flutter/material.dart';
import 'package:restaurant_app_new/data/model/item_menu.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';

class MenuCard extends StatelessWidget {
  final ItemMenu? food;
  final ItemMenu? drink;

  const MenuCard({Key? key, this.food, this.drink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            child: Text(
              food?.name ?? drink!.name,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
