import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchSensorStatus(String officerId) async {
    final response = await http.get(Uri.parse('http://localhost:5000/get_sensor_status/$officerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch sensor status');
    }
  }
}
