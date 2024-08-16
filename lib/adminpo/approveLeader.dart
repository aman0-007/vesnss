import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vesnss/colors.dart'; // Import your colors file

class Approveleader extends StatefulWidget {
  const Approveleader({super.key});

  @override
  State<Approveleader> createState() => _ApproveleaderState();
}

class _ApproveleaderState extends State<Approveleader> {
  late Future<List<Leader>> _leadersFuture;
  List<Leader> _leaders = [];
  List<Leader> _filteredLeaders = [];
  final TextEditingController _searchController = TextEditingController();
  List<Teacher> _teachers = [];
  Teacher? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    _leadersFuture = fetchLeaders();
    _searchController.addListener(_filterLeaders);
  }

  Future<List<Leader>> fetchLeaders() async {
    const String apiKey = 'NsSvEsAsC';
    const String notSelectedUrl = 'http://213.210.37.81:3009/admin/notleaders';

    final response = await http.get(
      Uri.parse(notSelectedUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      final leaders = data.map((json) => Leader.fromJson(json)).toList();
      setState(() {
        _leaders = leaders;
        _filteredLeaders = leaders; // Initially, show all leaders
      });
      return leaders;
    } else {
      throw Exception('Failed to load leaders');
    }
  }

  Future<void> fetchTeachers() async {
    const String apiKey = 'NsSvEsAsC';
    const String teachersUrl = 'http://213.210.37.81:3009/admin/allTeachers';

    final response = await http.get(
      Uri.parse(teachersUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      setState(() {
        _teachers = data.map((json) => Teacher.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  void _filterLeaders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLeaders = _leaders.where((leader) {
        return leader.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showApprovalDialog(Leader leader) {
    fetchTeachers().then((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Approve Leader'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you sure you want to approve ${leader.name}?'),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<Teacher>(
                  value: _selectedTeacher,
                  hint: const Text('Select Teacher'),
                  items: _teachers.map((teacher) {
                    return DropdownMenuItem<Teacher>(
                      value: teacher,
                      child: Text(teacher.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeacher = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (_selectedTeacher != null) {
                    _approveLeader(leader);
                  } else {
                    _showErrorDialog('Please select a teacher.');
                  }
                },
                child: const Text('Approve'),
              ),
            ],
          );
        },
      );
    });
  }

  void _showRejectionDialog(Leader leader) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Leader'),
          content: Text('Are you sure you want to reject ${leader.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _rejectLeader(leader);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _approveLeader(Leader leader) async {
    const String apiKey = 'NsSvEsAsC';
    final String approveUrl = 'http://213.210.37.81:3009/admin/update-leader/${leader.email}';

    final response = await http.put(
      Uri.parse(approveUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'teacher_id': _selectedTeacher?.teacherId,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leader approved successfully')));
      fetchLeaders(); // Refresh the list
    } else {
      _showErrorDialog('Failed to approve leader');
    }
  }


  Future<void> _rejectLeader(Leader leader) async {
    // Implement rejection logic if needed
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBox(deviceWidth),
            Expanded(
              child: FutureBuilder<List<Leader>>(
                future: _leadersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No leaders to display'));
                  } else {
                    return _buildLeadersList(_filteredLeaders, deviceWidth, deviceHeight);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      title: const Text(
        'Approve Leaders',
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

  Widget _buildSearchBox(double deviceWidth) {
    return Padding(
      padding: EdgeInsets.all(deviceWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            hintText: 'Search by name...',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadersList(List<Leader> leaders, double deviceWidth, double deviceHeight) {
    return ListView.builder(
      itemCount: leaders.length,
      itemBuilder: (context, index) {
        final leader = leaders[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: deviceHeight * 0.01, horizontal: deviceWidth * 0.05),
          padding: EdgeInsets.all(deviceWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    leader.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group: ${leader.groupName}'),
                      Text('Email: ${leader.email}'),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => _showApprovalDialog(leader),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => _showRejectionDialog(leader),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class Leader {
  final String name;
  final String groupName;
  final String email;

  Leader({
    required this.name,
    required this.groupName,
    required this.email,
  });

  factory Leader.fromJson(Map<String, dynamic> json) {
    return Leader(
      name: json['name'] as String,
      groupName: json['group_name'] as String? ?? 'N/A',
      email: json['email'] as String,
    );
  }
}

class Teacher {
  final String teacherId;
  final String name;

  Teacher({
    required this.teacherId,
    required this.name,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      teacherId: json['teacher_id'] as String,
      name: json['name'] as String,
    );
  }
}
