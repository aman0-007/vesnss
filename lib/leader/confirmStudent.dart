import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import loading_animation_widget
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
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

      if (response.statusCode == 200 || response.statusCode == 201) {
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
          await _fetchStudents(); // Refresh the students list
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: 'Student selected successfully!',
          );
        } else {
          throw Exception('Error selecting student: ${data['message']}');
        }
      } else {
        throw Exception('Failed to select student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error selecting student: $e');
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: 'Failed to select student.',
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
          ? Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: AppColors.primaryRed, // Adjust color as needed
          rightDotColor: AppColors.primaryBlue, // Adjust color as needed
          size: 50, // Adjust size as needed
        ),
      )
          : ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
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
                            style: const TextStyle(
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
                            style: const TextStyle(
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
                          side: const BorderSide(color: Colors.green),
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
                      child: const Text(
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
