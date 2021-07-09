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
  int gesture_num = 0;

  @override
  void dispose(){
    _streamController.close();
    super.dispose();
  }

  ListView _buildConnectDeviceView() {
    // ignore: deprecated_member_use
    List<Container> containers = [];
    for (BluetoothService service in widget.bluetoothServices!) {
      // ignore: deprecated_member_use
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
          // await characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
          setnum(characteristic);
        }
        // characteristicsWidget.add(
        //   Align(
        //     alignment: Alignment.centerLeft,
        //     child: Column(
        //       children: <Widget>[
        //         Row(
        //           children: <Widget>[
        //             ..._buildReadWriteNotifyButton(characteristic),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Center(child:Text("블루투스 연결설정")),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        //Center(child:containers[2]),
        Container(
            child:Column(
              children: [
                SizedBox(height: 30,),
                Center(
                    child:Column(
                      children: [
                        Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        // Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    )
                ),
              ],
            )
        ),
      ],
    );
  }

  Future<List<ButtonTheme>> _buildReadWriteNotifyButton(BluetoothCharacteristic characteristic) async {
    // ignore: deprecated_member_use
    List<ButtonTheme> buttons = [];
    if (characteristic.properties.notify) {
      characteristic.value.listen((value) {
        readValues[characteristic.uuid] = value;
      });
      await characteristic.setNotifyValue(true);
    }
    if (characteristic.properties.read && characteristic.properties.notify) {
      setnum(characteristic);
    }
    return buttons;
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
        // switch(gesture_num){
        //   case 1: gesture_name = "LEFT"; break;
        //   case 2: gesture_name = "RIGHT"; break;
        //   case 3: gesture_name = "UP"; break;
        //   case 4: gesture_name = "DOWN"; break;
        // }
      });
    });

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        child: _buildConnectDeviceView(),
        // child: StreamBuilder<int>(
        //     stream: _streamController.stream,
        //     initialData: 0,
        //     builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        //       return Text('You hit me: ' + {snapshot.data}.toString());
        //     }
        // ),
      ),
    );
  }
}