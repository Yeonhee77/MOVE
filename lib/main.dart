import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/front/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner : false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState () => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2), value: 0.1, vsync: this, );

    _animation = CurvedAnimation(parent: _controller!, curve: Curves.bounceInOut);

    _controller!.forward();
    super.initState();
    Timer(Duration(seconds: 3),
            ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children:<Widget>[
            Image( image: AssetImage("background.png"), fit: BoxFit.cover, colorBlendMode: BlendMode.darken, ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTransition(
                    scale: _animation!,
                    child: Image.asset('logo.png', width: 250,)
                ),
              ],
            ),]
      ),
    );
  }
}
  

