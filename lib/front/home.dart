import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move/front/mypage.dart';
import 'package:move/front/game.dart';

import 'login.dart';

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
  List rankId = [];
  List<String> total = [];
  List<String> name = [];
  List<String> photo = [];

  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('user')
        .where('avg', isGreaterThan: -1)
        .orderBy('avg', descending: true)
        .limit(10)
        .snapshots()
        .listen((data) {
      setState(() {
        data.docs.forEach((element) {
          if(!rankId.contains(element.get('id'))) {
            rankId.add(element.get('id'));
            total.add(element.get('avg').toString());
            name.add(element.get('name').toString());
            photo.add(element.get('photo').toString());
          }
        });
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
      body: SingleChildScrollView(
        child: Center(
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

                FutureBuilder(
                  builder: (context, snapshot) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: rankId.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(total[index]),
                                subtitle: Text(name[index]),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(photo[index]),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        }
                    );
                  },
                ),

                SizedBox(height: 80),
                SizedBox(
                    height: 100,
                    width: 200,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Colors.purple, width: 5),
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
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}