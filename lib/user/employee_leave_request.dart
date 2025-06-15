import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class EmployeeLeaveRequestScreen extends StatefulWidget {
  const EmployeeLeaveRequestScreen({super.key});

  @override
  _EmployeeLeaveRequestScreenState createState() => _EmployeeLeaveRequestScreenState();
}

class _EmployeeLeaveRequestScreenState extends State<EmployeeLeaveRequestScreen> {
  DateTime? _leaveFrom;
  DateTime? _leaveTo;
  String? _leaveType;
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;
  DateTime _focusedDay = DateTime.now();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _submitLeaveRequest() async {
    if (_leaveFrom == null || _leaveTo == null || _leaveType == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeId = prefs.getString('loggedInUserId');
    if (employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('$baseURL/leaves');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'employee_id': int.parse(employeeId),
        'leave_from': _dateFormat.format(_leaveFrom!),
        'leave_to': _dateFormat.format(_leaveTo!),
        'leave_type': _leaveType,
        'leave_reason': _reasonController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave request submitted successfully')),
      );
      _leaveFrom = null;
      _leaveTo = null;
      _leaveType = null;
      _reasonController.clear();
      setState(() {});
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error['message'] ?? 'Failed to submit leave request'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.emeraldGreen,
      appBar: AppBar(
        backgroundColor: AppColors.emeraldGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.planeGray),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apply for Leave',
          style: TextStyle(color: AppColors.planeGray, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: size.width * 0.9,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: AppColors.planeGray,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Submit Leave Request',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Leave Dates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                const SizedBox(height: 10),
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    if (_leaveFrom == null || _leaveTo == null) return false;
                    return day.isAfter(_leaveFrom!.subtract(const Duration(days: 1))) &&
                        day.isBefore(_leaveTo!.add(const Duration(days: 1)));
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      if (_leaveFrom == null || (_leaveFrom != null && _leaveTo != null)) {
                        _leaveFrom = selectedDay;
                        _leaveTo = null;
                      } else if (_leaveFrom != null && selectedDay.isAfter(_leaveFrom!)) {
                        _leaveTo = selectedDay;
                      }
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    rangeHighlightColor: AppColors.emeraldGreen.withOpacity(0.3),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Leave Type',
                    labelStyle: TextStyle(color: AppColors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2.0),
                    ),
                  ),
                  value: _leaveType,
                  items: ['full_day', 'half_day'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type == 'full_day' ? 'Full Day' : 'Half Day'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _leaveType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  maxLength: 250,
                  decoration: const InputDecoration(
                    labelText: 'Leave Reason',
                    labelStyle: TextStyle(color: AppColors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.black, width: 2.0),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitLeaveRequest,
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      color: AppColors.planeGray,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}