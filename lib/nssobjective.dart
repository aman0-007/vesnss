import 'package:flutter/material.dart';

class NSSObjectives extends StatelessWidget {
  const NSSObjectives({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'National Service Scheme (NSS) Objectives',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildObjectiveItem(
            Icons.volunteer_activism,
            'Empower Through Service',
            'Ignite a passion for community service among students, driving positive change in local communities.',
          ),
          _buildObjectiveItem(
            Icons.person,
            'Grow Personally and Socially',
            'Enhance personal growth and leadership skills while tackling real-world challenges.',
          ),
          _buildObjectiveItem(
            Icons.flag,
            'Instill Responsibility',
            'Foster a sense of discipline, empathy, and responsibility through hands-on involvement in service activities.',
          ),
          _buildObjectiveItem(
            Icons.people,
            'Connect and Collaborate',
            'Strengthen community bonds and create a bridge between academic learning and societal contribution.',
          ),
          const SizedBox(height: 16.0),
          Text(
            'NSS aims to transform students into socially responsible leaders, shaping a brighter and more compassionate future.',
            style: TextStyle(
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 30.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
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