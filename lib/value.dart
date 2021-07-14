import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CounterPage extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  CounterPage({this.bluetoothServices});

  // ignore: non_constant_identifier_names
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final StreamController<int> _streamController = StreamController<int>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  String gesture = "";
  String gesture_name = "";
  int gesture_num = 0;

  @override
  void dispose(){
    _streamController.close();
    super.dispose();
  }

  void _gesture() {
    for (BluetoothService service in widget.bluetoothServices!) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read &&
            characteristic.properties.notify) {
          setnum(characteristic);
        }
      }
    }
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
        print('GESTURE RECEIVED - ' + gesture);
        switch(gesture_num){
          case 1: gesture_name = "LEFT"; break;
          case 2: gesture_name = "RIGHT"; break;
          case 3: gesture_name = "UP"; break;
          case 4: gesture_name = "DOWN"; break;
        }
      });
    });

    await characteristic.read();
    sub.cancel();
  }


  @override
  Widget build(BuildContext context) {
    _gesture();
    return Scaffold(
      appBar: AppBar(title: Text('BLE Test Page')),
      body: Center(
        child:Column(
      children: [
      SizedBox(height: 30,),
      Center(
          child:Column(
            children: [
              Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          )
      ),
      ],
    ),
      ),
    );
  }
}