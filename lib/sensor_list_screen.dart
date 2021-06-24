import 'package:arduino_ble_sensor/controller/device_scanner.dart';
import 'package:arduino_ble_sensor/widget/sensor_view.dart';
import 'package:flutter/material.dart';

class SensorListScreen extends StatefulWidget {
  @override
  _SensorListScreenState createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen> {
  final DeviceScanner deviceScanner = new DeviceScanner();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    deviceScanner.dispose();
    super.dispose();
  }

  static const String _title = 'Arduino Sensor Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: StreamBuilder(
          stream: deviceScanner.sensorData,
          builder: (context, data) {
            if (data.data == null) {
              return Center(
                child: Text("No sensor found yet"),
              );
            }
            return SensorView(data.data);
          },
        ),
      ),
    );
  }
}
