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
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: makeRow('bluewhite.png', 'Dino.png'),
                  height: (constraints.maxHeight)/2,
                ),
          RaisedButton( child: Text("Fade In"), onPressed: () {}),
                Container(
                  child: makeRow('Fish.jpg', 'Pump.jpg'),
                  height: (constraints.maxHeight)/2,
                ),
              ],
            ),
          );
        }
        )
    );
  }

  Widget makeRow(String leftPath, String rightPath) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExpandImage(leftPath),
          ExpandImage(rightPath),
        ],
      ),
    );
  }

  Widget ExpandImage(String image) {
    return Expanded(
      child: Container(
        child: Image.asset(
          image,
          fit: BoxFit.fill,
        ),
        margin: EdgeInsets.all(0.5),
      ),
    );
  }
}