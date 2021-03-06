import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:just_audio/just_audio.dart';
import 'package:move/home_page.dart';
import 'package:move/trex/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import 'game.dart';

class TRexGameWrapper extends StatefulWidget {

  final List<BluetoothService>? bluetoothServices;
  TRexGameWrapper({this.bluetoothServices});

  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}
enum TRexGameStatus { playing, waiting, gameOver }

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  /*--------bluetooth-------*/
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  bool splashGone = false;
  TRexGame? game;
  String gesture = "";

  num score = 0;
  num dino = 0;
  num boxing = 0;
  num jumpingJack = 0;
  num crossJack = 0;
  // ignore: non_constant_identifier_names
  num final_score = 0;
  num temp = 0;
  double avg = 0;

  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = 0.0;
  late double timePlaying = 0.0;

  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  // BGM
  late AudioPlayer bgm = AudioPlayer();

  Future<void> playBGM() async {
    await bgm.setAsset('assets/audio/bgm.mp3');
    bgm.setLoopMode(LoopMode.one);
    bgm.play();
  }

  @override
  void initState() {
    super.initState();
    playBGM();
    startGame();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]); //screen horizontally
  }

  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bgm.dispose();
    super.dispose();
  }

  void startGame() {
    Flame.images.loadAll(["sprite.png"]).then(
          (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);
        })
      },
    );
  }

  void _gesture() {
    for (BluetoothService service in widget.bluetoothServices!) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read &&
            characteristic.properties.notify) {
          setnum(characteristic);
        }
      }
    }
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      if (mounted) { //Exception
        setState(() {
          readValues[characteristic.uuid] = value;
          gesture = value.toString();
          gesture_num = int.parse(gesture[1]);
        });
      }
    });

    await characteristic.read();
    sub.cancel();
  }

  Future<void> addScore() async{
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
          if(mounted) {
            setState(() {
              dino = doc.get('dino');
              print(doc.get('dino'));
              print('DINO SCORE - ' + dino.toString());
              boxing = doc.get('boxing');
              jumpingJack = doc.get('jumpingJack');
              crossJack = doc.get('crossJack');
            });

            if(score > dino) {
              avg = (score + boxing + jumpingJack + crossJack)/4;
              print('score = $score');
              print('dino = $dino');

              updateScore();
            }
          }
    });

  }

  Future<void> updateScore() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'dino': score,
      'avg': double.parse(avg.toStringAsFixed(2)),
    });
  }

  Widget scoreBox(BuildContext buildContext, TRexGame game) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(30.0),
            child: SizedBox(
                child: Text('Score : $score', style: GoogleFonts.russoOne(color: Colors.white, fontSize: 30, decoration: TextDecoration.none))),
          ),
        ]);
  }

  Widget exitBox(BuildContext buildContext, TRexGame game) {
    return Container(
      width: 100,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: TextButton(
              onPressed: () {
                addScore();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Image.asset('dino_Exit.png', height: 30,),
            ),
          ),
        ],
      ),);
  }

  Widget restartBox(BuildContext buildContext, TRexGame game) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 90,
          child: Flexible(
            child: TextButton(
              onPressed: () {
                addScore();
                //score = 0;
                game.restart();
              },
              child: Image.asset('dino_Restart.png', height: 30,),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _gesture();
    game!.onAction(gesture_num);
    score = game!.returnScore();
    //final_score = game!.getFinalScore();

    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    else
      return Container(
        constraints: const BoxConstraints.expand(),
        child: GameWidget(
          game: game!,
          overlayBuilderMap: {
            'Score' : scoreBox,
            'Exit' : exitBox,
            'Restart' : restartBox,
          },
          initialActiveOverlays: ['Score', 'Exit', 'Restart'],
        ),
      );
  }
}