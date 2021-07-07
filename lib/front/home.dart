import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move/front/mypage.dart';
import 'package:move/front/game.dart';

import 'login.dart';

class User {
  final String name;
  final num score1, score2, score3, score4;

  User(this.name, this.score1, this.score2, this.score3, this.score4);
}

class Home extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      title: 'Move!',
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Homepage> {

  static List<User> user = [
    User('용재', 100, 50, 60, 70),
    User('종현', 80, 70, 90, 100),
    User('은지', 50, 90, 100, 80),
    User('연희', 70, 100, 60, 90),
    User('주은', 100, 80, 60, 90),
  ];

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
        actions: <Widget> [
          IconButton(
              icon: Icon(Icons.signal_cellular_no_sim_outlined),
            onPressed: () {
              signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          IconButton(onPressed: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => Mypage()));}, icon: Icon(Icons.account_circle_rounded))
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.baseline, //line alignment
            textBaseline: TextBaseline.alphabetic, //line alignment
            children: [
              Text(
              'Rank',
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 30),
              Text(
                '1. 청기백기 : ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              SizedBox(height: 30),
              Text(
                '2. 공룡 : ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              SizedBox(height: 30),
              Text(
                '3. 허들 : ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              SizedBox(height: 30),
              Text(
                '4. 공용게임 : ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),),
              SizedBox(height: 80),
              SizedBox(
                  height: 100,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Color.fromARGB(100, 70, 10, 245), width: 5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Game()));
                    },
                    child: Text(
                      'Game Start!',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  )),

            ],
            ),
        ),
        ),

      );
  }
}
