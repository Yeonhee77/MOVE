import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/controller/device_scanner.dart';
import 'package:move/widget/sensor_view.dart';
import 'package:move/model/sensor_data.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:move/model/sensor_data.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SensorListScreen extends StatefulWidget {

  BluetoothDevice? connectedDevice;

  SensorListScreen(this.connectedDevice);
  @override
  _SensorListScreenState createState() => _SensorListScreenState(connectedDevice);
}

class _SensorListScreenState extends State<SensorListScreen> {
  BluetoothDevice? connectedDevice;
  _SensorListScreenState(this.connectedDevice);

  final SensorList sensorList = new SensorList();

  @override
  void initState() {
    connectedDevice = widget.connectedDevice;
    super.initState();
  }

  // @override
  // void dispose() {
  //   connectedDevice.dispose();
  //   super.dispose();
  // }

  static const String _title = 'Move!';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: StreamBuilder(
          stream: sensorList.sensorData,
          builder: (context, data) {
            if (data.data == null) {
              return Center(
                child: Text("Sensor x"),
              );
            }
            return SensorView(data.data as SensorData);
          },
        ),
      ),
    );
  }
}

class SensorList {
  Timer? _timer;
  StreamController<SensorData> _streamController = new StreamController();
  Stream<SensorData> get sensorData => _streamController.stream;

  SensorList() {
    _subscribeToScanEvents();
    _timer = new Timer.periodic(const Duration(seconds: 5), startScan);
  }

  void startScan(Timer timer) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 1));
  }

  void dispose() {
    _timer!.cancel();
    _streamController.close();
  }

  void _subscribeToScanEvents() {
    FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult scanResult in scanResults) {
        if (scanResult.device.name.contains("Move")) {
          print('Device : ' + scanResult.device.name.toString());
          print('Bluetooth found');
          final double result_value = scanResult.advertisementData.manufacturerData[256]![0]*1.00;
          final SensorData sensorData = new SensorData(
              result: result_value);

          _streamController.add(sensorData);
          print(
              'Value from Arduino :  ${scanResult.advertisementData.manufacturerData}');
          //FlutterBlue.instance.stopScan();
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