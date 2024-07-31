import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/drawer/admindrawer.dart';
import 'package:vesnss/drawer/leaderdrawer.dart';
import 'package:vesnss/drawer/podrawer.dart';
import 'package:vesnss/drawer/volunteerdrawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  String userType = 'Unknown'; // Default value
  final List<String> _imgList = [
    'assets/carousel/slider1.png',
    'assets/carousel/slider1.png',
    'assets/carousel/slider1.png',
    'assets/carousel/slider1.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('userType') ?? 'Unknown';
    });
  }

  List<Widget> generateImageTiles() {
    return _imgList.map((element) => ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        element,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.primaryRed),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: _getDrawerBasedOnUserType(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: deviceHeight * 0.02),
            CarouselSlider(
              items: generateImageTiles(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imgList.asMap().entries.map((entry) {
                int index = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? AppColors.primaryRed
                        : AppColors.primaryBlue,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDrawerBasedOnUserType() {
    switch (userType) {
      case 'Volunteer':
        return const VolunteerDrawer();
      case 'Teacher':
        return const AdminDrawer();
      case 'Leader':
        return const LeaderDrawer();
      case 'PO':
        return const PODrawer();
      default:
        return Drawer( // Default drawer if userType is unknown
          child: Center(
            child: Text('No drawer available'),
          ),
        );
    }
  }
}
