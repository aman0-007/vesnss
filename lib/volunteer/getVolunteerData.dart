import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Getvolunteerdata extends StatefulWidget {
  const Getvolunteerdata({super.key});

  @override
  State<Getvolunteerdata> createState() => _GetvolunteerdataState();
}

class _GetvolunteerdataState extends State<Getvolunteerdata> {
  @override
  void initState() {
    super.initState();
    _fetchAndSaveUserData(); // Fetch user data and save it in SharedPreferences
  }

  Future<void> _fetchAndSaveUserData() async {
    // Retrieve username from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    if (username.isNotEmpty) {
      // Fetch data from API
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/leader/notselected'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC', // Use appropriate API key if needed
        },
      );

      if (response.statusCode == 200) {
        // Parse response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> data = responseBody['data'];

        // Find user data by username
        final user = (data as List).firstWhere(
              (user) => user['username'] == username,
          orElse: () => null,
        );

        if (user != null) {
          // Save user details to SharedPreferences
          await prefs.setString('userDetails', jsonEncode(user));
          print('User details saved in shared preferences');
        } else {
          print('User not found in the data');
        }
      } else {
        print('Failed to fetch data from API. Status code: ${response.statusCode}');
      }

      // Navigate to the next page or pop this screen
      Navigator.of(context).pop();
    } else {
      print('Username not found in SharedPreferences');
      // Optionally handle the error, e.g., navigate to login screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(), // Show loading indicator while fetching
      ),
    );
  }
}
