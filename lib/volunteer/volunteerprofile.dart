import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // Ensure this package is in your `pubspec.yaml`

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
            SizedBox(height: deviceHeight * 0.05),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: CircularPercentIndicator(
                  radius: 130.0,
                  lineWidth: 15.0,
                  percent: hoursWorked / totalHours,
                  center: Text(
                    '$hoursWorked hrs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  progressColor: Colors.green, // Completed hours color
                  backgroundColor: Colors.grey[300]!, // Remaining hours color
                  circularStrokeCap: CircularStrokeCap.round,
                  // Add a white border around the indicator
                  // addBorder: true,
                  // borderWidth: 5.0,
                  // borderColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.03),
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
