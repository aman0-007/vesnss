import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; // Import loading_animation_widget
import 'package:vesnss/colors.dart';

class Completeevent extends StatefulWidget {
  const Completeevent({super.key});

  @override
  State<Completeevent> createState() => _CompleteeventState();
}

class _CompleteeventState extends State<Completeevent> {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;
  final String _apiUrl = 'http://213.210.37.81:3009/leader/active';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final events = List<Map<String, dynamic>>.from(data['data']);
        setState(() {
          _events = events;
          _isLoading = false;
        });
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

  Future<void> _markEventAsComplete(String eventId, String beneficiaries) async {
    final url = 'http://213.210.37.81:3009/leader/mark/event/$eventId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
        body: jsonEncode({
          'beneficiaries': beneficiaries,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Event marked as complete!',
        );
        _fetchEvents(); // Refresh the events list
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to mark event as complete: ${response.body}',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error: $e',
      );
    }
  }

  void _showBeneficiaryDialog(String eventId) {
    TextEditingController _beneficiaryController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Complete Event',
      text: 'Enter the number of beneficiaries:',
      widget: TextField(
        controller: _beneficiaryController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter beneficiaries',
        ),
      ),
      confirmBtnText: 'Submit',
      onConfirmBtnTap: () {
        final beneficiaries = _beneficiaryController.text;
        if (beneficiaries.isNotEmpty) {
          Navigator.of(context).pop();
          _markEventAsComplete(eventId, beneficiaries);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Events'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: _isLoading
          ? Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: AppColors.primaryRed,
          rightDotColor: AppColors.primaryBlue, // Adjust color as needed
          size: 50, // Adjust size as needed
        ),
      )
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final formattedDate = DateFormat.yMMMMd().format(DateTime.parse(event['date']));

          return GestureDetector(
            onTap: () => _showBeneficiaryDialog(event['event_id']),
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: $formattedDate',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Teacher Incharge: ${event['teacher_incharge']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryBlack,
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
