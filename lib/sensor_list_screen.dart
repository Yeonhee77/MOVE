import 'package:move/model/sensor_data.dart';

import 'controller/device_scanner.dart';
import 'widget/sensor_view.dart';
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
