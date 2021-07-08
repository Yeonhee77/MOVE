import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/sensor_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:move/front/home.dart';

import 'bluetooth_off_screen.dart';
import 'signin.dart';
import 'model/sensor_data.dart';

int sec = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOVE!',
      theme: ThemeData(
        cardColor: Colors.deepPurple[100],
      ),

      home: Signin(),
      // home: MyHomePage(title: 'MOVE!'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  StreamSubscription? scanSubScription;

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // scanSubScription = widget.flutterBlue.scan().listen((scanResult) async {
    //   _addDeviceTolist(scanResult.device);
    // }, onDone: () => stopScan());

    scanSubScription = widget.flutterBlue.scanResults.listen((scanResult) {
      for (ScanResult r in scanResult) {
        _addDeviceTolist(r.device);
      }
    });
    // widget.flutterBlue.stopScan();

    // widget.flutterBlue.connectedDevices
    //     .asStream()
    //     .listen((List<BluetoothDevice> devices) {
    //   for (BluetoothDevice device in devices) {
    //     _addDeviceTolist(device);
    //   }
    // });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  stopScan() {
    widget.flutterBlue.stopScan();
    scanSubScription?.cancel();
    scanSubScription = null;
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
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
              FlatButton( //button "connect"
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  stopScan();
                  _addDeviceTolist(device);
                  try {
                    await device.connect();
                  } catch (e) {
                    if (e != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    //_services = await device.discoverServices();
                  }
                  setState(() {
                    _connectedDevice = device;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SensorListScreen()));
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

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = [];

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = [];

    for (BluetoothService service in _services!) {
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Connected Successfully :)'),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
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

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        title: Text(widget.title),
      actions: [
        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Signin())),
            icon: Icon(Icons.arrow_forward))
      ],
    ),
    body: _buildListViewOfDevices(),
  );
}