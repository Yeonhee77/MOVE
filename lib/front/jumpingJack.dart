import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class JumpingJack extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  JumpingJack({this.bluetoothServices});

  @override
  _JumpingJackState createState() => _JumpingJackState();
}

class _JumpingJackState extends State<JumpingJack> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  String gesture = "";
  String gesture_name = "";
  int gesture_num = 0;
  int cnt = 0;
  int set = 0;

  @override
  void dispose(){
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

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
            child:Column(
              children: [
                SizedBox(height: 30),
                Center(
                    child:Column(
                      children: [
                        Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    )
                ),
              ],
            )
        ),
      ],
    );
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
      body: Column(
        children: [
          Container(
            height: 100,
              child: _buildConnectDeviceView()
          ),
          // Text('세트 $set', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          SizedBox(height: 20),
          Text('카운트: $cnt 개', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      )
    );
  }
}
