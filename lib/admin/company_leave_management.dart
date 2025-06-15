import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/utils/admin_colors.dart'; // Updated to use admin_colors.dart
import 'package:shared_preferences/shared_preferences.dart';

class CompanyLeaveManagementScreen extends StatefulWidget {
  const CompanyLeaveManagementScreen({super.key});

  @override
  _CompanyLeaveManagementScreenState createState() => _CompanyLeaveManagementScreenState();
}

class _CompanyLeaveManagementScreenState extends State<CompanyLeaveManagementScreen> {
  List<dynamic> _leaveRequests = [];
  bool _isLoading = true;
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  Future<void> _fetchLeaveRequests() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyId = prefs.getString('loggedInUserId'); // Use loggedInUserId as company_id
    if (companyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company not found')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$baseURL/leaves?company_id=$companyId');
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _leaveRequests = data['leaves'];
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch leave requests')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateLeaveStatus(int leaveId, String status, String? adminNote) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyId = prefs.getString('loggedInUserId'); // Use loggedInUserId as company_id
    if (companyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company not found')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$baseURL/leaves/$leaveId/status');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'company_id': int.parse(companyId),
        'status': status,
        'admin_description': adminNote ?? '',
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave $status successfully')),
      );
      _fetchLeaveRequests(); // Refresh the list
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error['message'] ?? 'Failed to update status'}')),
      );
    }
  }

  Future<void> _showAdminNoteDialog(int leaveId, String status) async {
    final TextEditingController noteController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$status Leave Request'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Admin Note (Optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.charcoalGray)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.forestGreen),
            onPressed: () {
              _updateLeaveStatus(leaveId, status.toLowerCase(), noteController.text);
              Navigator.pop(context);
            },
            child: const Text('Submit', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Leave Requests',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.white))
          : _leaveRequests.isEmpty
          ? const Center(
        child: Text(
          'No leave requests found',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _leaveRequests.length,
        itemBuilder: (context, index) {
          final leave = _leaveRequests[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee: ${leave['name']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoalGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Email: ${leave['email']}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text('Contact: ${leave['contact_no']}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text('From: ${_dateFormat.format(DateTime.parse(leave['leave_from']))}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text('To: ${_dateFormat.format(DateTime.parse(leave['leave_to']))}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text('Type: ${leave['leave_type'] == 'full_day' ? 'Full Day' : 'Half Day'}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text('Reason: ${leave['leave_reason']}', style: const TextStyle(color: AppColors.charcoalGray)),
                  Text(
                    'Status: ${leave['status'][0].toUpperCase()}${leave['status'].substring(1)}',
                    style: TextStyle(
                      color: leave['status'] == 'pending'
                          ? Colors.orange
                          : leave['status'] == 'approved'
                          ? AppColors.forestGreen
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (leave['admin_notes'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Admin Note: ${leave['admin_notes'][0]['admin_description']}', style: const TextStyle(color: AppColors.charcoalGray)),
                    ),
                  const SizedBox(height: 12),
                  if (leave['status'] == 'pending')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.forestGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _showAdminNoteDialog(leave['id'], 'Approved'),
                          child: const Text('Approve', style: TextStyle(color: AppColors.white)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _showAdminNoteDialog(leave['id'], 'Denied'),
                          child: const Text('Deny', style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}