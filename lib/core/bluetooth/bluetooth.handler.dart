import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothHandler {
  static String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  static String getNiceManufacturerData(List<List<int>> data) {
    return data.map((val) => getNiceHexArray(val)).join(', ').toUpperCase();
  }

  static String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${getNiceHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  static String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }
}
