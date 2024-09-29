import 'package:flutter/material.dart';
import 'package:sensor_monitoring_app/services/api_service.dart';
//import 'package:flutter/material.dart';
//import '../api_service.dart';  // Make sure you import your ApiService here

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
            // Display data in a DataTable
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allow horizontal scrolling
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sensor ID')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Battery Level')),
                  DataColumn(label: Text('Water Level')),
                  DataColumn(label: Text('Status')),
                ],
                rows: snapshot.data!.map<DataRow>((sensor) {
                  return DataRow(
                    cells: [
                      DataCell(Text(sensor['sensor_id'])),
                      DataCell(Text(sensor['location'])),
                      DataCell(Text('${sensor['battery_level']}%')),
                      DataCell(Text('${sensor['water_level']} m')),
                      DataCell(Text(sensor['alert'])),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
