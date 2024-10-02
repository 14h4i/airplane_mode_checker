import 'dart:async';
import 'dart:developer';

import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<AirplaneModeStatus> _stream;

  @override
  void initState() {
    super.initState();
    _stream = AirplaneModeChecker.instance.listenAirplaneMode();
  }

  // Setup LongToast
  void showLongToast(String state) {
    Fluttertoast.showToast(
      msg: state,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Get Airplane Mode Status
              ElevatedButton(
                child: const Text('Check Airplane Mode'),
                onPressed: () async {
                  final status =
                      await AirplaneModeChecker.instance.checkAirplaneMode();

                  final state = _stringFromAirplaneModeStatus(status);
                  log(state);
                  showLongToast(state);
                },
              ),
              const SizedBox(height: 20),
              // Listen to Airplane Mode Status
              const Text(
                'Stream',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              StreamBuilder<AirplaneModeStatus>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data');
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Airplane Mode: '),
                        Text(
                          _stringFromAirplaneModeStatus(snapshot.data),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stringFromAirplaneModeStatus(AirplaneModeStatus? status) {
    switch (status) {
      case AirplaneModeStatus.on:
        return 'ON';
      case AirplaneModeStatus.off:
        return 'OFF';
      default:
        return 'OFF';
    }
  }
}
