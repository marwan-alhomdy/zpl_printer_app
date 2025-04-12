import 'dart:io' show Platform;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zpl_printer_app/helper/printer_helper.dart';

Future<void> _requestPermissions() async {
  // التحقق أولاً إذا كانت الصلاحيات مُمنحة
  if (!await Permission.bluetoothConnect.isGranted) {
    await Permission.bluetoothConnect.request();
  }

  if (!await Permission.bluetoothScan.isGranted) {
    await Permission.bluetoothScan.request();
  }

  // ليس كل الأجهزة تتطلب إذن الموقع
  if (Platform.isAndroid && await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }
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

Future<List<BluetoothDevice>?> checkBondedAndConnectedDevices() async {
  await _requestPermissions();

  List<BluetoothDevice> bonded = await FlutterBluePlus.bondedDevices;
  List<BluetoothDevice> connected = FlutterBluePlus.connectedDevices;

  for (var device in bonded) {
    bool isActuallyConnected = connected.any(
      (d) => d.remoteId == device.remoteId,
    );
    print(
      "${device.platformName} مقترن - ${isActuallyConnected ? "✅ متصل" : "❌ غير متصل"}",
    );
  }
  return [...bonded, ...connected];
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
