import 'dart:async';
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

  bool _isLoading = true;

  Future fetch() async {
    _isLoading = true;
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';
    final response = await http.get(Uri.parse(url));
    final jsonStores = jsonDecode(utf8.decode(response.bodyBytes))['stores'];
    setState(() {
      stores.clear();

      jsonStores.forEach((e) {
        stores.add(StoreModel.fromJson(e));
      });
      _isLoading = false;
    });
    logger.info('qwerasdf fetch');
    logger.info('qwerasdf loading $_isLoading');
  }

  @override
  void initState() {
    super.initState();
    fetch();
    logger.info('qwerasdf init done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('마스크 재고 있는 곳 : ${stores.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              logger.info('qwerasdf press button');
              fetch();
              logger.info('qwerasdf press button');
            },
          ),
        ],
      ),
      body: _isLoading
          ? loadingWidget()
          : ListView(
              children: stores
                  .where((element) => element.remainStat == 'few')
                  .map((e) {
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: _buildRemainStatWidget(e),
                );
              }).toList(),
            ),
    );
  }

  Widget loadingWidget() {
    return const Center(
      child: Column(
        children: [
          Text('isLoading'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildRemainStatWidget(StoreModel store) {
    var remainStat = '판매중지';
    var description = '';
    var color = Colors.black;

    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
      case 'some':
        remainStat = '보통';
        description = '30개 이상 100개 미만';
        color = Colors.yellow;
      case 'few':
        remainStat = '부족';
        description = '2개 이상 30개 미만';
        color = Colors.red;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;

      default:
    }

    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
