import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:vesnss/colors.dart';

class Confirmstudent extends StatefulWidget {
  const Confirmstudent({super.key});

  @override
  State<Confirmstudent> createState() => _ConfirmstudentState();
}

class _ConfirmstudentState extends State<Confirmstudent> {
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;
  final String _apiKey = 'NsSvEsAsC';
  final String _apiUrl = 'http://213.210.37.81:3009/leader/notselected';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final students = List<Map<String, dynamic>>.from(data['data']);
        setState(() {
          _students = students;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectStudent(String studId) async {
    final String url = 'http://213.210.37.81:3009/leader/update/$studId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Student updated successfully') {
          // Refresh the students list
          await _fetchStudents();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Student selected successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Error selecting student: ${data['message']}');
        }
      } else {
        throw Exception('Failed to select student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error selecting student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select student.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Confirm Students',
          style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return Container(
            margin: EdgeInsets.all(10),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                ),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${student['name']} ${student['surname']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '${student['phone_no']} ${student['class']}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Hours: ${student['hrs']}',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.green),
                        ),
                      ),
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to select this student as a volunteer?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            await _selectStudent(student['stud_id']); // Pass the student ID to select
                          },
                          onCancelBtnTap: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        );
                      },
                      child: Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
