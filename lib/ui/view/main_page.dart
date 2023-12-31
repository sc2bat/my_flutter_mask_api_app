import 'package:flutter/material.dart';
import 'package:my_flutter_mask_api_app/ui/widget/remainStat_widget.dart';
import 'package:my_flutter_mask_api_app/viewModel/store_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('마스크 재고 있는 곳 : ${storeModel.stores.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              storeModel.fetch();
            },
          ),
        ],
      ),
      body: storeModel.isLoading
          ? loadingWidget()
          : ListView(
              children: storeModel.stores.map(
                (e) {
                  return RemainStatWidget(store: e);
                },
              ).toList(),
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
}
