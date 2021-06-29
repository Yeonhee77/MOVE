import 'dart:async';

import 'package:arduino_ble_sensor/model/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorView extends StatefulWidget {
  const SensorView({Key? key, required this.sensorData}) : super(key: key);
  final SensorData sensorData;

  @override
  _SensorViewState createState() => _SensorViewState();
}

class _SensorViewState extends State<SensorView> {
  String _lastTime = "now";
  Timer ? _timeUpdater;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timeUpdater!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/temp.png'),
            title: Text(
                'result : ${widget.sensorData.result.toStringAsFixed(2)} %'),
          ),

        ],
      ),
    );
  }
}