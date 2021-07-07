import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move!'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.purple[100],
      ),
      body: Column(
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
              Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
