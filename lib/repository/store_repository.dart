import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_mask_api_app/model/store.dart';

class StoreRepository {
  final _distance = Distance();

  Future<List<Store>> fetch(double latitude, double longitude) async {
    List<Store> stores = [];
    try {
      var url =
          'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonStores =
            jsonDecode(utf8.decode(response.bodyBytes))['stores'];

        jsonStores.forEach((e) {
          final store = Store.fromJson(e);
          final km = _distance.as(
              LengthUnit.Kilometer,
              new LatLng(store.lat, store.lng),
              new LatLng(latitude, longitude));
          store.km = km;
          stores.add(store);
        });
        logger.info('qwerasdf fetch done');

        stores = stores
            .where((element) =>
                element.remainStat == 'few' || element.remainStat == 'some')
            .toList();

        stores.sort((a, b) => a.km.compareTo(b.km));
        return stores;
      } else {
        logger.info(
            'qwerasdf store_repository response.statusCode ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.info('qwerasdf store_repository catch $e');
      return [];
    }
  }
}
