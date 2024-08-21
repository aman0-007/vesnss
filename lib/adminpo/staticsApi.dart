import 'dart:convert';
import 'package:http/http.dart' as http;

class StaticsApi {

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/admin/fetchProjects'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> projects = data['data'];
      return projects.map((project) => project as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
