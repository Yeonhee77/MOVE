import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';

class Boxing extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Boxing({this.bluetoothServices});

  @override
  _BoxingStartState createState() => _BoxingStartState();
}

class _BoxingStartState extends State<BoxingStart> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);

  List<String> random = ['Punch', 'Uppercut'];
  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int score = 0;

  @override
  void dispose(){
    super.dispose();
  }

  ListView _buildConnectDeviceView() {
    for (BluetoothService service in widget.bluetoothServices!) {

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
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
                SizedBox(height: 30,),
                Center(
                    child:Column(
                      children: [
                        Row(children: [
                          IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                        ],),
                        SizedBox(height: 120,),
                        Text("마이크로 칩을 어깨에 부착해주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(height: 20,),
                        Image.asset('shoulder.png',height: 200,),
                        //Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        // Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            SizedBox(width: 270,),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                // foreground
                              ),
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial1(bluetoothServices: widget.bluetoothServices)));
                              },
                              child: Text('next'),
                            ),
                          ],
                        )
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
      });
    });

    if(ran_gesture == 'Punch') {
      if(gesture_num == 1) {
        gesture_num = 0;
        score += 1;
      }
    }else if(ran_gesture == 'Uppercut') {
      if(gesture_num == 2) {
        gesture_num = 0;
        score += 1;
      }
    }

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Boxing'),
        ),
        body: Column(
          children: [
            Container(
                height: 100,
                child: _buildConnectDeviceView()
            ),
            SizedBox(height: 40),
            StreamBuilder<int>(
                stream: stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  ran_gesture = random[Random().nextInt(2)];
                  return Text(ran_gesture);
                }
            ),
            SizedBox(height: 20),
            Text('카운트: $score 개', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        )
    );
  }
}


class BoxingStart extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  BoxingStart({this.bluetoothServices});

  @override
  _BoxingStartState createState() => _BoxingStartState();
}

class _BoxingState extends State<BoxingStart> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);

  List<String> random = ['Punch', 'Uppercut'];
  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int score = 0;

  @override
  void dispose(){
    super.dispose();
  }

  ListView _buildConnectDeviceView() {
    for (BluetoothService service in widget.bluetoothServices!) {

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
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
                SizedBox(height: 30,),
                Center(
                    child:Column(
                      children: [
                        Row(children: [
                          IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                        ],),
                        SizedBox(height: 120,),
                        Text("마이크로 칩을 어깨에 부착해주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(height: 20,),
                        Image.asset('shoulder.png',height: 200,),
                        //Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        // Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            SizedBox(width: 270,),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                // foreground
                              ),
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial1(bluetoothServices: widget.bluetoothServices)));
                              },
                              child: Text('next'),
                            ),
                          ],
                        )
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
      });
    });

    if(ran_gesture == 'Punch') {
      if(gesture_num == 1) {
        gesture_num = 0;
        score += 1;
      }
    }else if(ran_gesture == 'Uppercut') {
      if(gesture_num == 2) {
        gesture_num = 0;
        score += 1;
      }
    }

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Boxing'),
        ),
        body: Column(
          children: [
            Container(
                height: 100,
                child: _buildConnectDeviceView()
            ),
            SizedBox(height: 40),
            StreamBuilder<int>(
                stream: stream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  ran_gesture = random[Random().nextInt(2)];
                  return Text(ran_gesture);
                }
            ),
            SizedBox(height: 20),
            Text('카운트: $score 개', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        )
    );
  }
}