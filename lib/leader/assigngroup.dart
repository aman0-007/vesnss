import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vesnss/colors.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class AssignGroup extends StatefulWidget {
  const AssignGroup({super.key});

  @override
  State<AssignGroup> createState() => _AssignGroupState();
}

class _AssignGroupState extends State<AssignGroup> {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  bool _isLoading = true;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  SingleSelectController<String?> _classDropdownController = SingleSelectController(null);

  String? _selectedClass;
  bool _isAscending = true;
  Set<int> _selectedStudentIds = {}; // Track selected student IDs

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('http://213.210.37.81:3009/leader/students/selected/notapplied'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'NsSvEsAsC',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final students = List<Map<String, dynamic>>.from(data['students']);
        setState(() {
          _students = students;
          _filteredStudents = students;
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

  void _filterStudents(String query) {
    final filtered = _students.where((student) {
      final fullName = '${student['name']} ${student['surname']}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredStudents = filtered;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredStudents = _students;
      }
    });
  }

  void _filterByClass(String? selectedClass) {
    setState(() {
      _selectedClass = selectedClass;
      if (_selectedClass != null && _selectedClass!.isNotEmpty) {
        _filteredStudents = _students
            .where((student) => student['class'] == _selectedClass)
            .toList();
      } else {
        _filteredStudents = _students;
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedClass = null;
      _classDropdownController.clear();
      _isAscending = true;
      _filteredStudents = _students;
    });
  }

  List<String> _getClassNames() {
    return _students.map((student) => student['class'].toString()).toSet().toList();
  }

  void _toggleSelection(int? id) {
    if (id == null) return; // Handle null ID scenario

    setState(() {
      if (_selectedStudentIds.contains(id)) {
        _selectedStudentIds.remove(id);
      } else {
        _selectedStudentIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          onChanged: _filterStudents,
          decoration: const InputDecoration(
            hintText: 'Search by name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        )
            : const Text(
          'Selected Students',
          style: TextStyle(
              color: AppColors.primaryRed, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            color: AppColors.primaryRed,
            onPressed: _toggleSearch,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: CustomDropdown<String?>(
                    controller: _classDropdownController,
                    hintText: "Select Class",
                    items: _getClassNames(),
                    onChanged: (value) {
                      _filterByClass(value);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _resetFilters,
                ),
              ],
            ),
          ),
          _isLoading
              ? Expanded(
            child: Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: AppColors.primaryRed,
                rightDotColor: AppColors.primaryBlue,
                size: 50,
              ),
            ),
          )
              : Expanded(
            child: Column(
              children: [
                // Header Row
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: Text('      Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      Center(child: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                      Center(child: Text('Hours', style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 10), // Space for checkbox
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      final studentId = student['id'] as int?; // Ensure it is int or null

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.blue, width: 1.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${student['name']} ${student['surname']}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${student['class']}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${student['hrs']}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: studentId != null && _selectedStudentIds.contains(studentId),
                              onChanged: (checked) {
                                if (checked != null) {
                                  _toggleSelection(studentId);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
