import 'package:flutter/material.dart';
import 'package:my_flutter_mask_api_app/model/store.dart';
import 'package:my_flutter_mask_api_app/repository/store_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Store> stores = [];

  bool _isLoading = true;

  final storeRepository = StoreRepository();

  void getStores() {
    storeRepository.fetch().then((value) {
      setState(() {
        stores = value;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStores();
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
              getStores();
            },
          ),
        ],
      ),
      body: _isLoading
          ? loadingWidget()
          : ListView(
              children: stores
                  .where((element) =>
                      element.remainStat == 'few' ||
                      element.remainStat == 'some')
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

  Widget _buildRemainStatWidget(Store store) {
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
