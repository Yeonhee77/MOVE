import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/jumpingjack_page.dart';

//Jumpingjack tutorial
class Tutorial2 extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Tutorial2({this.bluetoothServices});

  @override
  _Tutorial2State createState() => _Tutorial2State();
}

class _Tutorial2State extends State<Tutorial2> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  List<Widget>? tutorial;
  Stream<int> _bids = (() async* {
    yield 1;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 2;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 3;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 4;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 5;
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
                                case 1:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text("곧게 서주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                        ],
                                      ),
                                    ),
                                    Image.asset('jumping_1.png',height: 400,width: 300,),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingstart(bluetoothServices: widget.bluetoothServices)));
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 2:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text("양팔을 90도 벌리고",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                          Text("양다리를 어깨너비만큼 벌려주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Image.asset('jumping_2.png',height: 400,width: 300,),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingstart(bluetoothServices: widget.bluetoothServices)));
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 3:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text("벌린 팔과 다리를 모아",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                          Text("차렷자세로 돌아옵니다.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Image.asset('jumping_3.png',height: 400,width: 300,),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingstart(bluetoothServices: widget.bluetoothServices)));
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 4:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Container(
                                      height: 70,
                                      child: Column(
                                        children: [
                                          Text("다시 다리를 어깨 너비만큼 벌리고",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                          Text("양팔은 머리위로 손바닥을 마주봅니다.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Image.asset('jumping_4.png',height: 400,width: 300,),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingstart(bluetoothServices: widget.bluetoothServices)));
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 5:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    Container(height: 70,
                                      child:
                                    Column(
                                      children: [
                                        Text("차렷자세로 돌아옵니다.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                        Text("이제 Start버튼을 눌러주세요.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                      ],
                                    ),
                                    ),
                                    Image.asset('jumping_5.png',height: 400,width: 300,),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingstart(bluetoothServices: widget.bluetoothServices)));
                                          },
                                          child: Image.asset('start.png',height: 30,),
                                        ),
                                      ],
                                    ),
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
      });
    });

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('tutorial_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}
