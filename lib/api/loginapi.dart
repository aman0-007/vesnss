import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  final String _volunteersLoginUrl = 'http://213.210.37.81:3009/volunteers/login';
  final String _teacherLoginUrl = 'http://213.210.37.81:3009/admin/TeacherLogin';
  final String _leaderLoginUrl = 'http://213.210.37.81:3009/leader/leaderLogin';
  final String _notSelectedUrl = 'http://213.210.37.81:3009/leader/notselected';
  final String _allTeachersUrl = 'http://213.210.37.81:3009/admin/allTeachers';
  final String _apiKey = 'NsSvEsAsC';

  Future<void> login(String username, String password) async {
    bool isVolunteersLoginSuccessful = await _loginVolunteer(username, password);
    bool isTeacherLoginSuccessful = !isVolunteersLoginSuccessful
        ? await _loginTeacher(username, password)
        : false;
    bool isLeaderLoginSuccessful = !isVolunteersLoginSuccessful && !isTeacherLoginSuccessful
        ? await _loginLeader(username, password)
        : false;

    if (isVolunteersLoginSuccessful) {
      await _fetchAndSaveStatus(username);
      await _saveUserType('Volunteer');
      await _fetchAndSaveUserDetails(username, 'volunteer');
    } else if (isTeacherLoginSuccessful) {
      await _fetchAndSaveRole(username);
      await _saveUserType('Teacher');
    } else if (isLeaderLoginSuccessful) {
      await _saveUserType('Leader');
      // Leader data is already saved in _loginLeader method
    } else {
      print('Failed to login to all endpoints.');
      throw Exception('Failed to login to all endpoints.');
    }

    // Save login status and username in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', username);
  }

  Future<bool> _loginVolunteer(String username, String password) async {
    final response = await http.post(
      Uri.parse(_volunteersLoginUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Volunteer login successful');
      return true;
    } else {
      print('Failed to login as volunteer. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> _loginTeacher(String username, String password) async {
    final response = await http.post(
      Uri.parse(_teacherLoginUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Teacher login successful');
      return true;
    } else {
      print('Failed to login as teacher. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<bool> _loginLeader(String username, String password) async {
    final response = await http.post(
      Uri.parse(_leaderLoginUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Leader login successful');
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final Map<String, dynamic> leaderData = responseBody['data'];

      // Save leader data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('leaderId', leaderData['id']);
      await prefs.setString('leaderUniqueId', leaderData['leader_id']);
      await prefs.setString('leaderName', leaderData['name']);
      await prefs.setString('leaderUsername', leaderData['username']);
      await prefs.setString('groupName', leaderData['group_name']);
      await prefs.setString('teacherId', leaderData['teacher_id']);
      await prefs.setString('role', leaderData['role']);
      await prefs.setString('leaderEmail', leaderData['email']);
      print('Leader data saved in shared preferences');

      return true;
    } else {
      print('Failed to login as leader. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  Future<void> _fetchAndSaveStatus(String username) async {
    final response = await http.get(
      Uri.parse(_notSelectedUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
    );

    print('Response body from notselected: ${response.body}');

    if (response.statusCode == 200) {
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
        print('User status saved in shared preferences: $status');
      } else {
        print('User not found in the notselected list.');
      }
    } else {
      print('Failed to fetch data from $_notSelectedUrl. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _fetchAndSaveRole(String username) async {
    final response = await http.get(
      Uri.parse(_allTeachersUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
    );

    print('Response body from allTeachers: ${response.body}');

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
        print('User role saved in shared preferences: $role');
      } else {
        print('Teacher not found in the allTeachers list.');
      }
    } else {
      print('Failed to fetch data from $_allTeachersUrl. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _fetchAndSaveUserDetails(String username, String userType) async {
    // Determine URL based on user type
    String url;
    if (userType == 'volunteer') {
      url = _notSelectedUrl;  // Assuming this is correct for volunteer details
    } else {
      url = _allTeachersUrl;  // Adjust if needed
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      },
    );

    print('Response body from $url: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> data = responseBody['data'];

      // Debug: print out all usernames to check if the expected username is present
      for (var user in data) {
        print('Available username: ${user['username']}');
      }

      // Find the user with the provided username
      final user = data.firstWhere(
            (user) => user['username'] == username,
        orElse: () => null,
      );

      if (user != null) {
        // Save user details to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userDetails', jsonEncode(user));
        print('User details saved in shared preferences');
      } else {
        print('User not found in the data');
      }
    } else {
      print('Failed to fetch data from API. Status code: ${response.statusCode}');
    }
  }

  Future<void> _saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    print('User type saved in shared preferences: $userType');
  }
}
