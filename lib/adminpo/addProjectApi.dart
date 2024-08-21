import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
      Uri.parse('http://213.210.37.81:3009/admin/addProject'),
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
        text: 'Project added successfully',
      );


      // Clear the fields
      projectIdController.clear();
      projectNameController.clear();

    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error!',
        text: 'Failed to add project: ${response.reasonPhrase}',
      );
    }
  } catch (e) {
    // Handle any errors that occur during the request
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error!',
      text: 'Error occurred while adding project.',
    );
  }
}
