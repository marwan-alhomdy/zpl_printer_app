import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
  void initState() {
    super.initState();
    _findBondedDevices();
  }

  void _findBondedDevices() async {
    List<BluetoothDevice>? devices = await findBondedDevices();
    setState(() {
      print("================================================");
      print("devices: ${devices?.length}");
      print("================================================");
      this.devices = devices ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: findBondedDevices(),
        builder: (context, snapshot) {
          return ListView(
            children: List.generate(
              devices.length,
              (index) => ListTile(
                title: Text("Device ${snapshot.data?[index].platformName}"),
                subtitle: Text(snapshot.data![index].remoteId.str),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  connectAndDiscover(snapshot.data![index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
