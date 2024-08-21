import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Function to add a teacher via API
Future<void> addTeacher({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController usernameController,
  required TextEditingController passwordController,
  required TextEditingController emailController,
  required String? projectId, // Update parameter type
}) async {
  // Create a map with the teacher's data
  final Map<String, String?> data = {
    'name': nameController.text,
    'username': usernameController.text,
    'password': passwordController.text,
    'email': emailController.text,
    'project_id': projectId, // Use the projectId directly
  };

  try {
    // Make a POST request to the API endpoint
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/admin/addTeacher'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode(data),
    );

    // Check the response status
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher added successfully')),
      );

      // Clear the fields
      nameController.clear();
      usernameController.clear();
      passwordController.clear();
      emailController.clear();

    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add teacher: ${response.reasonPhrase}')),
      );
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred while adding teacher: $e')),
    );
    print('Error occurred while adding teacher: $e');
  }
}
