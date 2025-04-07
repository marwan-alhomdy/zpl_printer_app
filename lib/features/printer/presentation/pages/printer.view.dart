import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:zpl_printer_app/core/color_app.dart';

import '../../../../helper/printer_helper.dart';

class PrinterView extends StatelessWidget {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: IconButton(
          onPressed: print,
          iconSize: 40,
          color: AppColors.mainOneColor,
          icon: Icon(Iconsax.printer_copy),
        ),
      ),
    );
  }

  void print() async {
    try {
      final zplPrinter = ZplPrinter();
      final zpl = await zplPrinter.generateInvoice();
      PrinterHelper.printZpl(zpl);
    } catch (e) {
      log(e.toString());
    }
  }
}

class ZplPrinter {
  int yPosition = 60;
  Future<String> generateInvoice() async {
    final zplString = '''

^CF0,40
^FO140,$yPosition^FD${"Test Header"}^FS
^CF0,25

^FO120,${yPosition += 30}^FDVAT Number: ${"VN123456789"}^FS
^FO140,${yPosition += 30}^FDCRN Number: ${"CRN123456789"}^FS
^FO20,${yPosition += 30}^GB576,2,2^FS

^CF0,30
^FO20,${yPosition += 20}^FDWareHouse^FS
^CF0,25
^FO20,${yPosition += 40}^FDWarehouse Name: ${"test description"}^FS
^FO20,${yPosition += 30}^FDWarehouse ID: ${"WH1234"}^FS
^FO20,${yPosition += 30}^FDSalesman Name: ${"marwan moh"}^FS
^FO20,${yPosition += 30}^FDDate: ${DateTime.now()}^FS
^FO20,${yPosition += 30}^GB576,2,2^FS


^CF0,25
^FO20,${yPosition += 20}^FDStock Detalis :^FS
^FO20,${yPosition += 40}^GB576,2,2^FS

^CF0,20
^FO20,${yPosition += 10}^FDDescription^FS
^FO250,$yPosition^FDCode^FS
^FO350,$yPosition^FDUOM^FS
^FO450,$yPosition^FDQTY^FS


${getProducts()}  // تمرير yPosition المحدث بعد الطباعة

^FO20,${yPosition += 50}^GB576,2,2^FS


^CF0,20
^FO20,${yPosition += 10}^FDTotal Quantity :^FS
^FO450,$yPosition^FD${20}^FS


^FO20,${yPosition += 30}^GB576,2,2^FS


^FO20,${yPosition += 60}^FDCustomer/Salesman Sig: ---^FS
^FO20,${yPosition += 30}^FDCustomer Service: ---^FS

''';
    yPosition += 100;
    return '''
^XA
^LH0,0
^LL$yPosition
^PW576
 
 $zplString

^XZ
''';
  }

  String getProducts() {
    String productsZpl = "";
    for (int i = 1; i < 3; i++) {
      productsZpl += '''
^FO20,${yPosition += 30}^GB576,1,1^FS
^CF0,20
^FO20,${yPosition += 10}^FB200,2,0,L,0^FD${"item $i"}^FS  
^FO250,$yPosition^FB340,2,0,L,0^FD${"$i -"}^FS
^FO350,$yPosition^FB440,2,0,L,0^FD${"--"}^FS
^FO450,$yPosition^FB575,2,0,L,0^FD${"10"}^FS
''';

      yPosition += 40; // تحريك الإحداثيات العمودية بعد كل منتج
    }
    // إرجاع قيمة yPosition المحدثة بعد طباعة جميع المنتجات
    return productsZpl;
  }
}
