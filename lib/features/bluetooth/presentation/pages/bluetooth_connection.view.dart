import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/color_app.dart';
import '../../../../helper/bluetooth_helper.dart';

class BluetoothConnectionView extends StatefulWidget {
  const BluetoothConnectionView({super.key});

  @override
  State<BluetoothConnectionView> createState() =>
      _BluetoothConnectionViewState();
}

class _BluetoothConnectionViewState extends State<BluetoothConnectionView> {
  List<BluetoothDevice> devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: findBondedDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data == null) {
            return const Center(child: Text("No devices found"));
          } else if ((snapshot.data ?? []).isEmpty) {
            return const Center(child: Text("No devices found"));
          } else if (snapshot.hasData) {
            return ListView(
              children: List.generate(
                snapshot.data?.length ?? 0,
                (index) =>
                    _CardBluetoothDeviceWidget(device: snapshot.data?[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CardBluetoothDeviceWidget extends StatefulWidget {
  const _CardBluetoothDeviceWidget({required this.device});
  final BluetoothDevice? device;
  @override
  State<_CardBluetoothDeviceWidget> createState() =>
      _CardBluetoothDeviceWidgetState();
}

class _CardBluetoothDeviceWidgetState
    extends State<_CardBluetoothDeviceWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Iconsax.bluetooth,
        color: widget.device?.isConnected ?? false ? Colors.green : Colors.blue,
      ),

      title: Text("Device ${widget.device?.platformName}"),
      subtitle: Text(widget.device?.remoteId.str ?? ""),
      trailing:
          isLoading
              ? const CircularProgressIndicator()
              : _BuildConnectButtonWidget(
                isConnected: widget.device?.isConnected ?? false,
                onPressed: () => _onConnectPressed(widget.device!),
              ),
    );
  }

  void _onConnectPressed(BluetoothDevice device) async {
    setState(() => isLoading = true);
    await connectAndDiscover(device);
    setState(() => isLoading = false);
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
            isConnected ? AppColors.mainTwoColor : AppColors.mainOneColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(isConnected ? '✅' : 'CONNECT'),
    );
  }
}
