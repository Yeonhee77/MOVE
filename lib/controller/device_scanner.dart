import 'dart:async';
import 'package:move/model/sensor_data.dart';
import 'package:flutter_blue/flutter_blue.dart';

int flag = 0;
class DeviceScanner {
  Timer? _timer;
  StreamController<SensorData> _streamController = new StreamController();
  Stream<SensorData> get sensorData => _streamController.stream;

  DeviceScanner() {
    if(flag ==0) {
      FlutterBlue.instance.startScan();
      flag ++;
    }
    _subscribeToScanEvents();
    //_timer = new Timer.periodic(const Duration(seconds: 5), startScan);
  }

  // void startScan(Timer timer) {
  //   FlutterBlue.instance.startScan();
  // }

  void dispose() {
    _timer!.cancel();
    _streamController.close();
  }

  void _subscribeToScanEvents() {
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.name.toString() == "YJ!") {
          print('Device : ' + scanResult.device.name.toString());
          print('Bluetooth found');
          final double resultValue = scanResult.advertisementData.manufacturerData[256]![0]*1.00;
          final SensorData sensorData = new SensorData(
              result: resultValue);
          _streamController.add(sensorData);
          //FlutterBlue.instance.stopScan();
        }
      }
    });
  }
}
