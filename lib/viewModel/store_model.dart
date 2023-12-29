import 'package:flutter/foundation.dart';
import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:my_flutter_mask_api_app/model/store.dart';
import 'package:my_flutter_mask_api_app/repository/store_repository.dart';

class StoreModel with ChangeNotifier {
  List<Store> stores = [];

  var isLoading = true;

  final _storeRepository = StoreRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    isLoading = true;
    logger.info('qwerasdf is loading $isLoading');
    notifyListeners();

    stores = await _storeRepository.fetch();
    isLoading = false;
    logger.info('qwerasdf is loading $isLoading');
    notifyListeners();
  }
}
