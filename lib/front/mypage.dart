import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class Mypage extends StatefulWidget {
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  num total = 0;
  num dino = 0;
  num fish = 0;
  num squat = 0;
  num dumbbell = 0;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
          setState(() {
            dino = doc.get('dino');
            fish = doc.get('fish');
            squat = doc.get('squat');
            dumbbell = doc.get('dumbbell');
            total = doc.get('avg');
          });
    });
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move!'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15,),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 15),
                Text(FirebaseAuth.instance.currentUser!.displayName.toString() + ' 님', style: TextStyle(fontSize: 20),),
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Average Score: $total', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,),),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: double.infinity, height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                    ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('Bluewhite_text.png',fit: BoxFit.fill),
                        Text('  $dino 점', style: TextStyle(fontSize: 25),),
                    ],
                  )),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                      width: double.infinity, height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('Dino_text.png',fit: BoxFit.fill),
                          Text('  $fish 점', style: TextStyle(fontSize: 25),),
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                      width: double.infinity, height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('Fish_text.png',fit: BoxFit.fill),
                          Text('  $squat 점', style: TextStyle(fontSize: 25),),
                        ],
                      )),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                      width: double.infinity, height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('Pump_text.png',fit: BoxFit.fill),
                          Text('  $dumbbell 점', style: TextStyle(fontSize: 25),),
                        ],
                      )),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text('Sign Out'),
                  onPressed: () {
                    signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                )
                ],
            ),
          ],
        ),
      ),
    );
  }
}
