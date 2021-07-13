import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/front/login.dart';

import '/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: Login(),
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


