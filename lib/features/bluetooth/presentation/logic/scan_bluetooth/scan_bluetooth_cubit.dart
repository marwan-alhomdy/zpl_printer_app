import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:zpl_printer_app/core/bluetooth/extra.dart';

import '../../../../../core/bluetooth/snackbar.dart';
import '../../pages/device_bluetooth.view.dart';

part 'scan_bluetooth_state.dart';

class ScanBluetoothCubit extends Cubit<ScanBluetoothState> {
  ScanBluetoothCubit() : super(ScanBluetoothInitial()) {
    initScanBluetooth();
  }

  List<ScanResult> scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  void initScanBluetooth() {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        scanResults = results;
        emit(ScanBluetooth1(DateTime.now()));
      },
      onError: (e) {
        Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
      },
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      emit(ScanBluetooth1(DateTime.now()));
    });
  }

  @override
  Future<void> close() async {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.close();
  }

  Future onScanPressed() async {
    try {
      log("======================");
      if (Platform.isAndroid) {
        await FlutterBluePlus.startScan(
          androidUsesFineLocation: true,
          androidScanMode: AndroidScanMode.lowPower,
          withServices: [Guid("180D")],
          withNames: ["Bluno"],
          timeout: const Duration(seconds: 15),
        );
      } else {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      }
    } catch (e) {
      Snackbar.show(
        ABC.b,
        prettyException("Start Scan Error:", e),
        success: false,
      );
    }
    emit(ScanBluetooth1(DateTime.now()));
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(
        ABC.b,
        prettyException("Stop Scan Error:", e),
        success: false,
      );
    }
  }

  void onConnectPressed(BluetoothDevice device, BuildContext context) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(
        ABC.c,
        prettyException("Connect Error:", e),
        success: false,
      );
    });
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => DeviceBluetoothView(device: device),
      settings: const RouteSettings(name: '/DeviceScreen'),
    );
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      log("======================");

      if (Platform.isAndroid) {
        FlutterBluePlus.startScan(
          androidUsesFineLocation: true,
          timeout: const Duration(seconds: 15),
        );
      } else {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      }
    }
    emit(ScanBluetooth1(DateTime.now()));
    return Future.delayed(const Duration(milliseconds: 500));
  }
}
