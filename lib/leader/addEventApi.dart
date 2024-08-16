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
  const String apiKey = 'NsSvEsAsC';
  const String teachersUrl = 'http://213.210.37.81:3009/admin/allTeachers';

  try {
    final response = await http.get(
      Uri.parse(teachersUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
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
    print('Error fetching teachers: $e');
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
  const String apiKey = 'NsSvEsAsC';
  const String projectsUrl = 'http://213.210.37.81:3009/admin/fetchProjects';

  try {
    final response = await http.get(
      Uri.parse(projectsUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
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
    print('Error fetching projects: $e');
    return [];
  }
}