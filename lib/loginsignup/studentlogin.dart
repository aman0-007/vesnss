import 'package:flutter/material.dart';
import 'package:vesnss/api/loginapi.dart';
import 'package:vesnss/dashboard.dart';

class Studentlogin extends StatefulWidget {
  const Studentlogin({Key? key}) : super(key: key);

  @override
  State<Studentlogin> createState() => _StudentloginState();
}

class _StudentloginState extends State<Studentlogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final LoginApi loginvol = LoginApi();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter both username and password.'))
      );
      return;
    }

    try {
      await loginvol.login(username, password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: $e'))
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
          'Student Login',
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
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(deviceWidth * 0.07), // Optional: margin around the container
              padding: EdgeInsets.all(deviceWidth * 0.03), // Optional: padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Grey border with opacity
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(12.0), // Circular edges
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: deviceHeight * 0.030),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Student Login",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2E478A)),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey, // Color of the divider
                    thickness: 1, // Thickness of the line
                  ),
                  SizedBox(height: deviceHeight * 0.030),
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Username :",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
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
                            controller: _usernameController,
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
                  SizedBox(height: deviceHeight * 0.020),
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password :",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
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
                  SizedBox(height: deviceHeight * 0.035),
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E478A),
                            elevation: 5,
                            minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Color(0xFFF5180F), fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.030),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
