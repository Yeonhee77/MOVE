import 'dart:async';
import 'package:flutter/material.dart';
import 'package:move/data.dart';

class CounterPage extends StatefulWidget {
  Gesture gesturedata;
  CounterPage(this.gesturedata);

  // ignore: non_constant_identifier_names
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int value = 0;
  final StreamController<int> _streamController = StreamController<int>();


  @override
  void dispose(){
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream version of the Counter App')),
      body: Center(
        child:
        StreamBuilder<int>(
            stream: _streamController.stream,
            initialData: value = widget.gesturedata.gesturedata,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot){
              return Text('You hit me: ${snapshot.data} times');
            }
        ),
      ),
    );
  }
}