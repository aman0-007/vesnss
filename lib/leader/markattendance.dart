import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vesnss/leader/attendance_mark.dart';
import 'dart:convert';

import 'package:vesnss/leader/attendance_scan.dart';

class Markattendance extends StatefulWidget {
  const Markattendance({super.key});

  @override
  State<Markattendance> createState() => _MarkattendanceState();
}

class _MarkattendanceState extends State<Markattendance> {
  List _events = [];
  String? _selectedEvent;
  String? _selectedPosition;
  String? _hours;
  final String _apiKey = 'NsSvEsAsC';
  final List<String> _positions = ['Organising', 'Participants'];

  // Controllers for form fields
  final TextEditingController _teacherInchargeController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventLevelController = TextEditingController();
  final TextEditingController _leaderIdController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchActiveEvents();
  }

  Future<void> _fetchActiveEvents() async {
    try {
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/leader/active'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        setState(() {
          _events = data['data']
              .where((event) => event['status'] == 'Active')
              .toList();
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
    }
  }

  void _onEventSelected(String? eventName) {
    setState(() {
      _selectedEvent = eventName;
      final selectedEvent = _events.firstWhere(
              (event) => event['name'] == eventName,
          orElse: () => null);
      if (selectedEvent != null) {
        _teacherInchargeController.text = selectedEvent['teacher_incharge'] ?? '';
        _eventDateController.text = _formatDate(selectedEvent['date']) ?? '';
        _eventLevelController.text = selectedEvent['level'] ?? '';
        _leaderIdController.text = selectedEvent['leader_id'] ?? '';
        _hoursController.text = _hours ?? '';
      } else {
        _teacherInchargeController.clear();
        _eventDateController.clear();
        _eventLevelController.clear();
        _leaderIdController.clear();
        _hoursController.clear();
      }
    });
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }

  void _scanAttendance() {
    // Ensure all required fields are populated
    if (_selectedEvent == null || _selectedPosition == null || _hours == null) {
      // Optionally show an error message or handle missing data
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: 'Missing Information',
        text: 'Please fill in all required fields',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blue,
      );
      return;
    }

    // Navigate to the AttendanceScan page with the required parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceScan(
          leaderId: _leaderIdController.text,
          eventName: _selectedEvent!,
          level: _eventLevelController.text,
          hours: int.tryParse(_hours!) ?? 0,
          position: _selectedPosition!,
          date: _eventDateController.text,
        ),
      ),
    );
  }


  void _markAttendance() {
    // Ensure all required fields are populated
    if (_selectedEvent == null || _selectedPosition == null || _hours == null) {
      // Optionally show an error message or handle missing data
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: 'Missing Information',
        text: 'Please fill in all required fields',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blue,
      );
      return;
    }

    // Collect the data to pass to the AttendanceMark page
    final eventDetails = {
      'eventName': _selectedEvent!,
      'date': _eventDateController.text,
      'level': _eventLevelController.text,
      'leaderId': _leaderIdController.text,
      'hours': int.tryParse(_hours!) ?? 0,
      'position': _selectedPosition!,
    };

    // Navigate to the AttendanceMark page with the collected data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceMark(
          eventDetails: eventDetails,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _events.isEmpty
                  ? Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: Colors.blue, // Adjust color as needed
                  rightDotColor: Colors.red, // Adjust color as needed
                  size: 50, // Adjust size as needed
                ),
              )
                  : DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Event',
                  border: OutlineInputBorder(),
                ),
                items: _events.map<DropdownMenuItem<String>>((event) {
                  return DropdownMenuItem<String>(
                    value: event['name'],
                    child: Text(event['name']),
                  );
                }).toList(),
                onChanged: _onEventSelected,
                value: _selectedEvent,
                hint: const Text('Select an event'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Teacher Incharge',
                  border: OutlineInputBorder(),
                ),
                controller: _teacherInchargeController,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                controller: _eventDateController,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                controller: _eventLevelController,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Leader ID',
                  border: OutlineInputBorder(),
                ),
                controller: _leaderIdController,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Position',
                  border: OutlineInputBorder(),
                ),
                items: _positions.map<DropdownMenuItem<String>>((position) {
                  return DropdownMenuItem<String>(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
                value: _selectedPosition,
                hint: const Text('Select a position'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Enter Hours',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _hours = value;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _scanAttendance,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Scan Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _markAttendance,
                      icon: const Icon(Icons.check),
                      label: const Text('Mark Attendance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
