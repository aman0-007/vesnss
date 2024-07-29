import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  final String _baseUrl = 'http://213.210.37.81:3009/volunteers/login';
  final String _apiKey = 'NsSvEsAsC'; // You may not need this API key for login, adjust if needed.

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey, // Include this if the API requires it for login as well
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful');
      // Optionally parse response and handle user session
    } else {
      print('Failed to login. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }
}
