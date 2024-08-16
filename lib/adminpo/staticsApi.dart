import 'dart:convert';
import 'package:http/http.dart' as http;

class StaticsApi {
  final String _baseUrl = 'http://213.210.37.81:3009/admin/fetchProjects';
  final String _apiKey = 'NsSvEsAsC';

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
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
