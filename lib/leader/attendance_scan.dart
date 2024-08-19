import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceScan extends StatefulWidget {
  final String leaderId;
  final String eventName;
  final String level;
  final int hours;
  final String position;
  final String date;

  const AttendanceScan({super.key, required this.leaderId, required this.eventName, required this.level, required this.hours, required this.position, required this.date});

  @override
  State<AttendanceScan> createState() => _AttendanceScanState();
}

class _AttendanceScanState extends State<AttendanceScan> {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  Map<String, String> attendanceRecords = {}; // Changed to a Map
  bool _isCameraInitialized = false;
  Map<String, String> enrolledStudents = {};
  late Timer _timer;

  List<String> scannedStudentIds = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchEnrolledStudents();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
      await _cameraController.initialize().then((_) {
        setState(() {
          _isCameraInitialized = true;
        });
      });
      _barcodeScanner = BarcodeScanner();
      _startBarcodeScanning();
    } else {
      log('No cameras found');
    }
  }

  void _startBarcodeScanning() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) async {
      if (_cameraController.value.isInitialized) {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          setState(() {
            for (final barcode in barcodes) {
              final studentId = barcode.rawValue;
              if (studentId != null && enrolledStudents.containsKey(studentId)) {
                if (!attendanceRecords.containsKey(studentId)) {
                  final studentName = enrolledStudents[studentId] ?? 'Unknown';
                  attendanceRecords[studentId] = studentName;
                  if (!scannedStudentIds.contains(studentId)) {
                    scannedStudentIds.add(studentId); // Add student ID to the list
                  }
                }
              }
            }
          });
        } else {
          log('No barcode found in the image.');
        }
      }
    });
  }

  Future<void> _fetchEnrolledStudents() async {
    final response = await http.get(
      Uri.parse('http://213.210.37.81:3009/leader/all-student'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'NsSvEsAsC',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final students = data['data'] as List;
      setState(() {
        enrolledStudents = {for (var student in students) student['stud_id']: student['name']};
      });
    } else {
      log('Failed to fetch enrolled students, status code: ${response.statusCode}');
    }
  }

  Future<void> _markAttendance() async {
    final String apiUrl = 'http://213.210.37.81:3009/leader/mark'; // Adjust the API endpoint as needed
    final attendanceData = {
      'stud_ids': scannedStudentIds,
      'leader_id': widget.leaderId,
      'event_name': widget.eventName,
      'level': widget.level,
      'hrs': widget.hours,
      'position': widget.position,
      'date': widget.date,
    };

    print("========================================================================");
    print(widget.level);
    print(widget.hours);
    print(widget.position);
    print(widget.date);
    print(scannedStudentIds);
    print(widget.leaderId);
    print( widget.eventName);
    print("========================================================================");
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
        body: jsonEncode(attendanceData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Failed to mark attendance, status code: ${response.statusCode}');
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark attendance $response ')),
        );
      }
    } catch (e) {
      log('Error marking attendance: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents = enrolledStudents.length;
    final presentStudents = attendanceRecords.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Attendance')),
      body: SafeArea(
        child: Column(
          children: [
            if (_isCameraInitialized)
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                flex: 2,
                child: Center(child: Text('Loading Camera')),
              ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leader ID: ${widget.leaderId}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                Text('Event Date: ${widget.date}', style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total: $totalStudents', style: const TextStyle(fontSize: 15)),
                                Text('Present: $presentStudents', style: const TextStyle(fontSize: 15, color: Colors.green)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        attendanceRecords.isNotEmpty
                            ? Expanded(
                          child: ListView.builder(
                            itemCount: attendanceRecords.length,
                            itemBuilder: (context, index) {
                              final studentId = attendanceRecords.keys.elementAt(index);
                              final studentName = attendanceRecords[studentId] ?? 'Unknown';
                              return ListTile(
                                title: Text('Student ID: $studentId', style: const TextStyle(fontSize: 15)),
                                subtitle: Text('Name: $studentName', style: const TextStyle(fontSize: 15)),
                              );
                            },
                          ),
                        )
                            : const Center(child: Text('No barcodes found')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    await _markAttendance(); // Call the method to mark attendance
                  },
                  label: const Text('Mark Attendance'),
                  icon: const Icon(Icons.check),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
