import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:restaurant_app_new/data/model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev/';
  final Client client;

  ApiService(this.client);

  Future<List<RestaurantModel>> getRestaurants([String? query]) async {
    final url = (query == null || query.isEmpty)
        ? '${baseUrl}list'
        : '${baseUrl}search?q=$query';

    final uri = Uri.parse(url);

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List restaurants =
            (result as Map<String, dynamic>)['restaurants'];
        return restaurants.map((e) {
          return RestaurantModel.fromMap(e);
        }).toList();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    final uri = Uri.parse('${baseUrl}detail/$id');

    try {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        final results = jsonDecode(response.body);
        final restaurant = (results as Map<String, dynamic>)['restaurant'];
        final result = RestaurantDetailModel.fromMap(restaurant);
        return result;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
