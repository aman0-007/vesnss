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
  String studentId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        studentId = prefs.getString('leaderStudentId') ?? '';
      });
    } catch (e) {
      // Handle error if needed
      print("Something Went Wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: Colors.white, // Set background color to white
          elevation: 4,
          shadowColor: Colors.blueGrey,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Generate barcode widget
                BarcodeWidget(
                  barcode: barcode.Barcode.code39(),
                  data: studentId,
                  height: 50, // Adjust height as needed
                  width: 200, // Adjust width as needed
                  drawText: false, // Hide text below the barcode
                ),
                const SizedBox(height: 8.0),
                // Display the ID below the barcode without label
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Student Id :  "),
                    Text(
                      studentId.isEmpty ? '' : studentId,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
