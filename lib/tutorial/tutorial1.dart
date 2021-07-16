import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/squat_page.dart';
//Squat tutorial
class Tutorial1 extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Tutorial1({this.bluetoothServices});

  @override
  _Tutorial1State createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
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
                                    SizedBox(height: 20,),
                                    Text("Stand shoulder-width",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    Text("with toes slightly outward.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_1.png',height: 400,width: 300,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squatstart(bluetoothServices: widget.bluetoothServices)));
                                      },
                                      child: Text('skip'),
                                    ),
                                  ];
                                  break;
                                case 2:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Eyes forward, tighten your abs ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text("and tighten your waist.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_2.png',height: 400,width: 300,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squatstart(bluetoothServices: widget.bluetoothServices)));
                                      },
                                      child: Text('skip'),
                                    ),
                                  ];
                                  break;
                                case 3:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Sit until your knees are level",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text("with your thighs, keeping them from moving ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text("forward beyond your toes.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Image.asset('squat_1.png',height: 400,width: 300,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squatstart(bluetoothServices: widget.bluetoothServices)));
                                      },
                                      child: Text('skip'),
                                    ),
                                  ];
                                  break;
                                case 4:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Stand up with your thighs tightened",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text("feeling like you're pushing with your heels.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_2.png',height: 400,width: 300,),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squatstart(bluetoothServices: widget.bluetoothServices)));
                                      },
                                      child: Text('skip'),
                                    ),
                                  ];
                                  break;
                                case 5:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back))
                                    ],),
                                    SizedBox(height: 120,),
                                    Text("Please shake the microchip once.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    SizedBox(height: 20,),
                                    Image.asset('bluewhite.png'),
                                    SizedBox(height: 30,),
                                    Text("moving value:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squatstart(bluetoothServices: widget.bluetoothServices)));
                                      },
                                      child: Text('Start'),
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
                  image: AssetImage('tutorial2_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}
