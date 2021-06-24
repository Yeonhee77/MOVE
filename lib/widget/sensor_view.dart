import 'dart:async';

import 'package:arduino_ble_sensor/model/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorView extends StatefulWidget {
  final SensorData sensorData;
  SensorView(this.sensorData, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SensorViewState();
  }
}

class _SensorViewState extends State<SensorView> {
  String _lastTime = "now";
  Timer _timeUpdater;

  @override
  void initState() {
    _timeUpdater =
        new Timer.periodic(const Duration(seconds: 1), _updateLastTime);
    super.initState();
  }

  @override
  void dispose() {
    _timeUpdater.cancel();
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
                'Left : ${widget.sensorData.left.toStringAsFixed(2)} %'),
          ),
          ListTile(
            leading: Image.asset('assets/images/humm.png'),
            title: Text(
                'Jump : ${widget.sensorData.jump.toStringAsFixed(2)} %'),
          ),

        ],
      ),
    );
  }

  void _updateLastTime(Timer timer) {
    setState(() {
      _lastTime = DateTime.now()
          .difference(widget.sensorData.lastTime)
          .inSeconds
          .toString();
    });
  }
}
