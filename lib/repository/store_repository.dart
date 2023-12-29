import 'dart:convert';

import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_mask_api_app/model/store.dart';

class StoreRepository {
  Future<List<Store>> fetch() async {
    final List<Store> stores = [];
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    final response = await http.get(Uri.parse(url));
    final jsonStores = jsonDecode(utf8.decode(response.bodyBytes))['stores'];

    jsonStores.forEach((e) {
      stores.add(Store.fromJson(e));
    });
    logger.info('qwerasdf fetch done');

    return stores;
  }
}
