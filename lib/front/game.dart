import 'package:flutter/material.dart';
import 'package:move/front/mypage.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Move!'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.purple[100],
          actions: <Widget> [
            IconButton(onPressed: () {Navigator.push(context,
                MaterialPageRoute(builder: (context) => Mypage()));}, icon: Icon(Icons.account_circle_rounded))
          ],
        ),
      body: Column(
        children: [
          Row(

          ),
          Row(

          ),
        ],
      )
    );
  }
}
