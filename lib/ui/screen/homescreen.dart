import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/data/data_category.dart';
import 'package:restaurant_app_new/provider/bottomnav_provider.dart';
import 'package:restaurant_app_new/provider/restaurant_provider.dart';
import 'package:restaurant_app_new/provider/search_provider.dart';
import 'package:restaurant_app_new/ui/pages/favorite_page.dart';
import 'package:restaurant_app_new/ui/pages/homepage.dart';
import 'package:restaurant_app_new/ui/pages/settings_page.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';
import 'package:restaurant_app_new/ui/widget/category_list.dart';
import 'package:restaurant_app_new/ui/widget/search_field.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Widget> _pages = [
    const Homepage(),
    const FavoritePage(),
    const SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer3<BottomNavProvider, SearchProvider, RestaurantProvider>(
      builder: (context, bottomnavProvider, searchProvider, restaurantProvider,
          child) {
        final currentIndex = bottomnavProvider.index;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: currentIndex == 0
              ? _buildScaffoldBody(
                  bottomnavProvider, restaurantProvider, searchProvider)
              : _buildBody(currentIndex),
          bottomNavigationBar: _buildBottomNav(bottomnavProvider),
        );
      },
    );
  }

  NestedScrollView _buildScaffoldBody(BottomNavProvider bottomNavProvider,
      RestaurantProvider restaurantProvider, SearchProvider searchProvider) {
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
                title: _buildTitle(searchProvider, bottomNavProvider),
                leading: _buildLeading(searchProvider),
                actions: _buildAction(),
                bottom: _buildCategory(restaurantProvider),
              ),
            ),
          ),
        ];
      },
      body: _buildBody(bottomNavProvider.index),
    );
  }

  Widget _buildTitle(
      SearchProvider searchProvider, BottomNavProvider bottomNavProvider) {
    return SearchField(
        hintText: 'Cari Restaurant',
        onChanged: (query) {
          searchProvider.searchRestaurants(query);
        });
  }

  Widget _buildLeading(SearchProvider searchProvider) {
    return searchProvider.isSearching
        ? IconButton(
            onPressed: () {
              searchProvider.isSearching = false;
              searchProvider.query = '';
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 28,
            ))
        : const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.restaurant,
              color: Colors.white,
            ),
          );
  }

  List<Widget> _buildAction() {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 10, top: 7),
        child: Image.asset(
          'assets/images/avatar.png',
          width: 40,
        ),
      ),
    ];
  }

  CategoryList? _buildCategory(RestaurantProvider restaurantProvider) {
    return const CategoryList(categories: DataCategory.categories);
  }

  Widget _buildBody(int index) => _pages[index];

  BottomNavigationBar _buildBottomNav(BottomNavProvider bottomNavProvider) {
    return BottomNavigationBar(
        currentIndex: bottomNavProvider.index,
        selectedFontSize: 12,
        backgroundColor: primaryColor,
        selectedItemColor: secondaryColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedFontSize: 12,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'FoodS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        onTap: (index) {
          bottomNavProvider.index = index;

          switch (index) {
            case 0:
              bottomNavProvider.title = 'FoodS';
              break;
            case 1:
              bottomNavProvider.title = 'Favorite';
              break;
          }
        });
  }
}
