import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesnss/colors.dart';
import 'addEventApi.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _leaderController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTeacherName;
  String? _selectedProjectId;
  String? _selectedProjectLevel;
  List<String> _teacherNames = [];
  List<Project> _projects = [];
  final List<String> _projectLevels = ['Area', 'College', 'University', 'District', 'Adopted Area', 'Adopted Village'];

  @override
  void initState() {
    super.initState();
    _fetchTeacherNames();
    _fetchProjects();
    _getLeaderId();
  }

  Future<void> _getLeaderId() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderId = prefs.getString('leaderUniqueId') ?? '';
    setState(() {
      _leaderController.text = leaderId;
    });
  }

  Future<void> _fetchTeacherNames() async {
    try {
      final teachers = await fetchTeachers();
      setState(() {
        _teacherNames = teachers
            .map((teacher) => teacher.name)
            .toList();
      });
    } catch (e) {
    }
  }

  Future<void> _fetchProjects() async {
    try {
      final projects = await fetchProjects();
      setState(() {
        _projects = projects;
      });
    } catch (e) {
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
                    _buildTextField("Venue :", _venueController, deviceWidth),
                    _buildDatePicker("Date :", deviceWidth),
                    _buildTeacherDropdown("Teacher Incharge :", deviceWidth),
                    _buildTextField("Leader Id:", _leaderController, deviceWidth, isEnabled: false), // Make leader text field non-editable
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

  Widget _buildTextField(String label, TextEditingController controller, double deviceWidth, {bool isEnabled = true, bool isMultiline = false}) {
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
            enabled: isEnabled, // Disable text field if not editable
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
    List<String> projectNames = _projects.map((project) => project.projectName).toList();

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
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedProjectId != null ? AppColors.primaryBlue : Colors.grey.withOpacity(0.5),
                width: _selectedProjectId != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: CustomDropdown<String>(
                hintText: "Select Project",
                items: projectNames,
                initialItem: null, // Ensure no initial item is selected
                onChanged: (selectedValue) {
                  setState(() {
                    // Update the selectedProjectId only if a valid project is selected
                    _selectedProjectId = selectedValue != null
                        ? _projects.firstWhere(
                            (project) => project.projectName == selectedValue,
                        orElse: () => _projects.isEmpty ? Project(projectId: '', projectName: '') : _projects.first
                    ).projectId
                        : null; // Handle null case appropriately
                  });
                },
              ),
            ),
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
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedProjectLevel != null ? AppColors.primaryBlue : Colors.grey.withOpacity(0.5),
                width: _selectedProjectLevel != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: CustomDropdown<String>(
                hintText: "Project Level",
                items: _projectLevels,
                initialItem: _selectedProjectLevel,
                onChanged: (selectedValue) {
                  setState(() {
                    _selectedProjectLevel = selectedValue;
                  });
                },
              ),
            ),
          ),
        ],
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
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedTeacherName != null ? AppColors.primaryBlue : Colors.grey.withOpacity(0.5),
                width: _selectedTeacherName != null ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: CustomDropdown<String>(
                hintText: label,
                items: _teacherNames,
                initialItem: _selectedTeacherName,
                onChanged: (selectedValue) {
                  setState(() {
                    _selectedTeacherName = selectedValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton(double deviceWidth, double deviceHeight) {
    return ElevatedButton(
      onPressed: () async {
        if (_eventNameController.text.isEmpty ||
            _selectedDate == null ||
            _selectedTeacherName == null ||
            _leaderController.text.isEmpty ||
            _selectedProjectId == null ||
            _selectedProjectLevel == null ||
            _venueController.text.isEmpty) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please fill in all fields.',
          );
          return;
        }


        final success = await addEventDetails(
          name: _eventNameController.text,
          date: "${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}",
          level: _selectedProjectLevel!,
          venue: _venueController.text,
          teacherInCharge: _selectedTeacherName!,
          projectId: _selectedProjectId!,
          leaderId: _leaderController.text,
        );

        if (success) {
          Navigator.of(context).pop();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Event added Successfully!',
          );

        } else {
        QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Failed to add event.',
        );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.015, horizontal: deviceWidth * 0.2),
        backgroundColor: AppColors.primaryBlue, // Use primaryBlue for button background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text(
        'Add Event',
        style: TextStyle(
          color: AppColors.primaryRed,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
