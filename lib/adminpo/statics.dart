import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vesnss/colors.dart';

class Statics extends StatefulWidget {
  const Statics({super.key});

  @override
  State<Statics> createState() => _StaticsState();
}

class _StaticsState extends State<Statics> {
  int touchedIndex = -1;

  // Dummy data to simulate API response
  final List<Map<String, dynamic>> dummyData = [
    {
      "project_id": "AP001",
      "project_name": "Aman Project",
      "total_events": 10
    },
    {
      "project_id": "P000000007",
      "project_name": "TestProject",
      "total_events": 20
    },
    {
      "project_id": "PROJ001",
      "project_name": "RRC - Red Ribbon Club",
      "total_events": 15
    },
    {
      "project_id": "PROJ002",
      "project_name": "Health & Hygiene",
      "total_events": 25
    }
  ];

  // Colors for the bars and pie slices
  final List<Color> barColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    // Get device width and height
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    // Calculate total events
    final int totalEvents = dummyData.fold<int>(0, (sum, project) => sum + (project['total_events'] as int));

    // Convert dummy data to BarChartData
    final List<BarChartGroupData> barGroups = dummyData
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final project = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (project['total_events'] as int).toDouble(), // Convert total_events to double
            color: barColors[index % barColors.length], // Assign color based on index
            width: 20, // Set width of each bar
            borderRadius: BorderRadius.circular(4), // Round the corners
          ),
        ],
      );
    }).toList();

    // Convert dummy data to PieChartData with count and percentage labels
    final List<PieChartSectionData> pieSections = dummyData.asMap().entries.map((entry) {
      final index = entry.key;
      final project = entry.value;
      final count = (project['total_events'] as int).toDouble();
      final percentage = count / totalEvents * 100;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0; // Adjusted font size
      final radius = isTouched ? 70.0 : 60.0; // Increased radius

      return PieChartSectionData(
        color: barColors[index % barColors.length], // Assign color based on index
        value: count, // Convert total_events to double
        title: '${count.toInt()} (${percentage.toStringAsFixed(1)}%)', // Display count and percentage
        radius: radius, // Adjust radius for pie slices
        titleStyle: TextStyle(
          fontSize: fontSize, // Adjust font size based on touch state
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)], // Add shadows to titles
        ),
        showTitle: true, // Show titles on slices
        titlePositionPercentageOffset: 0.55, // Adjust position to fit inside the pie slice
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // Use primaryBlue for AppBar background
        title: const Text(
          'Stats', // Title set to 'Stats'
          style: TextStyle(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryRed),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display legend
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 16.0, // Space between columns
                runSpacing: 8.0, // Space between rows
                children: List.generate(dummyData.length, (index) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 64) / 3, // Adjust width to fit three items per row
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: barColors[index % barColors.length],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dummyData[index]['project_name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // Display total events
            Text(
              'Total Events: $totalEvents',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Display BarChart
            Container(
              width: deviceWidth * 0.9, // Set width to 90% of the device width
              height: deviceHeight * 0.3, // Set height to 30% of the device height
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false, // Hide bottom titles
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  barGroups: barGroups,
                  alignment: BarChartAlignment.spaceEvenly,
                ),
              ),
            ),
            // Display PieChart
            Container(
              width: deviceWidth * 0.9, // Set width to 90% of the device width
              height: deviceHeight * 0.4, // Set height to 40% of the device height for larger pie chart
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2, // Small space between sections
                  centerSpaceRadius: 40, // Increased center space radius
                  sections: pieSections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
