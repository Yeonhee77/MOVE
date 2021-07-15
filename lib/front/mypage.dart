import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  num boxing = 0;
  num jumpingJack = 0;
  num crossJack = 0;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance.collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
          setState(() {
            dino = doc.get('dino');
            boxing = doc.get('boxing');
            jumpingJack = doc.get('jumpingJack');
            crossJack = doc.get('crossJack');
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
            color: Colors.indigo
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('background.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2-1,
                        child: Column(
                          children: [
                            Text('Home workout'),
                            Row(
                              children: [
                                Text('Jumping Jack: '),
                                Text(jumpingJack.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Cross Jack: '),
                                Text(crossJack.toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 100,
                        color: Colors.white,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2-1,
                        child: Column(
                          children: [
                            Center(child: Text('Game')),
                            Row(
                              children: [
                                Text('Dino: '),
                                Text(dino.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Boxing: '),
                                Text(boxing.toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
