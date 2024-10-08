import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode/barcode.dart' as barcode;
import 'package:barcode_widget/barcode_widget.dart';

class VolunteerBarCode extends StatefulWidget {
  const VolunteerBarCode({super.key});

  @override
  State<VolunteerBarCode> createState() => _VolunteerBarCodeState();
}

class _VolunteerBarCodeState extends State<VolunteerBarCode> {
  String studentId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve and decode user details from SharedPreferences
    final String? userDetailsJson = prefs.getString('userDetails');
    if (userDetailsJson != null) {
      final Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);

      setState(() {
        studentId = userDetails['stud_id'] ?? '';
      });
    } else {
      print('User details not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.white, // Set background color to white
                elevation: 4,
                shadowColor: Colors.blueGrey,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BarcodeWidget(
                        barcode: barcode.Barcode.code39(),
                        data: studentId,
                        height: 50, // Adjust height as needed
                        width: 200, // Adjust width as needed
                        drawText: false, // Hide text below the barcode
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        studentId.isEmpty ? '' : studentId,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
