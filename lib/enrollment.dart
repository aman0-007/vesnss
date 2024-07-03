import 'package:flutter/material.dart';

class Enrollment extends StatefulWidget {
  const Enrollment({super.key});

  @override
  State<Enrollment> createState() => _EnrollmentState();
}

class _EnrollmentState extends State<Enrollment> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _selectedGender;
  String? _selectedYearOfJoin;
  String? _selectedClass;
  String? _selectedYear;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize default values
    _selectedGender = 'Male';
    _selectedYearOfJoin = 'Select year';
    _selectedClass = 'Select class';
    _selectedYear = 'Select year';
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(deviceWidth*0.07), // Optional: margin around the container
          padding: EdgeInsets.all(deviceWidth*0.03), // Optional: padding inside the container
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            border: Border.all(
              color: Colors.grey.withOpacity(0.5), // Grey border with opacity
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(12.0), // Circular edges
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enrollment Form",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color(0xFF2E478A)),),
                  ],
                ),
                const Divider(
                  color: Colors.grey, // Color of the divider
                  thickness: 1, // Thickness of the line
                ),
                SizedBox(height: deviceHeight * 0.023),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("First Name :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A), // Focused border color
                                width: 2.0, // Border width
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0, // Text size
                            color: Colors.black87, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Last Name :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A), // Focused border color
                                width: 2.0, // Border width
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0, // Text size
                            color: Colors.black87, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Year of joining :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedYearOfJoin,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedYearOfJoin = newValue;
                            });
                          },
                          items: <String?>['Select year', '23-24']
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value!,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Class :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedClass,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedClass = newValue;
                            });
                          },
                          items: <String?>['Select class', 'CS', 'IT', 'DSDA', 'AI', 'BCom', 'BAF', 'BMS', 'E-Comm', 'Others']
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value!,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Year :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedYear,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedYear = newValue;
                            });
                          },
                          items: <String?>['Select year', 'FY', 'SY', 'TY']
                              .map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value!,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Roll No :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A), // Focused border color
                                width: 2.0, // Border width
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0, // Text size
                            color: Colors.black87, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Email Id :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5), // Border color
                                width: 1.0, // Border width
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A), // Focused border color
                                width: 2.0, // Border width
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0, // Text size
                            color: Colors.black87, // Text color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Gender :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          items: <String>['Male', 'Female']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Username :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2E478A), // Focused border color
                              width: 2.0, // Border width
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 12.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0, // Text size
                          color: Colors.black87, // Text color
                        ),
                      ),
                    ),
                  ],
                ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Password :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible, // Hide password if not visible
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF2E478A),
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 12.0,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Confirm Password :",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                  ],
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF2E478A), // Focused border color
                              width: 2.0, // Border width
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 12.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0, // Text size
                          color: Colors.black87, // Text color
                        ),
                      ),
                    ),
                  ],
                ),
                ),
                SizedBox(height: deviceHeight * 0.045),

                Padding(
                  padding: EdgeInsets.only(left:deviceWidth*0.02,right:deviceWidth*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E478A),
                          // color: Color(0xFFF5180F)
                          elevation: 5,
                          minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => StudentLoginPage()),
                          // );
                        },
                        child: const Text('Enroll',style: TextStyle(color: Color(0xFFF5180F),fontWeight: FontWeight.bold,fontSize: 20),),
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
