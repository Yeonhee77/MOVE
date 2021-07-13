import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/trex/game.dart';

class TRexGameWrapper extends StatefulWidget {

  final List<BluetoothService>? bluetoothServices;
  TRexGameWrapper({this.bluetoothServices});

  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  bool splashGone = false;
  TRexGame? game;
  final _focusNode = FocusNode();

  //bluetooth services
  List<BluetoothService>? bluetoothServices;
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  String gesture_name = "";
  int gesture_num = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   startGame();
  // }
  //
  // void startGame() {
  //   Flame.images.loadAll(["sprite.png"]).then(
  //         (image) => {
  //       setState(() {
  //         game = TRexGame(spriteImage: image[0]);
  //         _focusNode.requestFocus();
  //       })
  //     },
  //   );
  // }
  //
  // void onRawKeyEvent(RawKeyEvent event) {
  //   if (event.logicalKey == LogicalKeyboardKey.enter ||
  //       event.logicalKey == LogicalKeyboardKey.space) {
  //     game!.onAction(bluetoothServices);
  //   }
  // }

  void _gesture() {
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
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
        print('GESTURE RECEIVED in TREX - ' + gesture);
      });
    });

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _gesture();
    return Scaffold(
      appBar: AppBar(title: Text('Trex main'),),
      body: Center(
        child:Column(
          children: [
            SizedBox(height: 30,),
            Center(
                child:Column(
                  children: [
                    Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ],
        ),
      ),
    );
    // if (game == null) {
    //   return const Center(
    //     child: Text("Loading"),
    //   );
    // }
    // return Container(
    //   color: Colors.white,
    //   constraints: const BoxConstraints.expand(),
    //   child: RawKeyboardListener(
    //     focusNode: _focusNode,
    //     onKey: onRawKeyEvent,
    //     child: GameWidget(
    //       game: game!,
    //     ),
    //   ),
    // );
  }
}