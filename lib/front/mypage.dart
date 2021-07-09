import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  num total = 0;
  num game1 = 0;
  num game2 = 0;
  num game3 = 0;
  num game4 = 0;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
          setState(() {
            game1 = doc.get('game1');
            game2 = doc.get('game2');
            game3 = doc.get('game3');
            game4 = doc.get('game4');
            total = doc.get('avg');
          });
    });
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
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser.photoURL.toString()),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 15),
                Text(FirebaseAuth.instance.currentUser.displayName.toString() + ' 님', style: TextStyle(fontSize: 20),),
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
                        Text('  $game1 점', style: TextStyle(fontSize: 25),),
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
                          Text('  $game2 점', style: TextStyle(fontSize: 25),),
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
                          Text('  $game3 점', style: TextStyle(fontSize: 25),),
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
                          Text('  $game4 점', style: TextStyle(fontSize: 25),),
                        ],
                      )),
                ),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
