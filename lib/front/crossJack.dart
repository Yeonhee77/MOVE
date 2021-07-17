import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/tutorial/tutorial3.dart';

class Crossjack extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Crossjack({this.bluetoothServices});

  @override
  _CrossjackState createState() => _CrossjackState();
}

class _CrossjackState extends State<Crossjack> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;

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
                        Row(children: [
                          IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                        ],),
                        SizedBox(height: 120,),
                        Text("마이크로 칩을 손목에 부착해주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial3(bluetoothServices: widget.bluetoothServices)));
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

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildConnectDeviceView(),
      ),
    );
  }
}