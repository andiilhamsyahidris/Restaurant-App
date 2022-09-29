import 'package:flutter/cupertino.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_new/data/model/restaurant_detail_model.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailRestaurantProvider({required this.apiService});

  late RestaurantDetailModel _detailModel;
  ResultState _resultState = ResultState.init;
  String _message = '';

  RestaurantDetailModel get detail => _detailModel;
  ResultState get result => _resultState;
  String get message => _message;

  set detail(RestaurantDetailModel value) {
    _detailModel = value;
    notifyListeners();
  }

  set state(ResultState value) {
    _resultState = value;
    notifyListeners();
  }

  Future<dynamic> getRestaurantDetail(String id) async {
    try {
      _resultState = ResultState.loading;
      notifyListeners();
      final result = await apiService.getRestaurantDetail(id);
      _detailModel = result;
      _resultState = ResultState.hasData;
      notifyListeners();
      return _detailModel;
    } catch (e) {
      _message = 'Gagal memuat detail restoran';
      _resultState = ResultState.error;
      notifyListeners();
      return _message;
    }
  }
}
