import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global_API.dart';

class DeleteEmployeePage extends StatelessWidget {
  final int employeeId; // ID of the employee to delete
  final Function onDeleteSuccess; // Callback for successful deletion

  const DeleteEmployeePage({super.key, required this.employeeId, required this.onDeleteSuccess});

  Future<void> deleteEmployee(BuildContext context) async {
    final response = await http.delete(
      Uri.parse('$baseURL/employees/$employeeId'),
    );

    if (response.statusCode == 200) {
      onDeleteSuccess();
      Navigator.pop(context); // Close the dialog after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete employee.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this employee?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            deleteEmployee(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}