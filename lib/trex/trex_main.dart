import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/data.dart';
import 'package:move/home_page.dart';
import 'package:move/front/game.dart';


import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game.dart';

class TRexGameWrapper extends StatefulWidget {

  final List<BluetoothService>? bluetoothServices;
  TRexGameWrapper({this.bluetoothServices});

  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  /*--------bluetooth-------*/
  final StreamController<int> _streamController = StreamController<int>();
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  bool splashGone = false;
  TRexGame? game;
  //final _focusNode = FocusNode();

  Widget pauseMenu(BuildContext buildContext, TRexGame game) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
        width: 100,
        height: 100,
        color: Colors.white,
        child: Center(
          child: Text('Paused')
        )
      )
    ]
    );
  }

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Flame.images.loadAll(["sprite.png"]).then(
          (image) => {
        setState(() {
          game = TRexGame(spriteImage: image[0]);

          //_focusNode.requestFocus();
        })
      },
    );
  }

  @override
  void dispose(){
    _streamController.close();
    super.dispose();
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

  Widget _textBox() {
    return Center(
      child: Text("Hi"),
    );
  }

  @override
  Widget build(BuildContext context) {
    _gesture();
    game!.onAction(gesture_num);
    if (game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: GameWidget(
        game: game!,
        overlayBuilderMap: {
          'PauseMenu' : pauseMenu
        },
        initialActiveOverlays: ['PauseMenu'],
      ),
    );
  }

}
