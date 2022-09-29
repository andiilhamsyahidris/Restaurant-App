import 'package:flutter/foundation.dart';
import 'package:restaurant_app_new/data/api/api_service.dart';
import '../common/result_state.dart';
import '../data/model/restaurant_model.dart';
import 'package:http/http.dart' as http;

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService}) {
    fetchAllRestaurants();
  }

  List<RestaurantModel> _restaurants = <RestaurantModel>[];
  late ResultState _state;
  String _message = '';

  List<RestaurantModel> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  set restaurants(List<RestaurantModel> value) {
    _restaurants = value;
    notifyListeners();
  }

  set state(ResultState value) {
    _state = value;
    notifyListeners();
  }

  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.getRestaurants();
      _restaurants = result;
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurants;
    } catch (_) {
      _message = 'Gagal memuat daftar restoran';
      _state = ResultState.error;
      notifyListeners();
      return _message;
    }
  }
}
