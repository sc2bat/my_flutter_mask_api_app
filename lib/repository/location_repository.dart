import 'package:geolocator/geolocator.dart';

class LocationRepository {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final _geolocator = Geolocator();

  final List<_PositionItem> _positionItems = <_PositionItem>[];

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      return;
    }

    void updatePositionList(_PositionItemType type, String displayValue) {
      _positionItems.add(_PositionItem(type, displayValue));
      setState(() {});
    }

    Future<bool> handlePermission() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        updatePositionList(
          _PositionItemType.log,
          _kLocationServicesDisabledMessage,
        );

        return false;
      }

      permission = await _geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geolocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          updatePositionList(
            _PositionItemType.log,
            _kPermissionDeniedMessage,
          );

          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedForeverMessage,
        );

        return false;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      updatePositionList(
        _PositionItemType.log,
        _kPermissionGrantedMessage,
      );
      return true;
    }
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
