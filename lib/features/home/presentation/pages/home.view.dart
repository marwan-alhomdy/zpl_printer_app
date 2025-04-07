import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/widget/appber/appber_without_back.dart';
import '../../../bluetooth/presentation/pages/bluetooth_view.dart';
import '../../../printer/presentation/pages/printer.view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppberWitoutBack(title: ""),
      body: Column(
        children: [
          ListTile(
            title: Text("Bluetooth"),
            leading: Icon(Iconsax.bluetooth_copy),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BluetoothView()),
              );
            },
          ),
          ListTile(
            title: Text("Printer"),
            leading: Icon(Iconsax.printer_copy),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PrinterView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
