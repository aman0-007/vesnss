import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:vesnss/colors.dart';

class ApproveEvent extends StatefulWidget {
  const ApproveEvent({super.key});

  @override
  State<ApproveEvent> createState() => _ApproveEventState();
}

class _ApproveEventState extends State<ApproveEvent> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  final String _apiKey = 'NsSvEsAsC';
  final String _notSelectedUrl = 'http://213.210.37.81:3009/admin/notdone';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchEventDetails() async {
    try {
      final response = await http.get(
        Uri.parse(_notSelectedUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Not Done events fetched successfully') {
          final events = List<Map<String, dynamic>>.from(data['data']);
          setState(() {
            _events = events;
            _isLoading = false;
          });
        } else {
          throw Exception('Error fetching events: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markEventAsCompleted(String eventId) async {
    final String url = 'http://213.210.37.81:3009/admin/events/$eventId';

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
        if (data['message']?.toLowerCase().contains('completed') ?? false) {
          await _fetchEventDetails();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Event marked as completed!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Error marking event as completed: ${data['message']}');
        }
      } else {
        throw Exception('Failed to mark event as completed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking event as completed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark event as completed.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyyy').format(date); // Format to show date as dd-MM-yyyy
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = _events;
    final universityEvents = _events.where((event) => event['level'] == 'University').toList();

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white, // Set page background color to white
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All Events'),
              Tab(text: 'University Events'),
            ],
            indicatorColor: Colors.red, // Red underline for selected tab
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventList(allEvents),
                _buildEventList(universityEvents),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          margin: EdgeInsets.all(10),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.blue, // Set card border color to blue
                width: 1.0,
              ),
            ),
            color: Colors.white, // Set card background color to white
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event['name'] ?? 'No Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red, // Set name color to red
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formatDate(event['date'] ?? 'Unknown'),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Venue: ${event['venue'] ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Level: ${event['level'] ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Set button background color to green
                      foregroundColor: Colors.white, // Set button text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.green), // Set button border color to green
                      ),
                    ),
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do you want to mark this event as completed?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          await _markEventAsCompleted(event['event_id']); // Pass the event ID to mark it as completed
                        },
                        onCancelBtnTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      );
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white, // Set button text color to white
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBlue, // Use primaryBlue for AppBar background
      title: const Text(
        'Approve Events',
        style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
