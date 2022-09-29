import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/data/model/favorite_model.dart';
import 'package:restaurant_app_new/provider/icon_favorite_provider.dart';
import 'package:restaurant_app_new/provider/restaurant_provider.dart';
import 'package:restaurant_app_new/provider/search_provider.dart';
import 'package:restaurant_app_new/ui/screen/detailscreen.dart';
import 'package:restaurant_app_new/ui/screen/error_screen.dart';
import 'package:restaurant_app_new/ui/screen/loading_screen.dart';
import 'package:restaurant_app_new/ui/widget/restaurant_card.dart';
import '../../data/model/restaurant_model.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Favorite? favorite;
    RestaurantModel? restaurantModel;
    return Consumer2<RestaurantProvider, SearchProvider>(
      builder: (context, restaurantProvider, searchProvider, child) {
        return _buildMainPage(
            restaurantProvider, searchProvider, restaurantModel, favorite);
      },
    );
  }

  Widget _buildMainPage(
      RestaurantProvider restaurantProvider,
      SearchProvider searchProvider,
      RestaurantModel? restaurantModel,
      Favorite? favorite) {
    if (restaurantProvider.state == ResultState.loading) {
      return const LoadingScreen();
    } else if (restaurantProvider.state == ResultState.error) {
      return const ErrorScreen();
    }

    var restaurants = restaurantProvider.restaurants;

    if (searchProvider.query.isNotEmpty) {
      restaurants = searchProvider.restaurants;
      if (searchProvider.state == ResultState.error) {
        return const ErrorScreen();
      }
      return _buildRestaurantList(restaurants, favorite);
    }
    return _buildRestaurantList(restaurants, favorite);
  }

  Builder _buildRestaurantList(
      List<RestaurantModel> restaurants, Favorite? favorite) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildGrid(restaurants[index], context, favorite);
              }, childCount: restaurants.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            )
          ],
        );
      },
    );
  }

  Widget _buildGrid(
      RestaurantModel? restaurant, BuildContext context, Favorite? favorite) {
    return Material(
      child: InkWell(
          onTap: () {
            final id = restaurant?.id ?? favorite!.restaurantId;
            context.read<IconFavoriteProvider>().setFavoriteIcon(id);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailScreen(restaurantId: id);
            }));
          },
          child: RestaurantCard(restaurant: restaurant)),
    );
  }
}
