import 'package:flutter/material.dart';
import 'package:vesnss/colors.dart';
import 'package:vesnss/dashboard.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _passwordController = TextEditingController();
  final bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(deviceWidth * 0.07),
              padding: EdgeInsets.all(deviceWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    _buildTextField("Event Name :", deviceWidth),
                    _buildTextField("Date :", deviceWidth),
                    _buildTextField("Teacher Incharge :", deviceWidth),
                    _buildTextField("Leader :", deviceWidth),
                    _buildTextField("Project Name:", deviceWidth),
                    _buildTextField("Project Level :", deviceWidth),
                    _buildTextField("Description :", deviceWidth, isMultiline: true),
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
      backgroundColor: AppColors.primaryBlue,
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
      padding: EdgeInsets.only(top: deviceHeight * 0.007  ),
      child: const Text(
        "Add Event",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.primaryBlue,
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

  Widget _buildTextField(String label, double deviceWidth, {bool isMultiline = false}) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          TextField(
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
                  color: AppColors.primaryBlue,
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

  Widget _buildPublishButton(double deviceWidth, double deviceHeight) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              elevation: 5,
              minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
            child: const Text(
              'Publish Event',
              style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
