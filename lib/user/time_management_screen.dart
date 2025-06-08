import 'package:flutter/material.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeEntry {
  String id;
  String employeeId;
  DateTime date;
  String intime;
  String location;
  String? mobileModel;

  TimeEntry({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.intime,
    required this.location,
    this.mobileModel,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'].toString(),
      employeeId: json['employee_id'].toString(),
      date: DateTime.parse(json['date']),
      intime: json['intime'],
      location: json['location'],
      mobileModel: json['mobile_model'],
    );
  }
}

class ApiService {
  final String _baseUrl = 'https://qr.albsocial.in/api/attendances';
  final String _companyId = '56';

  Future<List<TimeEntry>> fetchEntries() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?company_id=$_companyId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TimeEntry.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load attendance data: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to dummy data if API fails
      print('API Error: $e');
      return [
        TimeEntry(
          id: '1',
          employeeId: 'EMP001',
          date: DateTime.now().subtract(const Duration(days: 1)),
          intime: '09:00 AM',
          location: 'Office A',
          mobileModel: 'Samsung Galaxy',
        ),
        TimeEntry(
          id: '2',
          employeeId: 'EMP002',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          intime: '02:00 PM',
          location: 'Office B',
          mobileModel: 'iPhone 13',
        ),
      ];
    }
  }
}

class TimeManagementScreen extends StatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  _TimeManagementScreenState createState() => _TimeManagementScreenState();
}

class _TimeManagementScreenState extends State<TimeManagementScreen> {
  final ApiService _apiService = ApiService();
  List<TimeEntry> _entries = [];
  String _currentTime = '';
  String _currentDate = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('yyyy-MM-dd').format(now);
    });
  }

  Future<void> _loadEntries() async {
    final entries = await _apiService.fetchEntries();
    setState(() {
      _entries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Time Entries'),
        backgroundColor: AppColors.softSlateBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGrayBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Time: $_currentTime',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavyBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: $_currentDate',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.darkNavyBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadEntries,
                child: ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          'Employee ID: ${entry.employeeId}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(entry.date)}'),
                            Text('In Time: ${entry.intime}'),
                            Text('Location: ${entry.location}'),
                            if (entry.mobileModel != null)
                              Text('Mobile Model: ${entry.mobileModel}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
