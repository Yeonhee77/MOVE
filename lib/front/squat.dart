import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/squat_page.dart';
import 'package:move/tutorial/tutorial1.dart';

class Squat extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Squat({this.bluetoothServices});

  @override
  _SquatState createState() => _SquatState();
}

class _SquatState extends State<Squat> {
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
                        SizedBox(height: 120,),
                        Text("마이크로 칩을 어깨에 부착해주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(height: 20,),
                        Image.asset('bluewhite.png'),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial1(bluetoothServices: widget.bluetoothServices)));
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
      appBar: AppBar(
        title: Text('Squat'),
      ),
      body: Center(
          child: _buildConnectDeviceView(),
      ),
    );
  }
}
