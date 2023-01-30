import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  //Setup LongToast
  void showLongToast(String state) {
    Fluttertoast.showToast(
      msg: state,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await AirplaneModeChecker.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Version $_platformVersion'),
              ElevatedButton(
                child: const Text('Check AirplaneMode'),
                onPressed: () async {
                  final status = await AirplaneModeChecker.checkAirplaneMode();
                  if (status == AirplaneModeStatus.on) {
                    showLongToast('ON');
                    log('ON');
                  } else {
                    showLongToast('OFF');
                    log('OFF');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
