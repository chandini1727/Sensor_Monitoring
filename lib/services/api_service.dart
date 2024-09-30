import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update the return type to List<dynamic>
  static Future<List<dynamic>> fetchSensorStatus(String officerId) async {
    final response = await http.get(Uri.parse('http://10.30.6.176:5000/get_sensor_status/$officerId'));

    if (response.statusCode == 200) {
      // Return the response as a List since the server is returning a list of sensors
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch sensor status');
    }
  }
}
