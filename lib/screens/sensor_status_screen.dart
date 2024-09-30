import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensor_monitoring_app/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class SensorStatusScreen extends StatefulWidget {
  final String officerId;

  SensorStatusScreen({required this.officerId});

  @override
  _SensorStatusScreenState createState() => _SensorStatusScreenState();
}

class _SensorStatusScreenState extends State<SensorStatusScreen> {
  List<dynamic> sensorData = [];
  Timer? _timer;  // Timer object to handle periodic fetches

  @override
  void initState() {
    super.initState();
    _fetchSensorStatus();  // Fetch the sensor data initially
    _startPeriodicFetch();  // Start fetching data every hour
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to start fetching data every hour
  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(hours: 1), (Timer timer) {
      _fetchSensorStatus();
    });
  }

  // Fetch sensor data from the server
  Future<void> _fetchSensorStatus() async {
    try {
      final data = await ApiService.fetchSensorStatus(widget.officerId);
      setState(() {
        sensorData = data;
      });
    } catch (error) {
      print('Error fetching sensor data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set system orientation to portrait for better readability
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      backgroundColor: Colors.white, // Set the entire background to white
      appBar: AppBar(
        title: Text('Sensor Status'),
        backgroundColor: Colors.blue, // AppBar color
      ),
      body: sensorData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 12.0,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Sensor ID',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Location',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Battery Level',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Water Level',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Last Updated',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                        ),
                      ),
                    ],
                    rows: sensorData.map<DataRow>((sensor) {
                      // Determine the row color based on the conditions
                      Color rowColor = Colors.white;
                      if (sensor['battery_level'] < 20) {
                        rowColor = Colors.yellow.withOpacity(0.3); // Highlight with yellow for low battery
                      } else if (_isOldReading(sensor['last_update'])) {
                        rowColor = Colors.red.withOpacity(0.3); // Highlight with red for no recent updates
                      }

                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return rowColor; // Apply the determined row color
                          },
                        ),
                        cells: <DataCell>[
                          DataCell(Text(sensor['sensor_id'].toString())),
                          DataCell(Text(sensor['location'].toString())),
                          DataCell(Text(sensor['battery_level'].toString())),
                          DataCell(Text(sensor['water_level'].toString())),
                          DataCell(Text(sensor['last_update'].toString())),
                          DataCell(Text(sensor['alert'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
      // Floating action button to manually fetch data
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchSensorStatus, // Fetch data when button is pressed
        child: Icon(Icons.refresh), // Icon for the button
        backgroundColor: Colors.blue, // Button background color
      ),
    );
  }

  // Helper function to check if the reading is older than 4 hours
  bool _isOldReading(String lastUpdate) {
    try {
      // Define the date format that matches your date string
      DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");

      // Parse the date string into a DateTime object
      DateTime lastUpdateTime = dateFormat.parse(lastUpdate, true).toLocal();

      // Compare the parsed date with the current time
      return DateTime.now().difference(lastUpdateTime).inHours > 4;
    } catch (e) {
      print('Date parsing error: $e');
      return true; // If parsing fails, treat it as an old reading
    }
  }
}
