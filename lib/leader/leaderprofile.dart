import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/leader/leader_detail_barcode.dart';

class leaderProfile extends StatefulWidget {
  const leaderProfile({super.key});

  @override
  State<leaderProfile> createState() => _leaderProfileState();
}

class _leaderProfileState extends State<leaderProfile> {
  String name = "";
  String enrollmentId = "";
  String email = "";
  String yearOfJoining = "";
  String department = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('leaderName') ?? 'Not Available';
      enrollmentId = prefs.getString('leaderUniqueId') ?? 'Not Available';
      email = prefs.getString('leaderEmail') ?? 'Not Available';
      yearOfJoining = prefs.getString('yearOfJoining') ?? 'Not Available';
      department = prefs.getString('department') ?? 'Not Available';
    });
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
          'Profile',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black12,
                      backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image path
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Implement edit functionality here
                        },
                      ),
                    ),
                  ],
                ),
              ],
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
                              "Profile Details",
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
                              Spacer(),
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
                              Spacer(),
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
                              Spacer(),
                              Text(
                                email,
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
            const LeaderBarCode(),
          ],
        ),
      ),
    );
  }
}
