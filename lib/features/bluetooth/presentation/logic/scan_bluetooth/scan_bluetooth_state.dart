part of 'scan_bluetooth_cubit.dart';

abstract class ScanBluetoothState extends Equatable {
  const ScanBluetoothState();
}

class ScanBluetoothInitial extends ScanBluetoothState {
  @override
  List<Object> get props => [];
}

class ScanBluetooth1 extends ScanBluetoothState {
  final DateTime dateTime;
  const ScanBluetooth1(this.dateTime);
  @override
  List<Object> get props => [dateTime];
}
