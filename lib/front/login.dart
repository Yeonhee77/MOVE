import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  num game1 = 0;
  num game2 = 0;
  num game3 = 0;
  num game4 = 0;
  double avg = 0;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

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
      'game1' : game1,
      'game2' : game2,
      'game3' : game3,
      'game4' : game4,
      'avg' : avg,
    }).then((value) => print("user add!"));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Google Login'),
          onPressed: () {
            signInWithGoogle();
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
    );
  }
}
