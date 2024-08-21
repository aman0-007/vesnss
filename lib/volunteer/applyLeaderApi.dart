import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> addLeader({
  required BuildContext context,
  required String name,
  required String username,
  required String password,
  required String groupName,
  required String email,
  required stud_id,
}) async {
  final Map<String, dynamic> data = {
    'name': name,
    'username': username,
    'password': password,
    'group_name': groupName,
    'email': email,
    'stud_id': stud_id,
  };

  try {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/leader/addLeader'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC', // Include API key if required
      },
      body: jsonEncode(data),
    );

    // Debugging: Print the response status code and body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leader added successfully!')),
      );
    } else {
      // More detailed error handling
      String errorMessage = 'Failed teo add leader. Please try again later.';
      try {
        final responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('error')) {
          errorMessage = responseBody['error'] ?? errorMessage;
        }
      } catch (e) {
        // Handle JSON decoding errors
        print('Error parsing error message: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    // Catch network or JSON encoding errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}
