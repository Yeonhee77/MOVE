import 'sensor_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetooth_off_screen.dart';

int sec = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return SensorListScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

// final t1 = FlutterBlue.instance.scanResults.first.toString();
// final t2 = FlutterBlue.instance.connectedDevices.toString();
// print('t1: $t1');
// print('t2: $t2');
