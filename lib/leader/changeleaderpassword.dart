import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPageLeader extends StatefulWidget {
  @override
  _ForgotPasswordPageLeaderState createState() => _ForgotPasswordPageLeaderState();
}

class _ForgotPasswordPageLeaderState extends State<ForgotPasswordPageLeader> {
  final Color primaryBlue = const Color(0xFF2E478A);
  final Color primaryRed = const Color(0xFFF5180F);

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('leaderEmail');
  }

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.custom,
        title: 'Error',
        text: 'Passwords do not match!',
      );
      return;
    }

    if (email == null) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.custom,
        title: 'Error',
        text: 'Email address not found!',
      );
      return;
    }
    print("===================================================================");
    print(email);
    print(_newPasswordController.text);

    final response = await http.put(
      Uri.parse('http://213.210.37.81:3009/leader/newPassword'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode({
        'email': email,
        'newPassword': _newPasswordController.text,
      }),
    );



    if (response.statusCode == 200 || response.statusCode == 201) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'Success',
        text: 'Password updated successfully!',
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Error',
        text: 'Failed to update password. Please try again. \nError Code: ${response.statusCode}\nResponse: ${response.body}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(deviceWidth * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitleRow(deviceHeight),
              SizedBox(height: deviceHeight * 0.05),
              _buildNewField(
                'New Password',
                'Enter your new password',
                _newPasswordController,
              ),
              SizedBox(height: deviceHeight * 0.02),
              _buildConfirmField(
                'Confirm Password',
                'Re-enter your new password',
                _confirmPasswordController,
              ),
              SizedBox(height: deviceHeight * 0.05),
              _buildUpdateButton(deviceWidth, deviceHeight),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: primaryBlue,
      title: Text(
        'Update Password',
        style: TextStyle(
          color: primaryRed,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: primaryRed),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 2.0,
    );
  }

  Widget _buildTitleRow(double deviceHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        const Text(
          'RESET',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            const Text(
              'PASSWORD',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewField(String labelText, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey[700]),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryBlue,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
      ),
      obscureText: true,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildConfirmField(String labelText, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey[700]),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryBlue,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 12.0,
        ),
      ),
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildUpdateButton(double deviceWidth, double deviceHeight) {
    return ElevatedButton(
      onPressed: _updatePassword,
      child: const Text(
        'Update',
        style: TextStyle(fontSize: 20.0),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.018),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5.0,
      ),
    );
  }
}
