import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth_off_view.dart';
import 'scan_bluetooth.view.dart';

class BluetoothView extends StatefulWidget {
  const BluetoothView({super.key});

  @override
  State<BluetoothView> createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final BluetoothAdapterStateObserver _observer =
      BluetoothAdapterStateObserver();

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((
      state,
    ) {
      _adapterState = state;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      observers: [_observer],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) {
            if (_adapterState == BluetoothAdapterState.on) {
              return const ScanBluetoothView();
            } else {
              return BluetoothOffView(adapterState: _adapterState);
            }
          },
        );
      },
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((
        state,
      ) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
