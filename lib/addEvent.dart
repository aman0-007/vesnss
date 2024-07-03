import 'package:flutter/material.dart';
import 'package:vesnss/dashboard.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E478A),
        title: const Text(
          'Add Event',
          style: TextStyle(color: Color(0xFFF5180F), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5180F)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.all(deviceWidth * 0.07), // Optional: margin around the container
              padding: EdgeInsets.all(deviceWidth * 0.03), // Optional: padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Grey border with opacity
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(12.0), // Circular edges
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: deviceHeight * 0.030),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Event",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2E478A)),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.grey, // Color of the divider
                      thickness: 1, // Thickness of the line
                    ),
                    SizedBox(height: deviceHeight * 0.030),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Event Name :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Date :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Teacher Incharge :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Leader :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Project Name:",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Project Level :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.020),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Description :",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: null, // Allows unlimited lines for the description
                              textAlignVertical: TextAlignVertical.bottom, // Align text to start from the bottom
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.5), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF2E478A), // Focused border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 80.0), // Adjust vertical padding for height
                              ),
                              style: const TextStyle(
                                fontSize: 14.0, // Text size
                                color: Colors.black87, // Text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: deviceHeight * 0.035),
                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E478A),
                              elevation: 5,
                              minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.057),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Dashboard()),
                              );
                            },
                            child: const Text(
                              'Publish Event',
                              style: TextStyle(color: Color(0xFFF5180F), fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.030),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
