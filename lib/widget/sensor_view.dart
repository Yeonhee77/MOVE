import 'dart:async';
import 'package:move/model/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorView extends StatefulWidget {
  final SensorData sensorData;
  SensorView(this.sensorData, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SensorViewState();
  }
}

class _SensorViewState extends State<SensorView> {
  String _lastTime = "now";
  Timer? _timeUpdater;
  String result_string = "";

  @override
  void initState() {
    _timeUpdater =
        new Timer.periodic(const Duration(milliseconds: 500), _updateLastTime);
    super.initState();
  }

  @override
  void dispose() {
    _timeUpdater!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Text(
                'result : ${widget.sensorData.result.toStringAsFixed(2)} ',
                  style: TextStyle(fontSize: 30)
          ),
          Text('result_value : ' + calculate(), style: TextStyle(fontSize: 30)
          ),
            ]
    ),
    );
  }

  String calculate () {
    double result_value = widget.sensorData.result;
    String result_string;

    if (result_value == 1.0)
      result_string = "LEFT";
    else
      result_string = "JUMP";

    return result_string;
    //return result_value;
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
