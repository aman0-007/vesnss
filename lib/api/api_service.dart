import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://213.210.37.81:3009/volunteers/add';
  final String _apiKey = 'NsSvEsAsC';

  Future<void> enrollVolunteer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Enrollment successful!');
    } else {
      print('Failed to enroll volunteer. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to enroll volunteer. Status code: ${response.statusCode}');
    }
  }
}
