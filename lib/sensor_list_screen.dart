import 'package:move/controller/device_scanner.dart';
import 'package:move/widget/sensor_view.dart';
import 'package:move/model/sensor_data.dart';
import 'package:flutter/material.dart';
int flag = 0;
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
            // if (data.data == null) {
            //   return Center(
            //     child: Text("Sensor x"),
            //   );
            // }
            // else {
            //   flag ++;
              print("success sensorview");
              return SensorView(data.data as SensorData);
            // }
            },
        ),
      ),
    );
  }
}
