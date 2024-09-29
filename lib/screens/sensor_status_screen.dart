import 'package:flutter/material.dart';
import 'package:sensor_monitoring_app/services/api_service.dart';

class SensorStatusScreen extends StatefulWidget {
  final String officerId;

  SensorStatusScreen({required this.officerId});

  @override
  _SensorStatusScreenState createState() => _SensorStatusScreenState();
}

class _SensorStatusScreenState extends State<SensorStatusScreen> {
  Future<List<dynamic>>? sensorData;

  @override
  void initState() {
    super.initState();
    // Fetch sensor data when the screen is initialized
    sensorData = ApiService.fetchSensorStatus(widget.officerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Status')),
      body: FutureBuilder<List<dynamic>>(
        future: sensorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sensors found.'));
          } else {
            // If data is available, display it in a ListView
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var sensor = snapshot.data![index];
                return ListTile(
                  title: Text('Sensor ID: ${sensor['sensor_id']}'),
                  subtitle: Text(
                      'Location: ${sensor['location']}, Battery: ${sensor['battery_level']}%, Water Level: ${sensor['water_level']}m, Status: ${sensor['alert']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
