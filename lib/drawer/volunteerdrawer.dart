import 'package:flutter/material.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/leader/addEvent.dart';
import 'package:vesnss/enrollment/enrollment.dart';
import 'package:vesnss/profile.dart';

class AppDrawer extends StatelessWidget {
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
              MaterialPageRoute(builder: (context) => const Profile()),
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

  Widget _buildLogoutItem(BuildContext context) { // Accept context as a parameter
    return ListTile(
      leading: Icon(Icons.logout, color: AppColors.primaryRed),
      title: Text(
        'Logout',
        style: TextStyle(color: AppColors.primaryRed),
      ),
      onTap: () {
        // Implement logout functionality here
        Navigator.pop(context);
      },
    );
  }
}
