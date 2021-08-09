import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/mypage.dart';
import 'package:move/home_page.dart';
import 'package:move/trex/trex_main.dart';
import 'package:flutter/services.dart';
import 'package:move/trex/trex_tutorial.dart';
import 'boxing.dart';
import 'fishing.dart';

class Game extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Game({this.bluetoothServices});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //screen vertically
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Game', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {Navigator.pop(context);},
        ),
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                      if (widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                TrexTutorial(bluetoothServices: widget
                                    .bluetoothServices)));
                      if (widget.bluetoothServices == null)
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                        });
                    },
                    child: Image.asset('dinoButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      if (widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                BoxingStart(bluetoothServices: widget
                                    .bluetoothServices)));
                      if (widget.bluetoothServices == null)
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                        });
                    },
                    child: Image.asset('boxButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                       if(widget.bluetoothServices != null)
                         Navigator.push(context, MaterialPageRoute(builder: (context) => FishingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('fishing.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('badminton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('jumprope.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('kick.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('taekwondo.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('tabletennis.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('badminton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('jumprope.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('kick.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('taekwondo.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('tabletennis.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      ),
    );
  }
}