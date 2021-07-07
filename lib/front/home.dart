import 'package:flutter/material.dart';
import 'package:move/front/mypage.dart';
import 'package:move/front/game.dart';

class User {
  final String name;
  final num score1, score2, score3, score4, total;

  User(this.name, this.score1, this.score2, this.score3, this.score4, this.total);
}
 List<User> userList = [
  User('용재', 100, 50, 60, 70, 280),
  User('종현', 80, 70, 90, 100, 340),
  User('은지', 50, 90, 100, 80, 320),
  User('연희', 70, 100, 60, 90, 320),
  User('주은', 100, 80, 60, 90, 330),
];

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
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Ranking',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 30),
              ListView.separated(
                scrollDirection: Axis.vertical, //to use "ListView.seperated" in children
                shrinkWrap: true, //to use "ListView.seperated" in children
                padding: const EdgeInsets.all(8),
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(child: Text('${userList[index].name}  ' + ' ${userList[index].total} 점',style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                  ),)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
              SizedBox(height: 50),
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
