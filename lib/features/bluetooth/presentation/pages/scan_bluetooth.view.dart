import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/bluetooth/snackbar.dart';
import '../../../../core/color_app.dart';
import '../../../../core/widget/appber/appber_without_back.dart';
import '../logic/scan_bluetooth/scan_bluetooth_cubit.dart';
import '../widgets/scan_result_tile.widget.dart';

class ScanBluetoothView extends StatelessWidget {
  const ScanBluetoothView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanBluetoothCubit(),
      child: ScaffoldMessenger(
        key: Snackbar.snackBarKeyB,
        child: Scaffold(
          appBar: AppberWitoutBack(title: "البحث عن اجهزة"),
          floatingActionButton: const ButtonScanBluetoothWidget(),
          body: const BodyScanButtonWidget(),
        ),
      ),
    );
  }
}

class ButtonScanBluetoothWidget extends StatelessWidget {
  const ButtonScanBluetoothWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanBluetoothCubit, ScanBluetoothState>(
      builder: (context, state) {
        if (FlutterBluePlus.isScanningNow) {
          return FloatingActionButton(
            onPressed: context.read<ScanBluetoothCubit>().onStopPressed,
            backgroundColor: AppColors.redOneColor,
            child: const Icon(Icons.stop, color: Colors.white),
          );
        } else {
          return FloatingActionButton(
            backgroundColor: AppColors.mainOneColor,
            onPressed: context.read<ScanBluetoothCubit>().onScanPressed,
            child: const Icon(Iconsax.refresh, color: Colors.white),
          );
        }
      },
    );
  }
}

class BodyScanButtonWidget extends StatelessWidget {
  const BodyScanButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<ScanBluetoothCubit>().onRefresh,
      child: BlocBuilder<ScanBluetoothCubit, ScanBluetoothState>(
        builder: (context, state) {
          final scanBluetoothCubit = context.read<ScanBluetoothCubit>();
          return ListView(
            children:
                scanBluetoothCubit.scanResults
                    .map(
                      (scanResult) => ScanResultTileWidget(
                        result: scanResult,
                        onTap:
                            () => scanBluetoothCubit.onConnectPressed(
                              scanResult.device,
                              context,
                            ),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}
