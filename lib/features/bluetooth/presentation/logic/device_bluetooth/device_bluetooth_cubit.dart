import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:zpl_printer_app/core/bluetooth/extra.dart';

import '../../../../../core/bluetooth/snackbar.dart';
import '../../../../../helper/printer_helper.dart';

part 'device_bluetooth_state.dart';

class DeviceBluetoothCubit extends Cubit<DeviceBluetoothState> {
  final BluetoothDevice device;
  DeviceBluetoothCubit({required this.device})
    : super(DeviceBluetoothInitial()) {
    initDeviceBluetooth();
  }
  int? rssi;
  int? mtuSize;
  BluetoothConnectionState connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> services = [];
  bool isDiscoveringServices = false;
  bool isConnecting = false;
  bool isDisconnecting = false;

  late StreamSubscription<BluetoothConnectionState> connectionStateSubscription;
  late StreamSubscription<bool> isConnectingSubscription;
  late StreamSubscription<bool> isDisconnectingSubscription;
  late StreamSubscription<int> mtuSubscription;

  bool get isConnected {
    return connectionState == BluetoothConnectionState.connected;
  }

  void initDeviceBluetooth() {
    connectionStateSubscription = device.connectionState.listen((state) async {
      connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && rssi == null) {
        rssi = await device.readRssi();
      }
      emit(DeviceBluetooth1(DateTime.now()));
    });

    mtuSubscription = device.mtu.listen((value) {
      mtuSize = value;
      emit(DeviceBluetooth1(DateTime.now()));
    });

    isConnectingSubscription = device.isConnecting.listen((value) {
      isConnecting = value;
      emit(DeviceBluetooth1(DateTime.now()));
    });

    isDisconnectingSubscription = device.isDisconnecting.listen((value) {
      isDisconnecting = value;
      emit(DeviceBluetooth1(DateTime.now()));
    });
  }

  @override
  Future<void> close() async {
    connectionStateSubscription.cancel();
    mtuSubscription.cancel();
    isConnectingSubscription.cancel();
    isDisconnectingSubscription.cancel();
    super.close();
  }

  Future onConnectPressed() async {
    try {
      await device.connectAndUpdateStream();
      Snackbar.show(ABC.c, "Connect: Success", success: true);
    } catch (e) {
      if (e is FlutterBluePlusException &&
          e.code == FbpErrorCode.connectionCanceled.index) {
        // ignore connections canceled by the user
      } else {
        Snackbar.show(
          ABC.c,
          prettyException("Connect Error:", e),
          success: false,
        );
      }
    }
  }

  Future onCancelPressed() async {
    try {
      await device.disconnectAndUpdateStream(queue: false);
      Snackbar.show(ABC.c, "Cancel: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Cancel Error:", e), success: false);
    }
  }

  Future onDisconnectPressed() async {
    try {
      await device.disconnectAndUpdateStream();
      Snackbar.show(ABC.c, "Disconnect: Success", success: true);
    } catch (e) {
      Snackbar.show(
        ABC.c,
        prettyException("Disconnect Error:", e),
        success: false,
      );
    }
  }

  Future onDiscoverServicesPressed() async {
    isDiscoveringServices = true;
    emit(DeviceBluetooth1(DateTime.now()));

    try {
      services = await device.discoverServices();
      // Initialize targetCharacteristic
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            PrinterHelper.targetCharacteristic = characteristic;
            break;
          }
        }
      }
      Snackbar.show(ABC.c, "Discover Services: Success", success: true);
    } catch (e) {
      Snackbar.show(
        ABC.c,
        prettyException("Discover Services Error:", e),
        success: false,
      );
    }

    isDiscoveringServices = false;
    emit(DeviceBluetooth1(DateTime.now()));
  }

  Future onRequestMtuPressed() async {
    try {
      await device.requestMtu(223, predelay: 0);
      Snackbar.show(ABC.c, "Request Mtu: Success", success: true);
    } catch (e) {
      Snackbar.show(
        ABC.c,
        prettyException("Change Mtu Error:", e),
        success: false,
      );
    }
  }
}
