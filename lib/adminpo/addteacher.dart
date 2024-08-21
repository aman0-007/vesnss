import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vesnss/colors.dart';
import 'package:vesnss/adminpo/addTeacherApi.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedProjectId; // To store selected project ID
  List<String> _projectIds = []; // List to store project IDs

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/admin/fetchProjects'),
      headers: {'x-api-key': 'NsSvEsAsC'}, // Include the API key if required
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> projects = responseBody['data'];

      setState(() {
        _projectIds = projects.map((project) => project['project_id'] as String).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch projects: ${response.reasonPhrase}')),
      );
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
                    _buildTextField("Name:", _nameController, deviceWidth),
                    _buildTextField("Username:", _usernameController, deviceWidth),
                    _buildTextField("Password:", _passwordController, deviceWidth, isPassword: true),
                    _buildTextField("Email:", _emailController, deviceWidth),
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
        'Add Teacher',
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
        "Add Teacher",
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

  Widget _buildTextField(String label, TextEditingController controller, double deviceWidth, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),

          TextField(
            controller: controller,
            obscureText: isPassword,
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
          const SizedBox(height: 4.0),
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
            'Project ID:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
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
                value: _selectedProjectId,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'Select Project ID',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                items: _projectIds.map((String projectId) {
                  return DropdownMenuItem<String>(
                    value: projectId,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(projectId),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProjectId = newValue;
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
              addTeacher(
                context: context,
                nameController: _nameController,
                usernameController: _usernameController,
                passwordController: _passwordController,
                emailController: _emailController,
                projectId: _selectedProjectId, // Pass the selected project ID
              );
            },
            child: const Text(
              'Add Teacher',
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
