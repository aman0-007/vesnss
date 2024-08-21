import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vesnss/volunteer/volunteer_detail_barcode.dart'; // Ensure this package is in your `pubspec.yaml`

class VolunteerProfile extends StatefulWidget {
  const VolunteerProfile({super.key});

  @override
  State<VolunteerProfile> createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {
  String name = '';
  String enrollmentId = '';
  String email = '';
  String yearOfJoining = '';
  String department = '';
  int hoursWorked = 0; // Default to 0
  final int totalHours = 120;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve and decode user details from SharedPreferences
    final String? userDetailsJson = prefs.getString('userDetails');
    if (userDetailsJson != null) {
      final Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);

      setState(() {
        name = '${userDetails['name'] ?? ''} ${userDetails['surname'] ?? ''}';
        enrollmentId = userDetails['stud_id'] ?? '';
        email = userDetails['email'] ?? '';
        yearOfJoining = userDetails['yoj'] ?? '';
        department = userDetails['class'] ?? ''; // Assuming 'class' is the department field
        hoursWorked = userDetails['hrs'] ?? 0; // Get hours worked
      });
    } else {
      print('User details not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    double percentageWorked = (hoursWorked / totalHours) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E478A),
        title: const Text(
          'Volunteer Profile',
          style: TextStyle(color: Color(0xFFF5180F), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5180F)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: deviceHeight * 0.09),
            Center(
              child: Container(
                width: 140, // Adjusted width
                height: 140, // Adjusted height
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey[50]!, Colors.white], // Gradient background
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20), // More rounded corners
                  boxShadow: [ // Shadow for better visual depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: hoursWorked.toDouble(),
                        title: 'Completed\n$hoursWorked hrs\n${percentageWorked.toStringAsFixed(1)}%',
                        radius: 60, // Adjusted radius
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change title color to white
                          fontSize: 10, // Smaller font size
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.grey[300]!, // Change grey color
                        value: (totalHours - hoursWorked).toDouble(),
                        title: 'Remaining\n${(totalHours - hoursWorked)} hrs',
                        radius: 60, // Adjusted radius
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Title color for remaining section
                          fontSize: 10, // Smaller font size
                        ),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40, // Adjusted center space
                    sectionsSpace: 0,
                    startDegreeOffset: 0, // Rotate the chart if needed
                  ),
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.07),
            VolunteerBarCode(),

            Center(
              child: IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.all(deviceWidth * 0.07), // Optional: margin around the container
                  padding: EdgeInsets.all(deviceWidth * 0.03), // Optional: padding inside the container
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5), // Grey border with opacity
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Circular edges
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: deviceHeight * 0.030),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Volunteer Profile Details",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2E478A)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey, // Color of the divider
                          thickness: 1, // Thickness of the line
                        ),
                        SizedBox(height: deviceHeight * 0.030),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Name:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                name,
                                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.020),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Enrollment Id:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                enrollmentId,
                                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.020),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Email:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                email,
                                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.020),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Year of joining:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                yearOfJoining,
                                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.020),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Department:",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const Spacer(),
                              Text(
                                department,
                                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.020),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
