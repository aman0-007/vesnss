import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:vesnss/colors.dart';

class Confirmvolunteer extends StatefulWidget {
  const Confirmvolunteer({super.key});

  @override
  State<Confirmvolunteer> createState() => _ConfirmvolunteerState();
}

class _ConfirmvolunteerState extends State<Confirmvolunteer> {
  List<Map<String, dynamic>> _volunteers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  Future<void> _fetchVolunteers() async {
    try {
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/admin/inprocess'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final volunteers = List<Map<String, dynamic>>.from(data['data']);
        setState(() {
          _volunteers = volunteers;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load volunteers: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectVolunteer(String studId) async {
    try {
      // Check the current selected students count
      final count = await _fetchSelectedStudentsCount();

      // If the count is 6 or more, show an alert and prevent further selection
      if (count >= 300) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Maximum number of volunteers selected. No further selections allowed.',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.orange,
        );
        return;
      }

      final response = await http.put(
        Uri.parse('http://213.210.37.81:3009/admin/select/$studId'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Student selected successfully',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            _fetchVolunteers(); // Refresh the list after selection
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to select student',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
      );
    }
  }

  Future<int> _fetchSelectedStudentsCount() async {
    try {
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/admin/SelectedStudents'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['count'] as int;
      } else {
        throw Exception('Failed to load selected students count: ${response.statusCode}');
      }
    } catch (e) {
      return -1; // Return -1 in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          'Confirm Volunteers',
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
          ? const Center(child: CircularProgressIndicator())
          : _volunteers.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'No student data to select as volunteer',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _volunteers.length,
        itemBuilder: (context, index) {
          final volunteer = _volunteers[index];
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${volunteer['name']} ${volunteer['surname']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Phone: ${volunteer['phone_no']}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Class: ${volunteer['class']}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Hours: ${volunteer['hrs']}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to select this student as a volunteer?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop();
                            _selectVolunteer(volunteer['stud_id']);
                          },
                          onCancelBtnTap: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      child: const Text('Select'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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
