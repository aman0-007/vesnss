import 'dart:async'; // Import the Timer class
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/dashboard.dart';
import 'package:vesnss/loginsignup/accountoptionpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Use SplashScreen as entry point
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _showSplashScreen(); // Show splash screen and handle navigation after 4 seconds
  }

  Future<void> _showSplashScreen() async {
    // Show the splash screen for 4 seconds
    await Future.delayed(const Duration(seconds: 4));

    // Check login status and navigate accordingly
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(_createPageTransition(const Dashboard()));
    } else {
      Navigator.of(context).pushReplacement(_createPageTransition(const Accountoptionpage()));
    }
  }

  // Method to create a custom page transition
  PageRouteBuilder _createPageTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the animations
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var fadeAnimation = Tween(begin: begin, end: end).animate(CurvedAnimation(parent: animation, curve: curve));
        var scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animation, curve: curve));

        // Apply the animations
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Align center horizontally
        children: [
          Expanded(
            child: Center( // Center the content vertically within this space
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the logo image
                  Image.asset(
                    'assets/logo/nss.png',
                    width: 200, // Adjust the size as needed
                    height: 200, // Adjust the size as needed
                  ),
                  const SizedBox(height: 25), // Add some space between the logo and the text
                  // Display the text below the image
                  const Text(
                    '|| NOT ME BUT YOU ||',
                    style: TextStyle(
                      color: AppColors.primaryBlue, // Text color
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Display the "Created by AMAN DWIVEDI" text and logo at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // Padding to the bottom of the screen
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
              children: [
                // Text
                const Text(
                  'Created by PSHG TECHNOLOGIES',
                  style: TextStyle(
                    color: Colors.grey, // Text color
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8), // Space between the logo and text
                // Logo Image
                Image.asset(
                  'assets/logo/pshg.png',
                  width: 40, // Set width for the logo
                  height: 40, // Set height for the logo
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
