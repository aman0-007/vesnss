// teacher_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
class Teacher {
  final String teacherId;
  final String name;
  final String role; // Add role property

  Teacher({
    required this.teacherId,
    required this.name,
    required this.role, // Add role to the constructor
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'] as String,
      name: json['name'] as String,
      role: json['role'] as String, // Parse role from JSON
    );
  }
}


Future<List<Teacher>> fetchTeachers() async {

  try {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/admin/allTeachers'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map<Teacher>((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  } catch (e) {
    return [];
  }
}

class Project {
  final String projectId;
  final String projectName;

  Project({
    required this.projectId,
    required this.projectName,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'] as String,
      projectName: json['project_name'] as String,
    );
  }
}

Future<List<Project>> fetchProjects() async {

  try {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/admin/fetchProjects'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map<Project>((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  } catch (e) {
    return [];
  }
}

Future<bool> addEventDetails({
  required String name,
  required String date,
  required String level,
  required String venue,
  required String teacherInCharge,
  required String projectId,
  required String leaderId,
}) async {

  final Map<String, dynamic> requestBody = {
    'name': name,
    'date': date,
    'level': level,
    'venue': venue,
    'teacher_incharge': teacherInCharge,
    'project_id': projectId,
    'leader_id': leaderId,
  };

  try {
    final response = await http.post(
      Uri.parse('http://213.210.37.81:3009/leader/addEvent'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
