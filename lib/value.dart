import 'dart:async';
import 'package:flutter/material.dart';
import 'package:move/data.dart';

class CounterPage extends StatefulWidget {
  final Move move;
  CounterPage({required this.move});

  // ignore: non_constant_identifier_names
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final StreamController<int> _streamController = StreamController<int>();

  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 1), () {
  //     _streamController.add(widget.move.gdata);
  //   });
  //   super.initState();
  // }

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
          child: Text('You hit me: ' + widget.move.gdata.toString()),
      ),// floatingActionButton: FloatingActionButton(
    //   child: const Icon(Icons.add),
    //   onPressed: (){
    //     _streamController.sink.add(widget.move.gdata);
    //   },
    // ),
    );
  }
}