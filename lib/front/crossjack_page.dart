import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:move/front/home.dart';

class Crossjackstart extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Crossjackstart({this.bluetoothServices});

  @override
  _CrossjackstartState createState() => _CrossjackstartState();
}

class _CrossjackstartState extends State<Crossjackstart> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int gesture_num2 = 0;
  int count =0;
  int correct = 0;
  int wrong = 0;
  double score = 0;
  bool flag = false;
  List<Widget>? tutorial;
  num dino = 0;
  num boxing = 0;
  num jumpingJack = 0;
  num crossJack = 0;
  double avg = 0;

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

  late AudioPlayer player = AudioPlayer();
  Future<void> bgmPlay() async {
    await player.setAsset('assets/audio/bgm_exercise.mp3');
    player.play();
  }

  @override
  void initState() {
    bgmPlay();
  }

  @override
  void dispose(){
    player.dispose();
    // _streamController.close();
    super.dispose();
  }

  Future<void> addScore(double score) async{
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      setState(() {
        dino = doc.get('dino');
        boxing = doc.get('boxing');
        jumpingJack = doc.get('jumpingJack');
        crossJack = doc.get('crossJack');
      });
    });

    if(score > crossJack) {
      avg = (dino + boxing + jumpingJack + score)/4;

      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'crossJack': double.parse(score.toStringAsFixed(0)),
        'avg': double.parse(avg.toStringAsFixed(0)),
      });
    }
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
                            }
                            else {
                              if (count >= 40) {
                                score = ((correct/count)*100);
                                wrong = count -correct;
                                tutorial = <Widget>[
                                  Stack(
                                    children: [
                                      Lottie.asset(
                                        'assets/finish.json',
                                        repeat: true,
                                        reverse: false,
                                        animate: true,
                                        height: 300,
                                        width: 300,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(width: 300, height:120),
                                          Image.asset('finish1.png'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text("Score: " + score.toStringAsFixed(0), style: TextStyle(fontSize: 40,color: Colors.white),),
                                  Text("Correct: " + correct.toString(),style: TextStyle(fontSize: 30,color: Colors.white),),
                                  //Text("Wrong: " + wrong.toString(), style: TextStyle(fontSize: 30,color: Colors.white),),
                                  SizedBox(height: 80,),

                                  Center(child: Row(
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          // foreground
                                        ),
                                        onPressed: () {
                                          addScore(score);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(bluetoothServices: widget.bluetoothServices)));
                                        },
                                        child: Image.asset('exit.png',height: 72,),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.black,
                                          // foreground
                                        ),
                                        onPressed: () {
                                          addScore(score);
                                          Navigator.pop(context);
                                        },
                                        child: Image.asset('restart.png',height: 72,),
                                      ),
                                    ],
                                  ),),
                                ];
                              }
                              else {
                                switch (snapshot.data) {
                                  case 0:
                                    tutorial = <Widget>[
                                      Row(children: [
                                        IconButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back,color: Colors.white))
                                      ],),
                                      SizedBox(height: 80,),
                                      Image.asset('start_start.png', height: 250,width: 250,),
                                    ];
                                    break;
                                  case 1:
                                    tutorial = <Widget>[
                                      Row(children: [
                                        IconButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back,color: Colors.white))
                                      ],),
                                      SizedBox(height: 120,),
                                      Image.asset('start_3.png', height: 150,width: 150,),
                                    ];
                                    break;
                                  case 2:
                                    tutorial = <Widget>[
                                      Row(children: [
                                        IconButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back,color: Colors.white))
                                      ],),
                                      SizedBox(height: 120,),
                                      Image.asset('start_2.png', height: 150,width: 150,),
                                    ];
                                    break;
                                  case 3:
                                    tutorial = <Widget>[
                                      Row(children: [
                                        IconButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back,color: Colors.white))
                                      ],),
                                      SizedBox(height: 120,),
                                      Image.asset('start_1.png', height: 150,width: 150,),
                                    ];
                                    break;
                                  case 4:
                                    tutorial = <Widget>[
                                      Row(children: [
                                        IconButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.arrow_back,color: Colors.white))
                                      ],),
                                      flag ? Image.asset('correct.png',height: 80,):Container(height: 80,),
                                      Center(child:
                                      Image.asset('cross.gif', height: 400,
                                        width: 300,),),
                                      Text("Count: " + (count/2).toStringAsFixed(0),style: TextStyle(color: Colors.white),),
                                      Text("Achievement rate: " + ((count/40)*100).toStringAsFixed(0) + '%',style: TextStyle(color: Colors.white),),
                                    ];
                                    break;
                                }
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
      });
    },);
    if(gesture_num == 2) {
      flag = true;
    }
    else if(gesture_num == 1) {
      correct = correct +1;
      flag = false;
    }
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('tutorial1_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}
