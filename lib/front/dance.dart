import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';
import 'package:flutter_glow/flutter_glow.dart';

class Dance extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;

  Dance({this.bluetoothServices});

  @override
  _DanceState createState() => _DanceState();
}

class _DanceState extends State<Dance> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1000),  (int x) => x);

  List<String> random = ['up.png', 'down.png', 'left.png', 'right.png'];
  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int correct = 0;

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

    // if(ran_gesture == 'Punch') {
      if(gesture_num == 1) {
        gesture_num = 0;
        correct += 1;
      }
    // }else if(ran_gesture == 'Uppercut') {
      if(gesture_num == 2) {
        gesture_num = 0;
        correct += 1;
      }
    // }

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
                    var ran = Random().nextInt(4);
                    ran_gesture = random[ran];
                    // return GlowText(
                    //   random[ran],
                    //   style: TextStyle(fontSize: 40, color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                    // );
                    return Image.asset(random[ran]);
                  }
              ),

            ],
          ),
        )
    );
  }
}


class DanceClear extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final double score;

  DanceClear({this.bluetoothServices, required this.score});

  @override
  _DanceClearState createState() => _DanceClearState();
}

class _DanceClearState extends State<DanceClear> {
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

  Future<void> addScore() async{
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

    if(widget.score > boxing) {
      avg = (dino + widget.score + jumpingJack + crossJack)/4;

      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'boxing': widget.score,
        'avg': double.parse(avg.toStringAsFixed(2)),
      });
    }
  }

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
                image: AssetImage('boxing_clear.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/3,),
                Text('Score: $score', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Image.asset('exit.png', width: MediaQuery.of(context).size.width/2.2,),
                      onPressed: () {
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          addScore();
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
                          addScore();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Dance(bluetoothServices: widget.bluetoothServices)));
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
