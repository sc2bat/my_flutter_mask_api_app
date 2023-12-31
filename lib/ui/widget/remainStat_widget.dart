// ignore_for_file: unnecessary_import, file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_flutter_mask_api_app/logger/logger.dart';
import 'package:my_flutter_mask_api_app/model/store.dart';
import 'package:url_launcher/url_launcher.dart';

class RemainStatWidget extends StatelessWidget {
  final Store store;

  const RemainStatWidget({super.key, required this.store});

  Future<void> _launchUrl(double latitude, double longitude) async {
    final Uri _url = Uri.parse(
        'https://www.google.co.kr/maps/search/?api=1&query=$latitude,$longitude');
    logger.info('qwerasdf $_url');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(store.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(store.addr),
          Text('${store.km} km'),
        ],
      ),
      trailing: _buildRemainStatWidget(store),
      onTap: () {
        logger.info('qwerasdf taptap');
        _launchUrl(store.lat, store.lng);
      },
    );
  }
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
