import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Define the URL of the API endpoint
const String _apiUrl = 'http://213.210.37.81:3009/admin/addProject';
const String _apiKey = 'NsSvEsAsC'; // Ensure to include the API key

// Function to add a project via API
Future<void> addProject({
  required BuildContext context,
  required TextEditingController projectIdController,
  required TextEditingController projectNameController,
}) async {
  // Create a map with the project's data
  final Map<String, String> data = {
    'project_id': projectIdController.text,
    'project_name': projectNameController.text,
  };

  try {
    // Make a POST request to the API endpoint
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
      body: jsonEncode(data),
    );

    // Check the response status
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project added successfully')),
      );

      // Clear the fields
      projectIdController.clear();
      projectNameController.clear();

    } else {
      // Handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add project: ${response.reasonPhrase}')),
      );
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred while adding project: $e')),
    );
    print('Error occurred while adding project: $e');
  }
}
