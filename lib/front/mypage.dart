import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  String id = FirebaseAuth.instance.currentUser!.uid;
  num total = 0;

  @override
  void initState() {
    super.initState();

    user.doc(id).get().then((doc) {
      total = doc.get('avg');
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
          Text(total.toString()),
        ],
      ),
    );
  }
}
