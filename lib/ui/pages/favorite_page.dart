import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/common/utilities.dart';
import 'package:restaurant_app_new/provider/favorite_provider.dart';
import 'package:restaurant_app_new/ui/screen/loading_screen.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';
import 'package:restaurant_app_new/ui/widget/favorite_list.dart';
import '../../common/custom_information.dart';
import '../../data/model/favorite_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        if (favoriteProvider.state == ResultState.loading) {
          return const LoadingScreen();
        }
        return _buildScaffoldBody(favoriteProvider);
      },
    );
  }

  NestedScrollView _buildScaffoldBody(FavoriteProvider favoriteProvider) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                backgroundColor: backgroundColor,
                floating: true,
                pinned: true,
                title: const Text('Favorite Restaurant'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: () {
                      favoriteProvider.deleteFavorite();
                      Utilities.showSnackBarMessage(
                          context: context, text: 'Data Berhasil dihapus');
                    },
                  )
                ],
              ),
            ),
          ),
        ];
      },
      body: _buildMainPage(favoriteProvider),
    );
  }

  Widget _buildMainPage(FavoriteProvider favoriteProvider) {
    var favorite = favoriteProvider.favorites;

    if (favorite.isNotEmpty) {
      return _buildFavoriteList(favorite, favoriteProvider);
    }

    return const CustomInformation(
      imgPath: 'assets/images/empty.svg',
      title: 'Data Masih Kosong',
      subtitle: '',
    );
  }

  Builder _buildFavoriteList(
      List<Favorite> favorites, FavoriteProvider favoriteProvider) {
    return Builder(
      builder: (context) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final favorite = favoriteProvider.favorites[index];

            return FavoriteList(
              favorite: favorite,
              favoriteProvider: favoriteProvider,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
            );
          },
          itemCount: favoriteProvider.favorites.length,
        );
      },
    );
  }
}
