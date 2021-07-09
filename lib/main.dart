import 'package:flutter/material.dart';

import '/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: MyHomePage(),
  );
}

class Connected extends StatefulWidget {
  @override
  _ConnectedState createState() => _ConnectedState();

  final gesture = '';
}

class _ConnectedState extends State<Connected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Container(
        child: Text(widget.gesture),
      ),
    );
  }
}

//JH/0705/"Working on different repository!"
//created new project!

