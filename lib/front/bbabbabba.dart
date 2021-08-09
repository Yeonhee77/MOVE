import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

class Bba extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;

  Bba({this.bluetoothServices});

  @override
  _BbaState createState() => _BbaState();
}

class _BbaState extends State<Bba> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1000),  (int x) => x);
  final Stream<int> stream2 = Stream.periodic(Duration(milliseconds: 1000),  (int x) => x);

  List<String> random = ['up.png', 'down.png', 'left.png', 'right.png'];
  List<String> grey = ['up(grey).png', 'down(grey).png', 'left(grey).png', 'right(grey).png'];
  List<String> motion = ['up(motion).png', 'down(motion).png', 'left(motion).png', 'right(motion).png'];
  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int correct = 0;
  int start = 0;
  int jar = 0;
  int count = 0;
  bool flag = false;

  late AudioPlayer player = AudioPlayer();

  Future<void> soundPlaybgm() async {
    await player.setAsset('assets/audios/BBaBBaBBa.mp3');
    player.setLoopMode(LoopMode.one);
    player.play();
  }

  @override
  void initState() {
    super.initState();
    soundPlaybgm();
    // player = AudioPlayer();
  }


  @override
  void dispose(){
    player.dispose();
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
        Container(),
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
    count++;

    if (gesture_num == 1) {
      gesture_num = 0;
      correct += 1;
      jar++;
      flag = true;
    }

    if(jar == 10) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Clear(
          bluetoothServices: widget.bluetoothServices,
          score: (correct / count) * 100,
        )));
      });
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
                  image: AssetImage('dance_back.png'),
                  fit: BoxFit.fill
              )
          ),
          child: Column(
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back))
              ],),
              Container(
                  height: 1,
                  child: _buildConnectDeviceView()
              ),
              SizedBox(height: 40),
              StreamBuilder<int>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if(flag == true) {
                      flag = false;
                      return Image.asset(random[start]);
                    }
                    Future.delayed(Duration(milliseconds: 500));
                    var ran = Random().nextInt(4);
                    start = ran;
                    ran_gesture = grey[ran];

                    return Image.asset(grey[ran]);
                  }
              ),
              SizedBox(height: 90),
              StreamBuilder<int>(
                  stream: stream2,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if(ran_gesture == 'up(grey).png') {
                      return Align(
                        alignment: FractionalOffset(0.5, 1.0),
                        child: Image.asset('up(motion).png', height: MediaQuery.of(context).size.height/2),
                      );
                    }else if(ran_gesture == 'left(grey).png') {
                      return Align(
                          alignment: FractionalOffset(0.5, 1.0),
                          child: Image.asset('left(motion).png', height: MediaQuery.of(context).size.height/2)
                      );
                    }else if(ran_gesture == 'right(grey).png') {
                      return Align(
                          alignment: FractionalOffset(0.5, 1.0),
                          child: Image.asset('right(motion).png', height: MediaQuery.of(context).size.height/2)
                      );
                    }else if(ran_gesture == 'down(grey).png') {
                      return Align(
                          alignment: FractionalOffset(0.5, 1.0),
                          child: Image.asset('down(motion).png', height: MediaQuery.of(context).size.height/2)
                      );
                    }
                    return Image.asset(motion[3]);
                  }
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.9 + 4,
                height: MediaQuery.of(context).size.height*0.04,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10) // POINT
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9 / 10 * jar,
                      // width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.04,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.red, Colors.orange, Colors.greenAccent, Colors.blue, Colors.deepPurple],
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10) // POINT
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      width: MediaQuery.of(context).size.width * 0.9 / 10 * (10 - jar),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}


class Clear extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final double score;

  Clear({this.bluetoothServices, required this.score});

  @override
  _ClearState createState() => _ClearState();
}

class _ClearState extends State<Clear> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  num dino = 0;
  num boxing = 0;
  num jumpingJack = 0;
  num crossJack = 0;
  double avg = 0;

  @override
  void dispose(){
    super.dispose();
  }

  // Future<void> addScore() async{
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((doc) {
  //     setState(() {
  //       dino = doc.get('dino');
  //       boxing = doc.get('boxing');
  //       jumpingJack = doc.get('jumpingJack');
  //       crossJack = doc.get('crossJack');
  //     });
  //   });
  //
  //   if(widget.score > boxing) {
  //     avg = (dino + widget.score + jumpingJack + crossJack)/4;
  //
  //     FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({
  //       'boxing': widget.score,
  //       'avg': double.parse(avg.toStringAsFixed(2)),
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String score = widget.score.toStringAsFixed(2);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo,),
          onPressed: () {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(bluetoothServices: widget.bluetoothServices)));
            });
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('dance_back.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Column(
              children: [
                Text('Clear!', style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: MediaQuery.of(context).size.height/5,),
                Text('Score: $score', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: MediaQuery.of(context).size.height/7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Image.asset('exit.png', width: MediaQuery.of(context).size.width/2.2,),
                      onPressed: () {
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          // addScore();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(bluetoothServices: widget.bluetoothServices)));
                        });
                      },
                    ),
                    TextButton(
                      child: Image.asset('restart.png', width: MediaQuery.of(context).size.width/2.2,),
                      onPressed: () {
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          // addScore();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Bba(bluetoothServices: widget.bluetoothServices)));
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
