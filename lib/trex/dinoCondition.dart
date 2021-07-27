import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/trex/trex_main.dart';

class DinoCondition extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  DinoCondition({this.bluetoothServices});

  @override
  _DinoConditionState createState() =>_DinoConditionState();
}

class _DinoConditionState extends State<DinoCondition> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //screen vertically
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TRexGameWrapper(bluetoothServices: widget.bluetoothServices)));
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('dino_back.png'),
                fit: BoxFit.fill
            )
        ),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
                child:Column(
                  children: [
                    SizedBox(height: 30,),
                    Center(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Row(children: [
                              IconButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,))
                            ],),
                            Image.asset('dinoHungry.png',),
                            SizedBox(height: 20,),
                            Text("Dinosaur has not eaten anything for several months",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                            SizedBox(height: 30,),
                            Text("So its reaction might be slow…",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                          ],
                        )
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}