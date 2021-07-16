import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move/front/mypage.dart';
import 'package:move/front/game.dart';
import 'package:move/front/training.dart';

import '../home_page.dart';
import 'login.dart';

class Select extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Select({this.bluetoothServices});

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); //screen vertically
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(
            color: Colors.indigo
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('background.png'),
                fit: BoxFit.fill
            )
        ),
        child: Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Training(bluetoothServices: widget.bluetoothServices)));
                  },
                  child: Image.asset('hwButton.png', width: MediaQuery.of(context).size.width*0.7,),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Game(bluetoothServices: widget.bluetoothServices)));
                  },
                  child: Image.asset('gameButton.png', width: MediaQuery.of(context).size.width*0.7,),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Game(bluetoothServices: widget.bluetoothServices)));
                  },
                  child: Image.asset('reabButton.png', width: MediaQuery.of(context).size.width*0.7,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
