import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:my_flutter_mask_api_app/model/store.dart';
import 'package:my_flutter_mask_api_app/repository/location_repository.dart';
import 'package:my_flutter_mask_api_app/repository/store_repository.dart';

class StoreModel with ChangeNotifier {
  List<Store> stores = [];

  var isLoading = true;

  final _storeRepository = StoreRepository();
  final _locationRepository = LocationRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    isLoading = true;
    logger.info('qwerasdf is loading $isLoading');
    notifyListeners();

    Position position = await _locationRepository.getCurrentLocation();

    stores =
        await _storeRepository.fetch(position.latitude, position.longitude);
    isLoading = false;
    logger.info('qwerasdf is loading $isLoading');
    notifyListeners();
  }
}
