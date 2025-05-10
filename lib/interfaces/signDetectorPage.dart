import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/background.dart';
import 'package:wesal_app_final/design/BarWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wesal_app_final/widgets/detector/uiDetector.dart';

class signDetectorPage extends StatelessWidget {
  const signDetectorPage({super.key});

  // Future<void> sendRequest() async {
  //   final url = Uri.parse(
  //       'http://127.0.0.1:5000/receive'); // For Android emulator use 10.0.2.2 instead of localhost

  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'message': 'Hello from Flutter!'}),
  //   );

  //   if (response.statusCode == 200) {
  //     print('Successfully sent request');
  //   } else {
  //     print('Failed to send request');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GradientAndContent(
        widget1: barWidget(),
        widget2: ButtonColumn(),
        // widget2: ElevatedButton(
        //   onPressed: () async {
        //     final url = Uri.parse('http://127.0.0.1:5000/receive');
        //     await http.post(
        //       url,
        //       headers: {'Content-Type': 'application/json'},
        //       body: jsonEncode({'message': 'start_model'}),
        //     );
        //   },
        //   child: const Text('Start Model'),
        // ),
      ),
    ));
  }
}
