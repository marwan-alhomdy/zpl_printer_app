import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../../core/bluetooth/snackbar.dart';
import '../../../../core/color_app.dart';
import '../../../../core/text_style.dart';
import '../../../../core/widget/appber/appber_without_back.dart';
import '../../../../core/widget/button.widget.dart';
import '../logic/device_bluetooth/device_bluetooth_cubit.dart';
import '../widgets/characteristic_tile.widget.dart';
import '../widgets/descriptor_tile.widget.dart';
import '../widgets/service_tile.widget.dart';

class DeviceBluetoothView extends StatelessWidget {
  const DeviceBluetoothView({super.key, required this.device});
  final BluetoothDevice device;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceBluetoothCubit(device: device),
      child: DeviceBluetoothView2(device: device),
    );
  }
}

class DeviceBluetoothView2 extends StatefulWidget {
  const DeviceBluetoothView2({super.key, required this.device});
  final BluetoothDevice device;
  @override
  State<DeviceBluetoothView2> createState() => _DeviceBluetoothViewState();
}

class _DeviceBluetoothViewState extends State<DeviceBluetoothView2> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyC,
      child: Scaffold(
        appBar: AppberWitoutBack(title: widget.device.platformName),
        body: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(0),
          decoration: AppBoxDecoration.containerDecoration,
          width: MediaQuery.sizeOf(context).width * 0.90,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const BuildConnectButtonWidget(),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  '${widget.device.remoteId}',
                  style: AppTextStyles.getMediumStyle(color: AppColors.orange),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const BuildRssiTileWidget(),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Device is ${context.read<DeviceBluetoothCubit>().connectionState.toString().split('.')[1]}.',
                          style: AppTextStyles.getMediumStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const BuildMtuTileWidget(),
                const Divider(),
                const BuildGetServicesWidget(),
                const BuildServiceTilesWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildConnectButtonWidget extends StatelessWidget {
  const BuildConnectButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceBluetoothCubit = context.read<DeviceBluetoothCubit>();
    return BlocBuilder<DeviceBluetoothCubit, DeviceBluetoothState>(
      builder: (context, state) {
        return Row(
          children: [
            if (deviceBluetoothCubit.isConnecting ||
                deviceBluetoothCubit.isDisconnecting)
              Container(
                constraints: const BoxConstraints(maxWidth: 50, maxHeight: 50),
                padding: const EdgeInsets.all(14.0),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: AppColors.mainOneColor,
                  color: Colors.white,
                ),
              ),
            ButtonWidget(
              onTap:
                  deviceBluetoothCubit.isConnecting
                      ? deviceBluetoothCubit.onCancelPressed
                      : (deviceBluetoothCubit.isConnected
                          ? deviceBluetoothCubit.onDisconnectPressed
                          : deviceBluetoothCubit.onConnectPressed),
              text:
                  deviceBluetoothCubit.isConnecting
                      ? "CANCEL"
                      : (deviceBluetoothCubit.isConnected
                          ? "DISCONNECT"
                          : "CONNECT"),
            ),
          ],
        );
      },
    );
  }
}

class BuildRssiTileWidget extends StatelessWidget {
  const BuildRssiTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBluetoothCubit, DeviceBluetoothState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context.read<DeviceBluetoothCubit>().isConnected
                ? const Icon(
                  Icons.bluetooth_connected,
                  color: AppColors.greenOneColor,
                )
                : const Icon(
                  Icons.bluetooth_disabled,
                  color: AppColors.redOneColor,
                ),
            Text(
              ((context.read<DeviceBluetoothCubit>().isConnected &&
                      context.read<DeviceBluetoothCubit>().rssi != null)
                  ? '${context.read<DeviceBluetoothCubit>().rssi!} dBm'
                  : ''),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}

class BuildMtuTileWidget extends StatelessWidget {
  const BuildMtuTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBluetoothCubit, DeviceBluetoothState>(
      builder: (context, state) {
        return ListTile(
          title: const Text('MTU Size'),
          subtitle: Text(
            '${context.read<DeviceBluetoothCubit>().mtuSize} bytes',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: context.read<DeviceBluetoothCubit>().onRequestMtuPressed,
          ),
        );
      },
    );
  }
}

class BuildGetServicesWidget extends StatelessWidget {
  const BuildGetServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBluetoothCubit, DeviceBluetoothState>(
      builder: (context, state) {
        return IndexedStack(
          index:
              (context.read<DeviceBluetoothCubit>().isDiscoveringServices)
                  ? 1
                  : 0,
          children: <Widget>[
            ButtonWidget(
              text: "ربط الخدمات",
              onTap:
                  context
                      .read<DeviceBluetoothCubit>()
                      .onDiscoverServicesPressed,
            ),
            const IconButton(
              icon: SizedBox(
                width: 18.0,
                height: 18.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                ),
              ),
              onPressed: null,
            ),
          ],
        );
      },
    );
  }
}

class BuildServiceTilesWidget extends StatelessWidget {
  const BuildServiceTilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBluetoothCubit, DeviceBluetoothState>(
      builder: (context, state) {
        return Column(
          children:
              context
                  .read<DeviceBluetoothCubit>()
                  .services
                  .map(
                    (s) => ServiceTileWidget(
                      service: s,
                      characteristicTiles:
                          s.characteristics
                              .map(
                                (c) => CharacteristicTileWidget(
                                  characteristic: c,
                                  descriptorTiles:
                                      c.descriptors
                                          .map(
                                            (d) => DescriptorTileWidget(
                                              descriptor: d,
                                            ),
                                          )
                                          .toList(),
                                ),
                              )
                              .toList(),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
