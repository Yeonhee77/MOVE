import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/data.dart';
import 'package:move/value.dart';

import 'front/login.dart';

String gesture = "";
// ignore: non_constant_identifier_names
int gesture_num = 0;
final StreamController<int> streamController = StreamController<int>();

// ignore: non_constant_identifier_names
String gesture_name = "";
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final Move move = Move(gesture_num);
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  // ignore: deprecated_member_use

  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final textController = TextEditingController();
  BluetoothDevice? connectedDevice;
  List<BluetoothService>? bluetoothServices;

  _showDeviceTolist(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _showDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _showDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

  ListView _buildListViewOfDevices() {
    // ignore: deprecated_member_use
    List<Container> containers = [];
    for (BluetoothDevice device in devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  flutterBlue.stopScan();
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    bluetoothServices = await device.discoverServices();
                  }
                  setState(() {
                    connectedDevice = device;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  void _bleRead(
      BluetoothCharacteristic characteristic) {
    // ignore: deprecated_member_use
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;});
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) setnum(characteristic);
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
        print('GESTURE - ' + gesture);
        switch(gesture_num){
          case 1: gesture_name = "LEFT"; break;
          case 2: gesture_name = "RIGHT"; break;
          case 3: gesture_name = "UP"; break;
          case 4: gesture_name = "DOWN"; break;
        }
      });
    });

    await characteristic.read();
    sub.cancel();
  }

  void _bleServices() {
    // ignore: deprecated_member_use
    for (BluetoothService service in bluetoothServices!) {
      // ignore: deprecated_member_use
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        _bleRead(characteristic);
      }
    }
  }

  Widget _buildView() {
    if (connectedDevice != null) {
      _bleServices();
      return Center(
        child:Column(
          children: [
            SizedBox(height: 30,),
            Center(
                child:Column(
                  children: [
                    Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Text(gesture_name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ],
                )
            ),
          ],
        ),
      );
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("MOVE!")),
        leading: IconButton(
          icon: Icon(Icons.people_alt, color: Colors.white,),
          onPressed: () =>
          {
          },
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.photo_album),
            tooltip: 'Hi!',
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      CounterPage(bluetoothServices: bluetoothServices))
              );
            },
          ),
          IconButton(
              icon: new Icon(Icons.design_services),
              onPressed: () =>
              {
                print(gesture_num),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      Login(bluetoothServices: bluetoothServices)),
                )
              })
        ],
      ),
      body: _buildView()
    );
  }
}