import 'package:flutter/foundation.dart';
import 'package:restaurant_app_new/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import '../common/result_state.dart';
import '../data/model/restaurant_model.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService});

  List<RestaurantModel> _restaurants = <RestaurantModel>[];
  ResultState _state = ResultState.hasData;
  String _message = '';

  bool _isSearching = false;
  String _query = '';

  List<RestaurantModel> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  bool get isSearching => _isSearching;
  String get query => _query;

  set restaurants(List<RestaurantModel> value) {
    _restaurants = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  set query(String value) {
    _query = value;
    notifyListeners();
  }

  Future<dynamic> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;

      _query = query;

      final result = await apiService.getRestaurants(query);

      _restaurants = result;

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants;
    } catch (_) {
      _message = 'Gagal mencari restoran';

      _state = ResultState.error;
      notifyListeners();

      return _message;
    }
  }
}
