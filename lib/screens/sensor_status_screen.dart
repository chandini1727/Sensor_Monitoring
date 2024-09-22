import 'package:flutter/material.dart';
import 'package:sensor_monitoring_app/services/api_service.dart';

class SensorStatusScreen extends StatefulWidget {
  final String officerId;
  SensorStatusScreen({required this.officerId});

  @override
  _SensorStatusScreenState createState() => _SensorStatusScreenState();
}

class _SensorStatusScreenState extends State<SensorStatusScreen> {
  String? _alertMessage = "Fetching sensor status...";
  Map<String, dynamic>? sensorData;

  @override
  void initState() {
    super.initState();
    fetchSensorStatus();
  }

  Future<void> fetchSensorStatus() async {
    sensorData = await ApiService.fetchSensorStatus(widget.officerId);
    setState(() {
      _alertMessage = sensorData!['alert'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Status'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sensorData != null) ...[
                Text('Sensor ID: ${sensorData!['sensor_id']}'),
                Text('Location: ${sensorData!['location']}'),
                Text('Battery Level: ${sensorData!['battery_level']}%'),
                Text('Water Level: ${sensorData!['water_level']} meters'),
                SizedBox(height: 20),
              ],
              Text(
                _alertMessage!,
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchSensorStatus,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
