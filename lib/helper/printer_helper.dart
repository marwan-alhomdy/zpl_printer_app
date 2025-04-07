import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PrinterHelper {
  static BluetoothCharacteristic? targetCharacteristic;

  static void printZpl(String zplData) async {
    if (targetCharacteristic == null) return;

    int chunkSize = 182; // الحد الأقصى للحجم المسموح به لكل جزء
    List<int> bytes = zplData.codeUnits;

    for (int i = 0; i < bytes.length; i += chunkSize) {
      int end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      List<int> chunk = bytes.sublist(i, end);
      await targetCharacteristic?.write(chunk, withoutResponse: true);
    }

    // إرسال أمر ^XZ بشكل منفصل للتأكد من إنهاء الطباعة بشكل صحيح
    await targetCharacteristic?.write('^XZ'.codeUnits, withoutResponse: true);
  }
}
