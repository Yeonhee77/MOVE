

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
