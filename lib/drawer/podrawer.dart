import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../adminpo/ApproveEvent.dart';
import '../adminpo/addpo.dart';
import '../adminpo/addproject.dart';
import '../adminpo/addteacher.dart';
import '../adminpo/approveLeader.dart';
import '../adminpo/changeadminpassword.dart';
import '../adminpo/confirmVolunteer.dart';
import '../adminpo/statics.dart';
import '../colors.dart';
import '../enrollment/enrollment.dart';
import '../loginsignup/accountoptionpage.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 64,
                  color: Colors.grey[100],
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(
                    'Welcome to Swayam Sevak',
                    style: TextStyle(
                      color: Colors.redAccent,
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
          _buildDrawerItem(Icons.password, 'Change Password', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPageAdmin()),
            );
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