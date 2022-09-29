import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/common/custom_information.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app_new/provider/page_reload_provider.dart';
import 'package:restaurant_app_new/provider/restaurant_provider.dart';
import 'package:restaurant_app_new/provider/search_provider.dart';
import 'package:restaurant_app_new/ui/screen/detailscreen.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key, this.restaurantId}) : super(key: key);

  final String? restaurantId;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomInformation(
          imgPath: 'assets/images/signal.svg',
          title: 'Anda Sedang Offline',
          subtitle: 'Periksa Koneksi Jaringan Anda',
          child: Consumer4<RestaurantProvider, DetailRestaurantProvider,
              SearchProvider, PageReloadProvider>(
            builder: (context, restaurantProvider, detailRestaurantProvider,
                searchProvider, pageReloadProvider, child) {
              return ElevatedButton.icon(
                onPressed: pageReloadProvider.isReload
                    ? null
                    : () {
                        if (widget.restaurantId != null) {
                          reloadPage(
                              restaurantProvider: restaurantProvider,
                              detailRestaurantProvider:
                                  detailRestaurantProvider,
                              searchProvider: searchProvider,
                              pageReloadProvider: pageReloadProvider,
                              restaurantId: widget.restaurantId);
                        } else {
                          reloadPage(
                              restaurantProvider: restaurantProvider,
                              detailRestaurantProvider:
                                  detailRestaurantProvider,
                              searchProvider: searchProvider,
                              pageReloadProvider: pageReloadProvider);
                        }
                      },
                icon: pageReloadProvider.isReload
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: secondaryColor,
                        ),
                      )
                    : const Icon(Icons.replay_rounded),
                label: pageReloadProvider.isReload
                    ? const Text('Memuat Data')
                    : const Text('Coba Lagi'),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> reloadPage(
      {required RestaurantProvider restaurantProvider,
      required DetailRestaurantProvider detailRestaurantProvider,
      required SearchProvider searchProvider,
      required PageReloadProvider pageReloadProvider,
      String? restaurantId}) async {
    pageReloadProvider.isReload = true;

    var message = '';

    Future.wait([
      Future.delayed(const Duration(milliseconds: 1000)),
      if (restaurantId != null) ...[
        detailRestaurantProvider.getRestaurantDetail(restaurantId)
      ] else ...[
        restaurantProvider.fetchAllRestaurants(),
        searchProvider.searchRestaurants(searchProvider.query)
      ]
    ]).then((value) {
      pageReloadProvider.isReload = false;
      if (restaurantId != null) {
        detailRestaurantProvider.detail = value[1];
        detailRestaurantProvider.state = ResultState.hasData;
      } else {
        restaurantProvider.restaurants = value[1];
        restaurantProvider.state = ResultState.hasData;
        searchProvider.restaurants = value[2];
      }

      if (restaurantId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailScreen(restaurantId: restaurantId);
            },
          ),
        );
      }
    }).catchError((_) {
      pageReloadProvider.isReload = false;
      if (restaurantId != null) {
        message = detailRestaurantProvider.message;
      } else {
        message = restaurantProvider.message;
      }
    });
  }
}
