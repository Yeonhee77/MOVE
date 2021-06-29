import 'package:arduino_ble_sensor/controller/device_scanner.dart';
import 'package:arduino_ble_sensor/widget/sensor_view.dart';
import 'package:flutter/material.dart';

import 'model/sensor_data.dart';


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

  static const String _title = 'Move!';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: StreamBuilder(
          stream: deviceScanner.sensorData,
          builder: (c, snapshot) {
            final sensorData = snapshot.data;
            if (sensorData == null) {
              return Center(
                child: Text("Sensor x"),
              );
            }
            else {
              return SensorView(sensorData: sensorData as SensorData,);
            }
          },
        ),
      ),
    );
  }
}
