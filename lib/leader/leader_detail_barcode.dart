import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode/barcode.dart' as barcode;
import 'package:barcode_widget/barcode_widget.dart';

class LeaderBarCode extends StatefulWidget {
  const LeaderBarCode({super.key});

  @override
  State<LeaderBarCode> createState() => _LeaderBarCodeState();
}

class _LeaderBarCodeState extends State<LeaderBarCode> {
  String leaderId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        leaderId = prefs.getString('leaderUniqueId') ?? '';
      });
    } catch (e) {
      log("Something Went Wrong" as num);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: Colors.blueGrey,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Student Id: "),
                            Text(leaderId),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Generate barcode widget
                        BarcodeWidget(
                          barcode: barcode.Barcode.code39(),
                          data: leaderId,
                          height: 50, // Adjust height as needed
                          width: 200, // Adjust width as needed
                          drawText: false, // Hide text below the barcode
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
