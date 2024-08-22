import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/adminpo/ApproveEvent.dart';
import 'package:vesnss/adminpo/addpo.dart';
import 'package:vesnss/adminpo/addproject.dart';
import 'package:vesnss/adminpo/addteacher.dart';
import 'package:vesnss/adminpo/approveLeader.dart';
import 'package:vesnss/adminpo/confirmVolunteer.dart';
import 'package:vesnss/adminpo/statics.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/leader/addEvent.dart';
import 'package:vesnss/enrollment/enrollment.dart';
import 'package:vesnss/loginsignup/accountoptionpage.dart';

class PODrawer extends StatelessWidget {
  const PODrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 47,
                  backgroundImage: const AssetImage('assets/avatar.png'),
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.event, 'Approve Event', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ApproveEvent()),
            );
          }),
          _buildDrawerItem(Icons.school, 'Enroll Student', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Enrollment()),
            );
          }),
          _buildDrawerItem(Icons.school, 'Confirm Volunteer', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Confirmvolunteer()),
            );
          }),
          _buildDrawerItem(Icons.add_business, 'Add Project', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProject()),
            );
          }),
          _buildDrawerItem(Icons.person_add, 'Add Teacher', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTeacher()),
            );
          }),
          _buildDrawerItem(Icons.group_add, 'Add PO', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPo()),
            );
          }),
          _buildDrawerItem(Icons.verified, 'Approve Leader', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Approveleader()),
            );
          }),
          _buildDrawerItem(Icons.settings, 'Settings', () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.bar_chart, 'Stats', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Statics()),
            );
          }),
          _buildLogoutItem(context), // Pass context to logout item
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlack),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: AppColors.primaryRed),
      title: const Text(
        'Logout',
        style: TextStyle(color: AppColors.primaryRed),
      ),
      onTap: () async {
        // Perform logout operations
        final prefs = await SharedPreferences.getInstance();

        // Remove user-related data from SharedPreferences
        await prefs.remove('userType');
        await prefs.remove('userStatus');
        await prefs.remove('userRole');
        await prefs.clear();
        await prefs.setBool('isLoggedIn', false);

        // Navigate to the login page after logout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Accountoptionpage()),
        );
      },
    );
  }
}