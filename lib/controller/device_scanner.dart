import 'dart:async';
import 'dart:developer';
import 'package:move/model/sensor_data.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScanner {
  StreamController<SensorData> _streamController = new StreamController();
  Stream<SensorData> get sensorData => _streamController.stream;

  DeviceScanner() {
    FlutterBlue.instance.startScan();
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.name.toString() == "YJ!") {
          print('Device : ' + scanResult.device.name.toString());
          print("value: ");
          print(scanResult.advertisementData.manufacturerData);
          SensorData sensorData = new SensorData(
              result: scanResult.advertisementData.manufacturerData[256]![0]*1.00);
          _streamController.add(sensorData);
            FlutterBlue.instance.stopScan();
        }
      }
    });
    //_subscribeToScanEvents();
  }


  void dispose() {
    _streamController.close();
  }

  void _subscribeToScanEvents() {
    FlutterBlue.instance.startScan(timeout: Duration(milliseconds: 100));
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.name.toString() == "YJ!") {
          print('Device : ' + scanResult.device.name.toString());
          print("value: ");
          print(scanResult.advertisementData.manufacturerData);
          final SensorData sensorData = new SensorData(
              result: scanResult.advertisementData.manufacturerData[256]![0]*1.00);
          _streamController.add(sensorData);
//          FlutterBlue.instance.stopScan();
        }
      }
    });
  }
}
