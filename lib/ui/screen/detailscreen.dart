import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/common/utilities.dart';
import 'package:restaurant_app_new/data/model/item_menu.dart';
import 'package:restaurant_app_new/data/model/restaurant_detail_model.dart';
import 'package:restaurant_app_new/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app_new/provider/favorite_provider.dart';
import 'package:restaurant_app_new/provider/icon_favorite_provider.dart';
import 'package:restaurant_app_new/ui/screen/error_screen.dart';
import 'package:restaurant_app_new/ui/screen/loading_screen.dart';
import 'package:restaurant_app_new/ui/widget/menu_card.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({Key? key, required this.restaurantId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<DetailRestaurantProvider>(context, listen: false)
            .getRestaurantDetail(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DetailRestaurantProvider, FavoriteProvider,
            IconFavoriteProvider>(
        builder: (context, detailProvider, favoriteProvider,
            iconFavoriteProvider, child) {
      if (detailProvider.result == ResultState.loading &&
          favoriteProvider.state == ResultState.loading) {
        return const LoadingScreen();
      } else if (detailProvider.result == ResultState.hasData) {
        return _buildDetailScreen(context, detailProvider.detail,
            favoriteProvider, iconFavoriteProvider);
      } else if (detailProvider.result == ResultState.error) {
        return ErrorScreen(
          restaurantId: widget.restaurantId,
        );
      } else {
        return const Center();
      }
    });
  }

  Scaffold _buildDetailScreen(
    BuildContext context,
    RestaurantDetailModel? restaurantDetailModel,
    FavoriteProvider favoriteProvider,
    IconFavoriteProvider iconFavoriteProvider,
  ) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 225,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: iconFavoriteProvider.isFavorite
                      ? () {
                          Utilities.removeFromFavorite(
                              context: context,
                              favoriteProvider: favoriteProvider,
                              iconFavoriteProvider: iconFavoriteProvider,
                              restaurantDetailModel: restaurantDetailModel);
                        }
                      : () {
                          Utilities.addToFavorite(
                              context: context,
                              favoriteProvider: favoriteProvider,
                              iconFavoriteProvider: iconFavoriteProvider,
                              restaurantDetailModel: restaurantDetailModel);
                        },
                  icon: iconFavoriteProvider.icon,
                  tooltip: 'Favorite',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://restaurant-api.dicoding.dev/images/medium/${restaurantDetailModel.pictureId}'))),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding:
              const EdgeInsets.only(top: 20, bottom: 0, right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurantDetailModel!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Text(
                              restaurantDetailModel.rating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    Text(
                      restaurantDetailModel.city,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white54),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 40, bottom: 10),
                  child: Text(
                    'Description',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
                Text(
                  restaurantDetailModel.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white54),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 18, bottom: 10),
                  child: Text(
                    'Menu',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 10),
                  child: Text(
                    'Makanan',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: _buildItemMenu(
                        drinks: restaurantDetailModel.menu.foods)),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Minuman',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: _buildItemMenu(
                        drinks: restaurantDetailModel.menu.drinks)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _buildItemMenu({List<ItemMenu>? foods, List<ItemMenu>? drinks}) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return MenuCard(
            food: foods?[index],
            drink: drinks?[index],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              width: 5,
            ),
        itemCount: foods?.length ?? drinks!.length);
  }
}
