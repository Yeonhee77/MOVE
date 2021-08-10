import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/mypage.dart';
import 'package:move/trex/trex_main.dart';
import 'package:flutter/services.dart';
import 'package:move/trex/trex_tutorial.dart';
import 'bbabbabba.dart';
import 'boxing.dart';

class Dance extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Dance({this.bluetoothServices});

  @override
  _DanceState createState() => _DanceState();
}

class _DanceState extends State<Dance> {
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
        title: Text('Dance', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30,),
                Flexible(
                  child: TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Note!'),
                        content: const Text('This feature will be updated soon :)'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    child: Image.asset('papapa.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ),
                // SizedBox(height: 5,),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      // if (widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(
                      //       builder: (context) =>
                      //           BoxingStart(bluetoothServices: widget
                      //               .bluetoothServices)));
                    },
                    child: Image.asset('rollin.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ),
                // SizedBox(height: 5,),
                Flexible(
                  child: TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('cheerup.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      ),

    );
  }
}