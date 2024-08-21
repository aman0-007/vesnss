import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success!',
        text: 'Teacher added successfully.',
      );

      // Clear the fields
      nameController.clear();
      usernameController.clear();
      passwordController.clear();
      emailController.clear();

    } else {
      // Handle failure
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error!',
        text: 'Failed to add teacher: ${response.reasonPhrase}',
      );
    }
  } catch (e) {
    // Handle any errors that occur during the request
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error!',
      text: 'Error occurred while adding teacher.',
    );
  }
}
