import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/mypage.dart';
import 'package:move/trex/trex_main.dart';
import 'package:flutter/services.dart';
import 'boxing.dart';

class Game extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Game({this.bluetoothServices});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([ //screen vertically
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30,),
                  TextButton(
                    onPressed: () {
                      if(widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TRexGameWrapper(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('dinoButton.png', width: MediaQuery.of(context).size.width*0.7,),
                  ),
                  SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      if(widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('boxButton.png', width: MediaQuery.of(context).size.width*0.7,),
                  ),
                ],
              ),
            ),
          );
        }
        )
    );
  }
}