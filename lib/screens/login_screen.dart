import 'package:flutter/material.dart';
import 'sensor_status_screen.dart'; // Import the next screen to navigate after login

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _officerIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle login
  void _login() {
    // Replace this with your actual login logic
    String officerId = _officerIdController.text;
    String password = _passwordController.text;
    print(officerId);
    // For demonstration purposes, you can simply navigate to the next screen if login is "successful"
    if (officerId.isNotEmpty && password.isNotEmpty) {
      // Navigate to Sensor Status Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SensorStatusScreen(officerId: officerId),
        ),
      );
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter officer ID and password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _officerIdController,
              decoration: InputDecoration(
                labelText: 'Officer ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide password input
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
