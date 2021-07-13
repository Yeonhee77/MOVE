import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/dumbbell.dart';
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
        appBar: AppBar(
          title: Text('Move!'),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.purple[100],
          actions: <Widget> [
            IconButton(onPressed: () {Navigator.push(context,
                MaterialPageRoute(builder: (context) => Mypage()));}, icon: Icon(Icons.account_circle_rounded))
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30,),
                Container(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: InkWell(
                        child: Image.asset(
                          'bluewhite.png',
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          if(widget.bluetoothServices != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: InkWell(
                        child: Image.asset(
                          'Fish.jpg',
                          fit: BoxFit.fill,
                        ),
                        onTap: () {
                          if(widget.bluetoothServices != null)
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Dumbbell(bluetoothServices: widget.bluetoothServices)));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        )
    );
  }
}