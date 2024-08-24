import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:vesnss/dashboard.dart';
import 'package:vesnss/leader/addEvent.dart';
import 'package:vesnss/leader/leaderprofile.dart';
import 'package:vesnss/leader/markattendance.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedItemPosition = 0;

  final List<Widget> _pages = [
    const Dashboard(),
    const AddEvent(),
    const leaderProfile(),
    const Markattendance(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedItemPosition], // Display the selected page
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.all(12.0),  // Floating effect
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.pinned,
          snakeShape: SnakeShape.circle,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding

          snakeViewColor: Color(0xFF2E478A), // Blue color for the snake view
          selectedItemColor: Colors.white,  // Selected icon color
          unselectedItemColor: Color(0xFFF5180F), // Red color for unselected items

          showUnselectedLabels: false,
          showSelectedLabels: true,

          currentIndex: _selectedItemPosition,
          onTap: (index) {
            setState(() {
              _selectedItemPosition = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Attendance'),
          ],
        ),
      ),
    );
  }
}
