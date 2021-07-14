import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Jumpingstart extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Jumpingstart({this.bluetoothServices});

  @override
  _JumpingstartState createState() => _JumpingstartState();
}

class _JumpingstartState extends State<Jumpingstart> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int gesture_num2 = 0;
  int count =0;
  bool flag = false;
  List<Widget>? tutorial;
  final Stream<int> _bids = (() async* {
    yield 0;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield 1;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield 2;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield 3;
    await Future<void>.delayed(const Duration(seconds: 1));
    yield 4;
  })();

  @override
  void dispose(){
    // _streamController.close();
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
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
          setnum(characteristic);
        }
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
        Container(
            child:Column(
              children: [
                SizedBox(height: 30,),
                Center(
                    child:Column(
                      children: [
                        StreamBuilder<int>(
                          stream: _bids,
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (snapshot.hasError) {
                              tutorial = <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                                ),
                              ];
                            } else {
                              switch (snapshot.data) {
                                case 0:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 120,),
                                    Text("Start",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  ];
                                  break;
                                case 1:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 120,),
                                    Text("3",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  ];
                                  break;
                                case 2:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 120,),
                                    Text("2",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                  ];
                                  break;
                                case 3:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 120,),
                                    Text("1",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                  ];
                                  break;
                                case 4:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Text("자 이제,",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    SizedBox(height: 20,),
                                    Text("Start", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                                    Center(child:
                                    Image.asset('squat_3.gif',height: 400,width: 300,),),
                                    Text("값: " + gesture_num.toString()),
                                    Text("횟수: " + count.toString()),
                                    flag? Text("Correct"): Text("Wrong"),
                                  ];
                                  break;
                              }
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: tutorial!,
                            );
                          },
                        ),
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
        gesture_num2 = int.parse(gesture[1]);
        if(gesture_num == 2) {
          flag = true;
        }
        else if(gesture_num == 1) {
          flag = false;
        }
      });
    },);
    if(gesture_num2 == 1 || gesture_num2 == 2) {
      gesture_num2 = 0;
      count += 1;
    }
    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _buildConnectDeviceView()
      ),
    );
  }
}
