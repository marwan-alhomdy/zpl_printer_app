import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/bluetooth/snackbar.dart';
import '../../../../core/color_app.dart';
import '../../../../core/widget/appber/appber_without_back.dart';

class BluetoothOffView extends StatelessWidget {
  const BluetoothOffView({super.key, this.adapterState});

  final BluetoothAdapterState? adapterState;

  String get _getdapterState {
    String? state = adapterState?.toString().split(".").last;
    return 'Bluetooth Adapter is ${state ?? 'not available'}';
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyA,
      child: Scaffold(
        appBar: AppberWitoutBack(title: "صلاحيات البلوتوث"),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: AppBoxDecoration.containerDecoration,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ).add(const EdgeInsets.only(bottom: 40)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 100,
                color: AppColors.mainOneColor,
              ),
              Text(
                _getdapterState,
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                  color: AppColors.mainOneColor,
                ),
              ),
              Visibility(
                visible: Platform.isAndroid,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _turnOn,
                    child: const Text('TURN ON'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _turnOn() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      Snackbar.show(
        ABC.a,
        prettyException("Error Turning On:", e),
        success: false,
      );
    }
  }
}
