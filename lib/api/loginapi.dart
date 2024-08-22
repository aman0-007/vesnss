import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';

class LoginApi {
  final BuildContext context;

  LoginApi(this.context);

  Future<void> login(String username, String password) async {
    bool isVolunteersLoginSuccessful = await _loginVolunteer(username, password);
    bool isTeacherLoginSuccessful = !isVolunteersLoginSuccessful
        ? await _loginTeacher(username, password)
        : false;
    bool isLeaderLoginSuccessful = !isVolunteersLoginSuccessful && !isTeacherLoginSuccessful
        ? await _loginLeader(username, password)
        : false;

    if (isVolunteersLoginSuccessful) {
     // await _fetchAndSaveStatus(username);
      await _saveUserType('Volunteer');
      //await _fetchAndSaveUserDetails(username, 'volunteer');
    } else if (isTeacherLoginSuccessful) {
      await _fetchAndSaveRole(username);
      await _saveUserType('Teacher');
    } else if (isLeaderLoginSuccessful) {
      await _saveUserType('Leader');
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Login Failed',
        text: 'Failed to login to all endpoints.',
      );
      throw Exception('Failed to login to all endpoints.');
    }

    // Save login status and username in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
  }

  Future<bool> _loginVolunteer(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/volunteers/login'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final Map<String, dynamic> volunteerData = responseBody['data'];

      // // Save volunteer data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userDetails', jsonEncode(volunteerData));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _loginTeacher(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/admin/TeacherLogin'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _loginLeader(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/leader/leaderLogin'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final Map<String, dynamic> leaderData = responseBody['data'];

      // Save leader data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('leaderId', leaderData['id']);
      await prefs.setString('leaderUniqueId', leaderData['leader_id']);
      await prefs.setString('leaderStudentId', leaderData['stud_id']);
      await prefs.setString('leaderName', leaderData['name']);
      await prefs.setString('leaderUsername', leaderData['username']);
      await prefs.setString('groupName', leaderData['group_name']);
      await prefs.setString('teacherId', leaderData['teacher_id']);
      await prefs.setString('role', leaderData['role']);
      await prefs.setString('leaderEmail', leaderData['email']);
      return true;
    } else {
      return false;
    }
  }

  Future<void> _fetchAndSaveStatus(String username) async {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/volunteers/login'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];

      final selectedUser = data.firstWhere(
            (user) => user['username'] == username,
        orElse: () => null,
      );

      if (selectedUser != null) {
        final status = selectedUser['status'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userStatus', status);
      }
    }
  }

  Future<void> _fetchAndSaveRole(String username) async {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/admin/allTeachers'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];

      final selectedTeacher = data.firstWhere(
            (teacher) => teacher['username'] == username,
        orElse: () => null,
      );

      if (selectedTeacher != null) {
        final role = selectedTeacher['role'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userRole', role);
      }
    }
  }

  Future<void> _fetchAndSaveUserDetails(String username, String userType) async {
    String url;
    if (userType == 'volunteer') {
      url = 'http://213.210.37.81:3009/volunteers/login';
    } else {
      url = 'http://213.210.37.81:3009/admin/allTeachers';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];
      print("======================================");
      print(responseBody['data']);

      final user = data.firstWhere(
            (user) => user['username'] == username,
        orElse: () => null,
      );

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userDetails', jsonEncode(user));
      }
    }
  }

  Future<void> _saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
  }
}
