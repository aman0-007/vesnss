import 'package:flutter/material.dart';
import 'package:vesnss/api/api_service.dart';
import 'package:vesnss/colors.dart';

class Enrollment extends StatefulWidget {
  const Enrollment({super.key});

  @override
  State<Enrollment> createState() => _EnrollmentState();
}

class _EnrollmentState extends State<Enrollment> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final bool _isPasswordVisible = false;

  String? _selectedGender;
  String? _selectedYearOfJoin;
  String? _selectedClass;
  String? _selectedYear;

  final ApiService apiService = ApiService();
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _rollNoController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedGender = 'M';
    _selectedYearOfJoin = 'Select year';
    _selectedClass = 'Select class';
    _selectedYear = 'Select year';
  }

  // Constants

  static const EdgeInsetsGeometry fieldPadding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0);
  static const TextStyle boldGreyStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.grey);
  static const TextStyle normalBlackStyle = TextStyle(fontSize: 14.0, color: Colors.black87);

  // Reusable widgets
  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: boldGreyStyle),
          const SizedBox(height: 8.0),
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0)),
              contentPadding: fieldPadding,
            ),
            style: normalBlackStyle,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String? value, List<String> items, Function(String?)? onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: boldGreyStyle),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.0)),
              contentPadding: fieldPadding,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _rollNoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedGender == null ||
        _selectedClass == 'Select class' ||
        _selectedYearOfJoin == 'Select year' ||
        _selectedYear == 'Select year') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields correctly.'))
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.'))
      );
      return;
    }

    final data = {
      "name": _firstNameController.text,
      "surname": _lastNameController.text,
      "email": _emailController.text,
      "phone_no": _phoneNumberController.text,
      "yoj": _selectedYearOfJoin!,
      "class_name": _selectedClass!,
      "year": _selectedYear!,
      "gender": _selectedGender!,
      "username": _usernameController.text,
      "password": _passwordController.text,
      "hrs": 0,
      "roll_no": int.tryParse(_rollNoController.text) ?? 0,
    };

    try {
      await apiService.enrollVolunteer(data);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enrollment Successful'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enrollment Failed: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E478A),
        title: const Text(
          'Enrollment',
          style: TextStyle(color: Color(0xFFF5180F), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5180F)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(deviceWidth * 0.07),
          padding: EdgeInsets.all(deviceWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Text("Enrollment Form", style: boldGreyStyle.copyWith(fontSize: 20))),
                const Divider(color: Colors.grey, thickness: 1),
                SizedBox(height: deviceHeight * 0.023),
                buildTextField("First Name :", _firstNameController),
                buildTextField("Last Name :", _lastNameController),
                buildDropdown("Year of joining :", _selectedYearOfJoin, ['Select year', '23-24'], (value) {
                  setState(() {
                    _selectedYearOfJoin = value;
                  });
                }),
                buildDropdown("Class :", _selectedClass, ['Select class', 'CS', 'IT', 'DSDA', 'AI', 'BCom', 'BAF', 'BMS', 'E-Comm', 'Others'], (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                }),
                buildDropdown("Year :", _selectedYear, ['Select year', 'FY', 'SY', 'TY'], (value) {
                  setState(() {
                    _selectedYear = value;
                  });
                }),
                buildTextField("Roll No :", _rollNoController),
                buildTextField("Email Id :", _emailController),
                buildTextField("Phone Number :", _phoneNumberController, keyboardType: TextInputType.phone),
                buildDropdown("Gender :", _selectedGender, ['M', 'F'], (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                }),
                buildTextField("Username :", _usernameController),
                buildTextField("Password :", _passwordController, obscureText: true),
                buildTextField("Confirm Password :", _confirmPasswordController),
                SizedBox(height: deviceHeight * 0.045),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          elevation: 5,
                          minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Enroll', style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
