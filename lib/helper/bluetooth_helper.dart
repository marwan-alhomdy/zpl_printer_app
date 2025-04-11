import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpl_printer_app/helper/printer_helper.dart';

Future<void> _requestPermissions() async {
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();
  await Permission.locationWhenInUse.request();
}

Future<List<BluetoothDevice>?> findBondedDevices() async {
  try {
    // طلب الصلاحيات (مهم لأندرويد 12+)
    await _requestPermissions();
    List<BluetoothDevice> devices = await FlutterBluePlus.bondedDevices;
    return devices;
  } catch (e) {
    return [];
  }
}

Future<void> connectAndDiscover(BluetoothDevice device) async {
  try {
    // الاتصال بالجهاز
    await device.connect(autoConnect: false);

    // اكتشاف الخدمات
    List<BluetoothService> services = await device.discoverServices();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          PrinterHelper.targetCharacteristic = characteristic;
          break;
        }
      }
    }
  } catch (e) {
    print("Connection failed: $e");
  }
}
