import 'package:flutter/material.dart';
import 'package:vesnss/dashboard.dart';
import 'package:vesnss/enrollment/enrollment.dart';
import 'package:vesnss/loginsignup/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accountoptionpage extends StatefulWidget {
  const Accountoptionpage({super.key});

  @override
  State<Accountoptionpage> createState() => _AccountoptionpageState();
}

class _AccountoptionpageState extends State<Accountoptionpage> {
  bool _isLoggedIn = false; // To store login status

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when the widget is initialized
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });

    if (_isLoggedIn) {
      // Navigate to Dashboard if user is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: deviceHeight * 0.06),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Enrollment()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Enroll Yourself",
                  style: TextStyle(
                    color: Color(0xFFF5180F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Color(0xFFF5180F), size: 25),
                SizedBox(width: deviceWidth * 0.07),
              ],
            ),
          ),
          SizedBox(height: deviceHeight * 0.16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: deviceWidth * 0.6,
                height: deviceHeight * 0.4,
                child: Image.asset("assets/logo/nss.png"),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.067),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E478A),
                  elevation: 5,
                  minimumSize: Size(deviceWidth * 0.7, deviceHeight * 0.057),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFF5180F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
