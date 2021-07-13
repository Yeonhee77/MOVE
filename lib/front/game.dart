import 'package:flutter/material.dart';
import 'package:move/front/mypage.dart';
import 'package:move/trex/trex_main.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/data.dart';
import 'package:move/home_page.dart';

class Game extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Game({this.bluetoothServices});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
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
                Container(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: Image.asset(
                              'bluewhite.png',
                              fit: BoxFit.fill,
                            ),
                            margin: EdgeInsets.all(0.5),
                            width: MediaQuery.of(context).size.width/2 - 1,
                            height: (constraints.maxHeight)/2 - 1,
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width/6,
                            bottom: MediaQuery.of(context).size.height/12,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(100, 70, 10, 245),
                              ),
                              child: Text('Play!', style: TextStyle(fontSize: 20),),
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            child: Image.asset(
                              'Dino.png',
                              fit: BoxFit.fill,
                            ),
                            margin: EdgeInsets.all(0.5),
                            width: MediaQuery.of(context).size.width/2 - 1,
                            height: (constraints.maxHeight)/2 - 1,
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width/6,
                            bottom: MediaQuery.of(context).size.height/12,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TRexGameWrapper(bluetoothServices: widget.bluetoothServices)));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(100, 70, 10, 245),
                              ),
                              child: Text('Play!', style: TextStyle(fontSize: 20),),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: Image.asset(
                              'Fish.jpg',
                              fit: BoxFit.fill,
                            ),
                            margin: EdgeInsets.all(0.5),
                            width: MediaQuery.of(context).size.width/2 - 1,
                            height: (constraints.maxHeight)/2 - 1,
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width/6,
                            bottom: MediaQuery.of(context).size.height/12,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(100, 70, 10, 245),
                              ),
                              child: Text('Play!', style: TextStyle(fontSize: 20),),
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            child: Image.asset(
                              'Pump.jpg',
                              fit: BoxFit.fill,
                            ),
                            margin: EdgeInsets.all(0.5),
                            width: MediaQuery.of(context).size.width/2 - 1,
                            height: (constraints.maxHeight)/2 - 1,
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width/6,
                            bottom: MediaQuery.of(context).size.height/12,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(100, 70, 10, 245),
                              ),
                              child: Text('Play!', style: TextStyle(fontSize: 20),),
                            ),
                          )
                        ],
                      ),
                    ],
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