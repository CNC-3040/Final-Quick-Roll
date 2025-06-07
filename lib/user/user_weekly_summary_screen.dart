import 'package:flutter/material.dart';
import 'package:quick_roll/utils/user_colors.dart';

class WeeklySummaryScreen extends StatelessWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {'Week': '1st - 7th', 'Present': 5, 'Absent': 2},
      {'Week': '8th - 14th', 'Present': 6, 'Absent': 1},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weekly Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the text bold
            fontSize: 20, // Optionally adjust the font size
          ),
        ),
        backgroundColor: AppColors.softSlateBlue, // AppBar color
        iconTheme: const IconThemeData(
          color: AppColors.darkNavyBlue, // Set back arrow color to darkNavyBlue
        ),
        // Set text color in the AppBar
        titleTextStyle: const TextStyle(
          color: AppColors.darkNavyBlue, // Set the title text color to darkNavyBlue
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Weekly Attendance Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepSkyBlue, // Set the text color to deepSkyBlue
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => AppColors.deepSkyBlue.withOpacity(0.4),
                    ),
                    dataRowColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.white, // White row background
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Week',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.midnightBlue, // Bold and dark charcoal color
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Present',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.midnightBlue,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Absent',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkNavyBlue,
                          ),
                        ),
                      ),
                    ],
                    rows: dummyData.map((data) {
                      return DataRow(cells: [
                        DataCell(
                          Text(
                            data['Week'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold, // Bold text
                              color: AppColors.darkNavyBlue, // Dark charcoal color
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['Present'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkNavyBlue,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            data['Absent'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.midnightBlue,
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
