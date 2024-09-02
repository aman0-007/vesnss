import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class AllStudentPage extends StatefulWidget {
  @override
  _AllStudentPageState createState() => _AllStudentPageState();
}

class _AllStudentPageState extends State<AllStudentPage> {
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/leader/all-student'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final students = List<Map<String, dynamic>>.from(data['data']);

        // Sort the students by name in alphabetical order
        students.sort((a, b) => a['name'].toLowerCase().compareTo(b['name'].toLowerCase()));

        setState(() {
          _students = students;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching students: $e');
    }
  }

  Future<void> _deleteStudent(String email) async {
    try {
      final response = await http.delete(
        Uri.parse('http://213.210.37.81:3009/volunteers/delete/stud/$email'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Student deleted successfully!',
        );
        _fetchStudents();
      } else {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error deleting student.',
      );
      print('Error deleting student: $e');
    }
  }

  void _showDeleteConfirmation(String email) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Delete Record',
      text: 'Do you want to delete this record?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the QuickAlert dialog
        _deleteStudent(email); // Call the delete function
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStudents,
            tooltip: 'Refresh List',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  student['name'][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                '${student['name']} ${student['surname']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                student['email'],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              onTap: () => _showDeleteConfirmation(student['email']),
            ),
          );
        },
      ),
    );
  }
}
