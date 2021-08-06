import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/trex/dinoCondition.dart';
import 'package:move/trex/trex_main.dart';

class TrexTutorial extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  TrexTutorial({this.bluetoothServices});

  @override
  _TrexTutorialState createState() => _TrexTutorialState();
}

class _TrexTutorialState extends State<TrexTutorial> {
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
                            children: [
                              Row(children: [
                                IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,))
                              ],),
                              SizedBox(height: 60,),
                              Image.asset('snap.png',height: 200,),
                              //Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              SizedBox(height: 30,),
                              Text("Please attach the chip",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                              Text("to your wrist",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
                              Row(
                                children: [
                                  SizedBox(width: 70,),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                      // foreground
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TRexGameWrapper(bluetoothServices: widget.bluetoothServices)));
                                    },
                                    child: Image.asset('ok.png'),
                                  ),
                                ],
                              )
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
