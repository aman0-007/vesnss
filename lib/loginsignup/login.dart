import 'package:flutter/material.dart';
import 'package:vesnss/api/loginapi.dart';
import 'package:vesnss/dashboard.dart';
import 'package:vesnss/themes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  late LoginApi loginvol;

  @override
  void initState() {
    super.initState();
    loginvol = LoginApi(context); // Initialize LoginApi here
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both username and password.')),
      );
      return;
    }

    try {
      await loginvol.login(username, password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme(Theme.of(context).textTheme); // Apply the custom theme

    return Theme(
      data: theme.light(), // Apply the light theme here
      child: Scaffold(
        backgroundColor: theme.light().colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.light().colorScheme.primary, // Blue for app bar
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.light().colorScheme.onPrimary, // White color for icon
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back!",
                    style: theme.light().textTheme.headlineMedium?.copyWith(
                      color: theme.light().colorScheme.primary, // Blue for heading
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please sign in to continue",
                    style: theme.light().textTheme.bodyMedium?.copyWith(
                      color: theme.light().colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.light().colorScheme.secondaryContainer, // Light Blue background for container
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: theme.light().textTheme.bodyMedium?.copyWith(
                          color: theme.light().colorScheme.onSecondaryContainer.withOpacity(0.7), // Light Blue for label
                        ),
                        filled: true,
                        fillColor: theme.light().colorScheme.secondaryContainer, // Light Blue for input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.light().colorScheme.secondaryContainer, // Light Blue background for container
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: theme.light().textTheme.bodyMedium?.copyWith(
                          color: theme.light().colorScheme.onSecondaryContainer.withOpacity(0.7), // Light Blue for label
                        ),
                        filled: true,
                        fillColor: theme.light().colorScheme.secondaryContainer, // Light Blue for input field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: theme.light().colorScheme.onSecondaryContainer.withOpacity(0.7), // Light Blue for icon
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.light().colorScheme.primary, // Blue for button
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: _login,
                      child: Text(
                        'Login',
                        style: theme.light().textTheme.bodyLarge?.copyWith(
                          color: theme.light().colorScheme.onPrimary, // White text on blue button
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
