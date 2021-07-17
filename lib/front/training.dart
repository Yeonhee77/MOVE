import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/Crossjack.dart';
import 'package:move/front/Jumpingjack.dart';
import 'package:move/front/crossjack_page.dart';
import 'package:move/front/mypage.dart';
import 'package:move/front/squat.dart';

class Training extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Training({this.bluetoothServices});

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('background.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30,),
                    TextButton(
                      onPressed: () {
                        if(widget.bluetoothServices != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingjack(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('jumpingButton.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        if(widget.bluetoothServices != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Crossjack(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('crossButton.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        if(widget.bluetoothServices != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('squatButton.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('crunch.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('dumbbell.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('plank.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('pushUp.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                    SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('bridge.png', width: MediaQuery.of(context).size.width*0.7,),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        )
    );
  }
}