import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class Login extends StatefulWidget {
  final List<CameraDescription> cameras;
  Login(this.cameras);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin{
  final GoogleSignIn googleSignIn = GoogleSignIn();

  num dino = 0;
  num boxing = 0;
  num jumpingJack = 0;
  num crossJack = 0;
  double avg = 0;
  String id = '';
  String name = '';
  String photo = '';

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    id = FirebaseAuth.instance.currentUser!.uid.toString();
    name = FirebaseAuth.instance.currentUser!.displayName.toString();
    photo = FirebaseAuth.instance.currentUser!.photoURL.toString();

    FirebaseFirestore.instance
        .collection('user')
        .doc(authResult.user!.uid)
        .get()
        .then((value) => {
      if(!value.exists) {
        addUser()
      }
    });

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> addUser() async{
    FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'dino' : dino,
      'boxing' : boxing,
      'jumpingJack' : jumpingJack,
      'crossJack' : crossJack,
      'avg' : avg,
      'id' : id,
      'name' : name,
      'photo' : photo,
    }).then((value) => print("user add!"));
  }

  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 2), value: 0.1, vsync: this);


    _controller!.forward();
    super.initState();
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
                Text('Welcome',
                style: GoogleFonts.russoOne(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,),),
                SizedBox(height: 75),
                Container(
                  width: 195.0,
                  height: 45.0,
                  child: OutlinedButton(
                    child: Text('LOGIN',
                      style: GoogleFonts.russoOne(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,),
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color.fromARGB(255, 38, 32, 107),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))
                    ),
                    onPressed: () {
                      signInWithGoogle();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(cameras: widget.cameras)));
                    },
                  ),
                ),
              ],
            ),]
      ),
    );
  }
}
