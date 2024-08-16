import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:vesnss/colors.dart';
import 'addEventApi.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _leaderController = TextEditingController();
  final TextEditingController _projectLevelController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTeacherName;
  String? _selectedProjectId;
  String? _selectedProjectLevel;
  List<String> _teacherNames = [];
  List<Project> _projects = [];
  final List<String> _projectLevels = ['College', 'University', 'District', 'Adopted Area', 'Adopted Village'];


  @override
  void initState() {
    super.initState();
    _fetchTeacherNames();
    _fetchProjects();
  }

  Future<void> _fetchTeacherNames() async {
    try {
      final teachers = await fetchTeachers();
      setState(() {
        _teacherNames = teachers
            .where((teacher) => teacher.role == 'Teacher Incharge') // Use role here
            .map((teacher) => teacher.name)
            .toList();
      });
    } catch (e) {
      print('Something went wrong: $e');
    }
  }

  Future<void> _fetchProjects() async {
    try {
      final projects = await fetchProjects();
      setState(() {
        _projects = projects;
      });
    } catch (e) {
      print('Something went wrong: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(deviceWidth * 0.07),
              padding: EdgeInsets.all(deviceWidth * 0.03),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(deviceHeight),
                    _buildDivider(),
                    SizedBox(height: deviceHeight * 0.01),
                    _buildTextField("Event Name :", _eventNameController, deviceWidth),
                    _buildDatePicker("Date :", deviceWidth),
                    _buildTeacherDropdown("Teacher Incharge :", deviceWidth),
                    _buildTextField("Leader :", _leaderController, deviceWidth),
                    _buildProjectDropdown("Project Name:", deviceWidth),
                    _buildSelectedProjectIdDisplay(),
                    _buildProjectLevelDropdown("Project Level :", deviceWidth),
                    SizedBox(height: deviceHeight * 0.030),
                    _buildPublishButton(deviceWidth, deviceHeight),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryBlue, // Use primaryBlue for AppBar background
      title: const Text(
        'Add Event',
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

  Widget _buildTitle(double deviceHeight) {
    return Padding(
      padding: EdgeInsets.only(top: deviceHeight * 0.007),
      child: const Text(
        "Add Event",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.primaryBlue, // Use primaryBlue for title color
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, double deviceWidth, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          TextField(
            controller: controller,
            maxLines: isMultiline ? null : 1,
            textAlignVertical: isMultiline ? TextAlignVertical.bottom : TextAlignVertical.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue, // Use primaryBlue for focused border
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, double deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          GestureDetector(
            onTap: () async {
              final selectedDates = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                  firstDate: DateTime.now(), // Restrict to dates from today onwards
                  selectedDayHighlightColor: AppColors.primaryBlue, // Use primaryBlue for the selected day
                  dayTextStyle: const TextStyle(color: Colors.black87), // Text style for the days
                  calendarViewMode: CalendarDatePicker2Mode.day, // Initial view mode of the calendar
                ),
                dialogSize: Size(deviceWidth * 0.8, deviceWidth * 0.9),
                value: [_selectedDate],
              );
              if (selectedDates != null && selectedDates.isNotEmpty) {
                setState(() {
                  _selectedDate = selectedDates.first;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate != null
                        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        : 'Select Date',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                    size: 18.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProjectDropdown(String label, double deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue, // Use primaryBlue for focused border
                  width: 2.0,
                ),
              ),
            ),
            value: _selectedProjectId,
            items: _projects.map((project) {
              return DropdownMenuItem<String>(
                value: project.projectId,
                child: Text(project.projectName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedProjectId = value;
              });
            },
            hint: const Text('Select Project'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProjectIdDisplay() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          _selectedProjectId != null
              ? _selectedProjectId!  // Display only the project ID
              : '',  // Display nothing if no project is selected
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  Widget _buildTeacherDropdown(String label, double deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          DropdownButtonFormField<String>(
            value: _selectedTeacherName,
            items: _teacherNames.map((name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedTeacherName = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue, // Use primaryBlue for focused border
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
            hint: const Text('Select Teacher'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectLevelDropdown(String label, double deviceWidth) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4.0),
          DropdownButtonFormField<String>(
            value: _selectedProjectLevel,
            items: _projectLevels.map((level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedProjectLevel = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue, // Use primaryBlue for focused border
                  width: 2.0,
                ),
              ),
            ),
            hint: const Text('Select Level'),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue, // Use primaryBlue for button background
              elevation: 5, // Button elevation
              minimumSize: Size(deviceWidth * 0.55, deviceHeight * 0.057), // Minimum size
            ),
            onPressed: (){}, // Assuming _submitForm handles the form submission
            child: const Text(
              'Publish Event',
              style: TextStyle(
                color: AppColors.primaryRed, // Use primaryRed for text color
                fontWeight: FontWeight.bold,
                fontSize: 20, // Font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
