import 'package:flutter/material.dart';
import 'screens/sensor_status_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Monitoring',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: SensorStatusScreen(officerId: 'officer_123'), // Use dynamic officer ID
    );
  }
}
