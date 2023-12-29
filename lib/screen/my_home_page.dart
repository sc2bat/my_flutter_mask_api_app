import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:my_flutter_mask_api_app/model/store_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<StoreModel> stores = [];

  Future fetch() async {
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    final response = await http.get(Uri.parse(url));
    logger.info('qwerasdf fetch 111');
    final jsonStores = jsonDecode(utf8.decode(response.bodyBytes));
    logger.info('qwerasdf fetch 222');

    stores.clear();
    logger.info('qwerasdf fetch ${stores.length}');
    // logger.info('qwerasdf ${jsonStores['stores']}');
    jsonStores.forEach((e) {
      stores.add(StoreModel.fromJson(e));
    });
    logger.info('qwerasdf fetch ${stores.length}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
    logger.info('qwerasdf init done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('마스크 재고 있는 곳 : 00'),
        ),
        body: ListView(
          children: stores.map((e) => Text(e.remainStat ?? '')).toList(),
        ));
  }
}
