import 'dart:async';
import 'package:flutter/material.dart';
import 'package:move/data.dart';
import 'package:move/home_page.dart';

class CounterPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  Gesture gesturedata;
  CounterPage(@required this.gesturedata);
  @override
  _CounterPageState createState() => _CounterPageState(gesturedata);
}

class _CounterPageState extends State<CounterPage> {
  Gesture gesture;
  final StreamController<int> _streamController = StreamController<int>();
  _CounterPageState(this.gesture);

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
        child: StreamBuilder<int>(
            stream: _streamController.stream,
            initialData: gesture.gesturedata,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot){
              return Text('You hit me: ${snapshot.data} times');
            }
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: (){
      //     _streamController.sink.add(++_counter);
      //   },
      // ),
    );
  }
}