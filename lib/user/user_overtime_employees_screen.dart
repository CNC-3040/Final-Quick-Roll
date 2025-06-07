import 'package:flutter/material.dart';
import 'package:quick_roll/utils/user_colors.dart';

class OvertimeEmployeesScreen extends StatelessWidget {
  const OvertimeEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final overtimeData = [
      {'Name': 'John Doe', 'Overtime Hours': 8},
      {'Name': 'Jane Smith', 'Overtime Hours': 10},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Overtime Employees',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 20, // Font size
            color: AppColors.darkNavyBlue, // Set text color to charcoal gray
          ),
        ),
        backgroundColor: AppColors.softSlateBlue, // Sky Blue top bar color
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Overtime Employees List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavyBlue, // Dark charcoal color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: overtimeData.length,
                  itemBuilder: (context, index) {
                    final employee = overtimeData[index];
                    return Card(
                      color: AppColors.lightGrayBlue, // Set the card's background color to baby blue
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                      child: ListTile(
                        title: Text(
                          employee['Name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // Bold name text
                            color: AppColors.darkNavyBlue, // Dark charcoal color
                          ),
                        ),
                        subtitle: Text(
                          'Overtime Hours: ${employee['Overtime Hours']}',
                          style: const TextStyle(
                            color: AppColors.darkNavyBlue, // Dark charcoal color
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
