import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  Future<void> enrollVolunteer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/volunteers/add'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Enrollment successful!');
    } else {
      print('Failed to enroll volunteer. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to enroll volunteer. Status code: ${response.statusCode}');
    }
  }
}
