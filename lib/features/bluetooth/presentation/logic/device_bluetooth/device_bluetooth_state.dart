part of 'device_bluetooth_cubit.dart';

abstract class DeviceBluetoothState extends Equatable {
  const DeviceBluetoothState();
}

class DeviceBluetoothInitial extends DeviceBluetoothState {
  @override
  List<Object> get props => [];
}

class DeviceBluetooth1 extends DeviceBluetoothState {
  final DateTime dateTime;
  const DeviceBluetooth1(this.dateTime);
  @override
  List<Object> get props => [dateTime];
}
