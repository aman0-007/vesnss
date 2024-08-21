import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

Future<void> addPo({
  required BuildContext context,
  required String name,
  required String username,
  required String password,
  required String email,
}) async {
  final Map<String, String> data = {
    'name': name,
    'username': username,
    'password': password,
    'email': email,
  };

  try {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/admin/addPO'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC', // Include API key if required
      },
      body: jsonEncode(data),
    );

    // Debugging: Print the response status code and body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success!',
        text: 'PO added successfully!',
      );
    } else {
      // More detailed error handling
      String errorMessage = 'Failed to add PO. Please try again later.';
      try {
        final responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('error')) {
          errorMessage = responseBody['error'] ?? errorMessage;
        }
      } catch (e) {
        // Handle JSON decoding errors
        print('Error parsing error message: $e');
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error!',
        text: errorMessage,
      );
    }
  } catch (e) {
    // Catch network or JSON encoding errors
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error!',
      text: 'An error occurred: $e',
    );
  }
}
