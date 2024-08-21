import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/volunteer/applyLeaderApi.dart';

class AddLeader extends StatefulWidget {
  const AddLeader({super.key});

  @override
  _AddLeaderState createState() => _AddLeaderState();
}

class _AddLeaderState extends State<AddLeader> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedGroupName; // To store selected group name

  final List<String> _groupNames = [
    'AVYAY',
    'KARMAVEER',
    'SUNRISERS',
    'NAVYUG',
    'EKLAVYA',
    'SANKALP',
    'AAROHAN',
    'DISHA'
  ]; // Predefined group names


  String? studId;
  @override
  void initState() {
    super.initState();
    _loadUserData();

  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve and decode user details from SharedPreferences
    final String? userDetailsJson = prefs.getString('userDetails');
    if (userDetailsJson != null) {
      final Map<String, dynamic> userDetails = jsonDecode(userDetailsJson);

      setState(() {
        _nameController.text = '${userDetails['name'] ?? ''} ${userDetails['surname'] ?? ''}';
        _emailController.text = userDetails['email'] ?? '';
        studId = userDetails['stud_id'] ?? '';
      });
    } else {
      print('User details not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;


    return Scaffold(
    backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(deviceWidth * 0.07),
              padding: EdgeInsets.all(deviceWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(deviceHeight),
                    _buildDivider(),
                    SizedBox(height: deviceHeight * 0.01),
                    _buildTextField("Name:", _nameController, deviceWidth, isEditable: false),
                    _buildTextField("Username:", _usernameController, deviceWidth),
                    _buildTextField("Password:", _passwordController, deviceWidth, isPassword: true),
                    _buildTextField("Email:", _emailController, deviceWidth, isEditable: false),
                    _buildDropdown(deviceWidth),
                    SizedBox(height: deviceHeight * 0.030),
                    _buildAddButton(deviceWidth, deviceHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      title: const Text(
        'Add Leader',
        style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildTitle(double deviceHeight) {
    return Padding(
      padding: EdgeInsets.only(top: deviceHeight * 0.007),
      child: const Text(
        "Add Leader",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, double deviceWidth, {bool isPassword = false, bool isEditable = true}) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          TextField(
            controller: controller,
            obscureText: isPassword,
            enabled: isEditable,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(double deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Group Name:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGroupName,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Select Group Name',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                items: _groupNames.map((String groupName) {
                  return DropdownMenuItem<String>(
                    value: groupName,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(groupName),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroupName = newValue;
                  });
                },
                isExpanded: true,
                icon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              elevation: 5,
              minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
            ),
            onPressed: () {
              if (_nameController.text.isEmpty ||
                  _usernameController.text.isEmpty ||
                  _passwordController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _selectedGroupName == null) {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  title: 'Warning!',
                  text: 'Please fill in all fields.',
                );
                return;
              }

              addLeader(
                context: context,
                name: _nameController.text,
                username: _usernameController.text,
                password: _passwordController.text,
                groupName: _selectedGroupName!,
                email: _emailController.text,
                stud_id: studId,
              );
            },
            child: const Text(
              'Apply Leader',
              style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
