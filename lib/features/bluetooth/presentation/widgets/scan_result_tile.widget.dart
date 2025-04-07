import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/color_app.dart';

class ScanResultTileWidget extends StatefulWidget {
  const ScanResultTileWidget({super.key, required this.result, this.onTap});

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTileWidget> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTileWidget> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
  _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStateSubscription = widget.result.device.connectionState.listen((
      state,
    ) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: AppBoxDecoration.containerDecoration,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Row(
          children: [
            Text(
              widget.result.rssi.toString(),
              style: const TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _BuildTitleDeviceWidget(result: widget.result)),
            _BuildConnectButtonWidget(
              isConnected: isConnected,
              onPressed:
                  (widget.result.advertisementData.connectable)
                      ? widget.onTap
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildTitleDeviceWidget extends StatelessWidget {
  const _BuildTitleDeviceWidget({required this.result});
  final ScanResult result;
  @override
  Widget build(BuildContext context) {
    if (result.device.platformName.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.device.platformName, overflow: TextOverflow.ellipsis),
          Text(
            result.device.remoteId.str,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return Text(result.device.remoteId.str);
    }
  }
}

class _BuildConnectButtonWidget extends StatelessWidget {
  const _BuildConnectButtonWidget({
    required this.isConnected,
    required this.onPressed,
  });
  final bool isConnected;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isConnected ? AppColors.greenOneColor : AppColors.mainOneColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(isConnected ? 'OPEN' : 'CONNECT'),
    );
  }
}
