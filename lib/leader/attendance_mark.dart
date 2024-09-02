import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceMark extends StatefulWidget {
  final Map<String, dynamic> eventDetails;

  const AttendanceMark({super.key, required this.eventDetails});

  @override
  State<AttendanceMark> createState() => _AttendanceMarkState();
}

class _AttendanceMarkState extends State<AttendanceMark> {
  // Define the URL and API key
  List<Student> _students = [];
  Map<String, bool> _selectedStudents = {};

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _students = (data['data'] as List).map((json) => Student.fromJson(json)).toList();
          _selectedStudents = {for (var student in _students) student.studId: false};
        });
      } else {
        // Handle error response
      }
    } catch (e) {
    }
  }

  Future<void> _submitAttendance() async {
    final selectedStudentsList = _selectedStudents.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();


    if (selectedStudentsList.isEmpty) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Error',
        text: 'No students selected',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
      );
      return;
    }


    final attendanceData = {
      'stud_ids': selectedStudentsList,
      'leader_id': widget.eventDetails['leaderId'],
      'event_name': widget.eventDetails['eventName'],
      'level': widget.eventDetails['level'],
      'hrs': widget.eventDetails['hours'],
      'position': widget.eventDetails['position'],
      'date': widget.eventDetails['date'],
    };

    try {
      final response = await http.post(
        Uri.parse('http://213.210.37.81:3009/leader/mark'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success alert
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Success',
          text: 'Attendance marked successfully',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () {
            Navigator.pop(context); // Go back to previous screen
            Navigator.pop(context); // Go back to previous screen
          },
        );
      } else {
        // Show error alert with status code
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Error',
          text: 'Failed to mark attendance. Status code: ${response.statusCode}',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
        );
      }
    } catch (e) {
      // Show error alert with exception
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'Error',
        text: 'Error marking attendance: $e',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Mark'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('Volunteers', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Class', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Action', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${student.name} ${student.surname}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${student.studId}'),
                          ],
                        ),
                        Text('${student.year}.${student.className}'),
                        Checkbox(
                          value: _selectedStudents[student.studId],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedStudents[student.studId] = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    // trailing: Checkbox(
                    //   value: _selectedStudents[student.studId],
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       _selectedStudents[student.studId] = value ?? false;
                    //     });
                    //   },
                    // ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitAttendance,
                child: const Text('Submit Attendance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Student {
  final String studId;
  final String name;
  final String surname;
  final String className;
  final String year;

  Student({
    required this.studId,
    required this.name,
    required this.surname,
    required this.className,
    required this.year,
  });


  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studId: json['stud_id'],
      name: json['name'],
      surname: json['surname'],
      className: json['class'],
      year: json['year'],
    );
  }
}
