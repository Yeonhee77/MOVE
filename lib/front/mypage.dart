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
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
          setState(() {
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
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 15),
                Text(FirebaseAuth.instance.currentUser!.displayName.toString() + ' 님', style: TextStyle(fontSize: 20),),
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Total Score: $total', style: TextStyle(fontSize: 32),),
                Center(
                  child: Container(
                    width: 50, height: 50,
                      child: Row(
                      children: [
                        Image.asset('Bluewhite_text.png',fit: BoxFit.fitWidth),
                        Text('  $game1 점', style: TextStyle(fontSize: 20),),
                    ],
                  )),
                ),

                SizedBox(height: 20),
                Text('2. 공룡 : $game2', style: TextStyle(fontSize: 20),),
                SizedBox(height: 20),
                Text('3. 낚시 : $game3', style: TextStyle(fontSize: 20),),
                SizedBox(height: 20),
                Text('4. 펌프 : $game4', style: TextStyle(fontSize: 20),),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
