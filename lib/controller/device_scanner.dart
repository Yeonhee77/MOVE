import 'dart:async';

import 'package:arduino_ble_sensor/model/sensor_data.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScanner {
  Timer? _timer;
  StreamController<SensorData> _streamController = new StreamController();
  Stream<SensorData> get sensorData => _streamController.stream;

  DeviceScanner() {
    _subscribeToScanEvents();
    _timer = new Timer.periodic(const Duration(seconds: 10), startScan);
  }

  void startScan(Timer timer) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
  }

  void dispose() {
    _timer!.cancel();
    _streamController.close();
  }

  void _subscribeToScanEvents() {
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        //device name is bluetooth device name (ex. Move! -1FB7)
        if (scanResult.device.name.toString() == "Move! - 1FB7") {
          print('Device : ' + scanResult.device.name.toString());
          print('Bluetooth found');
          final double resultValue = scanResult.advertisementData.manufacturerData[256]
                  ![0] +
              scanResult.advertisementData.manufacturerData[256]![1] * 0.01;
          final SensorData sensorData = new SensorData(
              result: resultValue);

          _streamController.add(sensorData);
          print(
              'Value from Arduino :  ${scanResult.advertisementData.manufacturerData}');
          FlutterBlue.instance.stopScan();
        }
        else {
          print(
              'Nothing found..');
        }

        //print(
            //'${scanResult.device.name} found! mac: ${scanResult.device.id} rssi: ${scanResult.rssi}');
      }
    });
  }
}
