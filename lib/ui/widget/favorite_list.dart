import 'package:flutter/material.dart';
import 'package:restaurant_app_new/common/utilities.dart';
import 'package:restaurant_app_new/ui/screen/detailscreen.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../data/model/favorite_model.dart';
import '../../provider/favorite_provider.dart';

class FavoriteList extends StatelessWidget {
  final Favorite favorite;
  final FavoriteProvider favoriteProvider;

  const FavoriteList(
      {Key? key, required this.favorite, required this.favoriteProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pictureId = favorite.pictureId;
    return Slidable(
      groupTag: 1,
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
              onPressed: (context) {
                favoriteProvider.deleteFavoriteById(favorite.id!).then((_) {
                  Utilities.showSnackBarMessage(
                    context: context,
                    text: 'Data berhasil dihapus',
                    action: retrieveDeletedFavorite(favorite, favoriteProvider),
                  );
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete),
          SlidableAction(
            onPressed: (context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(restaurantId: favorite.restaurantId),
                  ));
            },
            backgroundColor: secondaryColor,
            foregroundColor: backgroundColor,
            icon: Icons.details,
          )
        ],
      ),
      child: ListTile(
        hoverColor: primaryColor,
        leading: Image.network(
          'https://restaurant-api.dicoding.dev/images/small/$pictureId',
          fit: BoxFit.cover,
        ),
        title: Text(
          favorite.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        subtitle: Text(
          favorite.city,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white54),
        ),
      ),
    );
  }

  SnackBarAction retrieveDeletedFavorite(
    Favorite favorite,
    FavoriteProvider favoriteProvider,
  ) {
    return SnackBarAction(
      label: 'Dismiss',
      onPressed: () async {
        await favoriteProvider.createFavorite(favorite);
      },
    );
  }
}
