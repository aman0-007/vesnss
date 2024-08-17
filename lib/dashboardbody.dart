import 'package:flutter/material.dart';

class Dashboardbody extends StatelessWidget {
  const Dashboardbody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120, // Set the width for the container
            height: 120, // Set the height for the container
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Makes the container circular
              border: Border.all(
                color: Colors.red, // Set the border color to red
                width: 2.0, // Set the border width
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
              child: ClipOval(
                child: Image.asset(
                  'assets/logo/nss.png', // Path to your logo image
                  width: 120, // Set the width for the logo
                  height: 120, // Set the height for the logo
                  fit: BoxFit.contain, // Ensures the logo is contained within the bounds
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'The National Service Scheme (NSS) is an Indian program that encourages student '
                  'community service to foster leadership and social'
                  ' responsibility. It includes activities like health camps and environmental projects.',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
