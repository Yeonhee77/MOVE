import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:just_audio/just_audio.dart';

class FishingStart extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  FishingStart({this.bluetoothServices});

  @override
  _FishingStartState createState() => _FishingStartState();
}

class _FishingStartState extends State<FishingStart> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);
  final Stream<int> stream2 = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);

  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;


  @override
  void dispose(){
    super.dispose();
  }


  ListView _buildConnectDeviceView() {
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
                          IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,))
                        ],),
                        SizedBox(height: 60,),
                        Image.asset('snap.png',height: 200,),
                        //Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        Text("Please attach the chip",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                        Text("to your wrist",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                        Row(
                          children: [
                            SizedBox(width: 70,),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                // foreground
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Fishing(bluetoothServices: widget.bluetoothServices)));
                              },
                              child: Image.asset('ok.png'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('boxing_back.png'),
                  fit: BoxFit.fill
              )
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}

class Fishing extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;

  Fishing({this.bluetoothServices});

  @override
  _FishingState createState() => _FishingState();
}

class _FishingState extends State<Fishing> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final Stream<int> stream = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);
  final Stream<int> stream2 = Stream.periodic(Duration(milliseconds: 1500),  (int x) => x);

  List<String> random = ['Punch', 'Uppercut'];
  List<String> image = ['punch.png', 'uppercut.png'];
  String gesture = "";
  // ignore: non_constant_identifier_names
  String ran_gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  int count = -1;
  int correct = 0;
  int jar = 0;

  // Sound
  late AudioPlayer punchSound = AudioPlayer();
  late AudioPlayer bgmSound = AudioPlayer();

  Future<void> playPunch() async {
    await punchSound.setAsset('assets/audio/punch.mp3');
    punchSound.play();
  }

  Future<void> startBGM() async {
    await bgmSound.setAsset('assets/audio/bgm.mp3');
    bgmSound.setLoopMode(LoopMode.one);
    bgmSound.play();
  }

  @override
  void initState() {
    super.initState();
    startBGM();
  }

  @override
  void dispose(){
    super.dispose();
    punchSound.dispose();
    bgmSound.dispose();
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
    //
    // if(ran_gesture == 'Punch') {
    //   if(gesture_num == 2) {
    //     gesture_num = 0;
    //     correct += 1;
    //     jar++;
    //     playPunch();
    //   }
    // }else if(ran_gesture == 'Uppercut') {
    //   if(gesture_num == 1) {
    //     gesture_num = 0;
    //     correct += 1;
    //     jar++;
    //     playPunch();
    //   }
    // }

    if(jar == 15) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FishingClear(
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
        body: Column(
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
              // SizedBox(height: 40),
              // StreamBuilder<int>(
              //     stream: stream,
              //     builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              //       var ran = Random().nextInt(2);
              //       ran_gesture = random[ran];
              //       return Image.asset(image[ran]);
              //     }
              // ),
              // SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width*0.45,
              //   height: MediaQuery.of(context).size.height*0.3 + 4,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.white,
              //       width: 2,
              //     ),
              //     borderRadius: BorderRadius.all(
              //         Radius.circular(10) // POINT
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //             color: Colors.transparent
              //         ),
              //         height: MediaQuery.of(context).size.height*0.3 / 15 * (15-jar),
              //       ),
              //       Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //             colors: [const Color(0xffEA592B), const Color(0xffF6EA13)],
              //           ),
              //           borderRadius: BorderRadius.all(
              //               Radius.circular(10) // POINT
              //           ),
              //         ),
              //         height: MediaQuery.of(context).size.height*0.3 / 15 * jar,
              //       )
              //     ],
              //   ),
              // ),
              Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child:
                StreamBuilder<int>(
                    stream: stream2,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if(gesture_num == 1)
                        return Image.asset('image1.png', width: MediaQuery.of(context).size.width/2.8,);
                      return Image.asset('image2.png', width: MediaQuery.of(context).size.width/2.8,);
                    }
                ),
              ),
            ],
          ),
    );
  }
}


class FishingClear extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final double score;

  FishingClear({this.bluetoothServices, required this.score});

  @override
  _FishingClearState createState() => _FishingClearState();
}

class _FishingClearState extends State<FishingClear> {
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FishingStart(bluetoothServices: widget.bluetoothServices)));
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