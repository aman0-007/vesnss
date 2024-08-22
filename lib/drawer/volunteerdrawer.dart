import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/loginsignup/accountoptionpage.dart';
import 'package:vesnss/volunteer/applyLeader.dart';
import 'package:vesnss/volunteer/volunteer_detail_barcode.dart';
import 'package:vesnss/volunteer/volunteerprofile.dart';

class VolunteerDrawer extends StatelessWidget {
  const VolunteerDrawer({super.key});

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
          _buildDrawerItem(Icons.person, 'Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VolunteerProfile()),
            );
          }),
          _buildDrawerItem(Icons.person, 'Apply Leader', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddLeader()),
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
        await prefs.setBool('isLoggedIn', false); // Clear login status

        // Navigate to the login page after logout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Accountoptionpage()),
        );
      },
    );
  }
}
