// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   Map<int, Map<String, dynamic>> _employees = {};
//   Map<int, List<dynamic>> _attendanceByEmployee = {};
//   bool _isLoading = false;
//   String? _errorMessage;
//   DateTime? _fromDate;
//   DateTime? _toDate;
//   bool _sortAscending = true;

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   final TextEditingController _fromDateController = TextEditingController();
//   final TextEditingController _toDateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchAttendances();
//   }

//   @override
//   void dispose() {
//     _fromDateController.dispose();
//     _toDateController.dispose();
//     _refreshController.dispose();
//     super.dispose();
//   }

//   bool _isBase64(String str) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(str) && (str.length % 4 == 0);
//   }

//   Future<Image> _decodeBase64Image(String base64String) async {
//     try {
//       final Uint8List bytes = base64Decode(base64String);
//       return Image.memory(bytes, fit: BoxFit.cover);
//     } catch (e) {
//       throw Exception('Failed to decode image: $e');
//     }
//   }

//   Future<void> _fetchAttendances() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final url = Uri.parse('$baseURL/attendances?company_id=$global_cid');
//       debugPrint('📤 Fetching attendances for company_id: $global_cid');
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final List<dynamic> attendances = jsonResponse['data'] ?? [];

//         setState(() {
//           _employees.clear();
//           _attendanceByEmployee.clear();

//           for (var attendance in attendances) {
//             final employee = attendance['employee'] ?? {};
//             final employeeId = employee['id'] ?? 0;

//             if (employeeId != 0) {
//               _employees[employeeId] = employee;
//               _attendanceByEmployee.putIfAbsent(employeeId, () => []);
//               _attendanceByEmployee[employeeId]!.add(attendance);
//             }
//           }

//           _applyFilterAndSort();
//         });
//       } else {
//         setState(() {
//           _errorMessage =
//               'Failed to load attendance records: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//       });
//       debugPrint('❌ Error fetching attendances: $e');
//     } finally {
//       setState(() => _isLoading = false);
//       _refreshController.refreshCompleted();
//     }
//   }

//   void _applyFilterAndSort() {
//     setState(() {
//       _employees.clear();
//       final Map<int, List<dynamic>> filteredAttendance = {};

//       _attendanceByEmployee.forEach((employeeId, attendances) {
//         final filtered = attendances.where((attendance) {
//           final attendanceDate = DateTime.parse(attendance['date']);
//           bool matchesDateRange = true;

//           if (_fromDate != null) {
//             matchesDateRange = matchesDateRange &&
//                 (attendanceDate.isAtSameMomentAs(_fromDate!) ||
//                     attendanceDate.isAfter(_fromDate!));
//           }
//           if (_toDate != null) {
//             matchesDateRange = matchesDateRange &&
//                 (attendanceDate.isAtSameMomentAs(_toDate!) ||
//                     attendanceDate
//                         .isBefore(_toDate!.add(const Duration(days: 1))));
//           }

//           return matchesDateRange;
//         }).toList();

//         if (filtered.isNotEmpty) {
//           filteredAttendance[employeeId] = filtered;
//           _employees[employeeId] =
//               _attendanceByEmployee[employeeId]!.first['employee'];
//         }
//       });

//       _attendanceByEmployee = filteredAttendance;

//       _attendanceByEmployee.forEach((employeeId, attendances) {
//         attendances.sort((a, b) {
//           final dateA = DateTime.parse(a['date']);
//           final dateB = DateTime.parse(b['date']);
//           return _sortAscending
//               ? dateA.compareTo(dateB)
//               : dateB.compareTo(dateA);
//         });
//       });
//     });
//   }

//   Future<void> _pickDate(BuildContext context, bool isFromDate) async {
//     final initialDate = isFromDate
//         ? (_fromDate ?? DateTime.now())
//         : (_toDate ?? DateTime.now());
//     final firstDate = DateTime(2000);
//     final lastDate = DateTime.now();

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: AppColors.primaryTeal,
//               onPrimary: AppColors.white,
//               onSurface: AppColors.darkGray,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style:
//                   TextButton.styleFrom(foregroundColor: AppColors.primaryTeal),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//           _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//         } else {
//           _toDate = picked;
//           _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//         }
//         _applyFilterAndSort();
//       });
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final parsedDate = DateTime.parse(date);
//       return DateFormat('dd MMM yyyy').format(parsedDate);
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   String _formatTime(String? time) {
//     if (time == null || time == '00:00') return 'N/A';
//     try {
//       final parsedTime = DateFormat('HH:mm').parse(time);
//       return DateFormat('h:mm a').format(parsedTime);
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   String _formatWorkingHours(String? hours) {
//     if (hours == null) return '00:00';
//     try {
//       final decimalHours = double.parse(hours);
//       final int totalMinutes = (decimalHours * 60).round();
//       final int h = totalMinutes ~/ 60;
//       final int m = totalMinutes % 60;
//       return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return '00:00';
//     }
//   }

//   String _formatMobileModel(String? model) {
//     return model ?? 'N/A';
//   }

//   void _showAttendanceDetails(BuildContext context, int employeeId) {
//     final attendances = _attendanceByEmployee[employeeId] ?? [];
//     final employee = _employees[employeeId] ?? {};

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, anim1, anim2) {
//         return ScaleTransition(
//           scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
//           child: Dialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             child: Container(
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.7,
//                 maxWidth: MediaQuery.of(context).size.width * 0.9,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primaryTeal, AppColors.accentBlue],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           employee['name'] ?? 'Unknown',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.white,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: AppColors.white),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Flexible(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: attendances.isEmpty
//                             ? Center(
//                                 child: Text(
//                                   'No attendance records found for this date range.',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     color: AppColors.darkGray,
//                                   ),
//                                 ),
//                               )
//                             : SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   headingRowColor: WidgetStateProperty.all(
//                                       AppColors.lightTeal.withOpacity(0.2)),
//                                   dataRowColor:
//                                       WidgetStateProperty.all(AppColors.white),
//                                   columns: [
//                                     DataColumn(
//                                       label: Text(
//                                         'Date',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'In Time',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Out Time',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Hours',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Mobile Model',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                   ],
//                                   rows: attendances.map((attendance) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(Text(
//                                           _formatDate(attendance['date']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatTime(attendance['intime']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatTime(attendance['outtime']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatWorkingHours(
//                                               attendance['working_hours']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatMobileModel(
//                                               attendance['mobile_model']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryTeal,
//         title: Text(
//           'Employee Attendance',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             color: AppColors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: AppColors.white),
//             onPressed: _fetchAttendances,
//           ),
//         ],
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.lightGray, AppColors.lightTeal],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SmartRefresher(
//           controller: _refreshController,
//           onRefresh: _fetchAttendances,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Date Filter Section
//                   Card(
//                     elevation: 6,
//                     color: AppColors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Filter by Date Range',
//                             style: GoogleFonts.poppins(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primaryTeal,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _fromDateController,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'From Date',
//                                     labelStyle: GoogleFonts.poppins(
//                                         color: AppColors.darkGray),
//                                     prefixIcon: const Icon(Icons.calendar_today,
//                                         color: AppColors.primaryTeal),
//                                     filled: true,
//                                     fillColor:
//                                         AppColors.lightGray.withOpacity(0.2),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: const BorderSide(
//                                           color: AppColors.primaryTeal,
//                                           width: 2),
//                                     ),
//                                   ),
//                                   onTap: () => _pickDate(context, true),
//                                   style: GoogleFonts.poppins(),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _toDateController,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'To Date',
//                                     labelStyle: GoogleFonts.poppins(
//                                         color: AppColors.darkGray),
//                                     prefixIcon: const Icon(Icons.calendar_today,
//                                         color: AppColors.primaryTeal),
//                                     filled: true,
//                                     fillColor:
//                                         AppColors.lightGray.withOpacity(0.2),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: const BorderSide(
//                                           color: AppColors.primaryTeal,
//                                           width: 2),
//                                     ),
//                                   ),
//                                   onTap: () => _pickDate(context, false),
//                                   style: GoogleFonts.poppins(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 setState(() {
//                                   _fromDate = null;
//                                   _toDate = null;
//                                   _fromDateController.clear();
//                                   _toDateController.clear();
//                                   _applyFilterAndSort();
//                                 });
//                               },
//                               icon: const Icon(Icons.clear, size: 18),
//                               label: Text(
//                                 'Clear Filters',
//                                 style: GoogleFonts.poppins(),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.accentBlue,
//                                 foregroundColor: AppColors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Employee List
//                   Card(
//                     elevation: 6,
//                     color: AppColors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: _isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                                 color: AppColors.primaryTeal),
//                           )
//                         : _errorMessage != null
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       _errorMessage!,
//                                       style: GoogleFonts.poppins(
//                                           color: AppColors.errorRed),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     ElevatedButton.icon(
//                                       onPressed: _fetchAttendances,
//                                       icon: const Icon(Icons.refresh, size: 18),
//                                       label: Text(
//                                         'Retry',
//                                         style: GoogleFonts.poppins(),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primaryTeal,
//                                         foregroundColor: AppColors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : _employees.isEmpty
//                                 ? Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Text(
//                                         'No employees found for the selected date range.',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16,
//                                           color: AppColors.darkGray,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   )
//                                 : ListView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: _employees.length,
//                                     itemBuilder: (context, index) {
//                                       final employeeId =
//                                           _employees.keys.elementAt(index);
//                                       final employee = _employees[employeeId]!;
//                                       final photoPath = employee['photo_path'];

//                                       return Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8.0, horizontal: 16.0),
//                                         child: AnimatedContainer(
//                                           duration:
//                                               const Duration(milliseconds: 300),
//                                           curve: Curves.easeInOut,
//                                           child: Card(
//                                             elevation: 4,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                             ),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   colors: [
//                                                     AppColors.white,
//                                                     AppColors.lightTeal
//                                                         .withOpacity(0.1),
//                                                   ],
//                                                   begin: Alignment.topLeft,
//                                                   end: Alignment.bottomRight,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                               ),
//                                               child: ListTile(
//                                                 leading: CircleAvatar(
//                                                   radius: 30,
//                                                   backgroundColor:
//                                                       AppColors.lightGray,
//                                                   child: ClipOval(
//                                                     child: photoPath != null &&
//                                                             _isBase64(photoPath)
//                                                         ? FutureBuilder<Image>(
//                                                             future:
//                                                                 _decodeBase64Image(
//                                                                     photoPath),
//                                                             builder: (context,
//                                                                 snapshot) {
//                                                               if (snapshot
//                                                                       .connectionState ==
//                                                                   ConnectionState
//                                                                       .waiting) {
//                                                                 return const SizedBox(
//                                                                   height: 60,
//                                                                   width: 60,
//                                                                   child: Center(
//                                                                       child:
//                                                                           CircularProgressIndicator()),
//                                                                 );
//                                                               } else if (snapshot
//                                                                       .hasError ||
//                                                                   snapshot.data ==
//                                                                       null) {
//                                                                 return const Icon(
//                                                                   Icons.person,
//                                                                   size: 40,
//                                                                   color: AppColors
//                                                                       .darkGray,
//                                                                 );
//                                                               }
//                                                               return SizedBox(
//                                                                 height: 60,
//                                                                 width: 60,
//                                                                 child: snapshot
//                                                                     .data!,
//                                                               );
//                                                             },
//                                                           )
//                                                         : Image.network(
//                                                             photoPath ?? '',
//                                                             height: 60,
//                                                             width: 60,
//                                                             fit: BoxFit.cover,
//                                                             errorBuilder: (context,
//                                                                     error,
//                                                                     stackTrace) =>
//                                                                 const Icon(
//                                                               Icons.person,
//                                                               size: 40,
//                                                               color: AppColors
//                                                                   .darkGray,
//                                                             ),
//                                                           ),
//                                                   ),
//                                                 ),
//                                                 title: Text(
//                                                   employee['name'] ?? 'N/A',
//                                                   style: GoogleFonts.poppins(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                                 subtitle: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       employee['email'] ??
//                                                           'N/A',
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         fontSize: 14,
//                                                         color:
//                                                             AppColors.darkGray,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       employee['contact'] ??
//                                                           'N/A',
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         fontSize: 14,
//                                                         color:
//                                                             AppColors.darkGray,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 onTap: () =>
//                                                     _showAttendanceDetails(
//                                                         context, employeeId),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   Map<int, Map<String, dynamic>> _employees = {};
//   Map<int, List<dynamic>> _attendanceByEmployee = {};
//   bool _isLoading = false;
//   String? _errorMessage;
//   DateTime? _fromDate;
//   DateTime? _toDate;
//   bool _sortAscending = true;

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   final TextEditingController _fromDateController = TextEditingController();
//   final TextEditingController _toDateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchAttendances();
//   }

//   @override
//   void dispose() {
//     _fromDateController.dispose();
//     _toDateController.dispose();
//     _refreshController.dispose();
//     super.dispose();
//   }

//   bool _isBase64(String str) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(str) && (str.length % 4 == 0);
//   }

//   Future<Image> _decodeBase64Image(String base64String) async {
//     try {
//       final Uint8List bytes = base64Decode(base64String);
//       return Image.memory(bytes, fit: BoxFit.cover);
//     } catch (e) {
//       throw Exception('Failed to decode image: $e');
//     }
//   }

//   Future<void> _fetchAttendances() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final url = Uri.parse('$baseURL/attendances?company_id=$global_cid');
//       debugPrint('📤 Fetching attendances for company_id: $global_cid');
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final List<dynamic> attendances = jsonResponse['data'] ?? [];

//         setState(() {
//           _employees.clear();
//           _attendanceByEmployee.clear();

//           for (var attendance in attendances) {
//             final employee = attendance['employee'] ?? {};
//             final employeeId = employee['id'] ?? 0;

//             if (employeeId != 0) {
//               _employees[employeeId] = employee;
//               _attendanceByEmployee.putIfAbsent(employeeId, () => []);
//               _attendanceByEmployee[employeeId]!.add(attendance);
//             }
//           }

//           _applyFilterAndSort();
//         });
//       } else {
//         setState(() {
//           _errorMessage =
//               'Failed to load attendance records: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//       });
//       debugPrint('❌ Error fetching attendances: $e');
//     } finally {
//       setState(() => _isLoading = false);
//       _refreshController.refreshCompleted();
//     }
//   }

//   void _applyFilterAndSort() {
//     setState(() {
//       _employees.clear();
//       final Map<int, List<dynamic>> filteredAttendance = {};

//       _attendanceByEmployee.forEach((employeeId, attendances) {
//         final filtered = attendances.where((attendance) {
//           final attendanceDate = DateTime.parse(attendance['date']);
//           bool matchesDateRange = true;

//           if (_fromDate != null) {
//             matchesDateRange = matchesDateRange &&
//                 (attendanceDate.isAtSameMomentAs(_fromDate!) ||
//                     attendanceDate.isAfter(_fromDate!));
//           }
//           if (_toDate != null) {
//             matchesDateRange = matchesDateRange &&
//                 (attendanceDate.isAtSameMomentAs(_toDate!) ||
//                     attendanceDate
//                         .isBefore(_toDate!.add(const Duration(days: 1))));
//           }

//           return matchesDateRange;
//         }).toList();

//         if (filtered.isNotEmpty) {
//           filteredAttendance[employeeId] = filtered;
//           _employees[employeeId] =
//               _attendanceByEmployee[employeeId]!.first['employee'];
//         }
//       });

//       _attendanceByEmployee = filteredAttendance;

//       _attendanceByEmployee.forEach((employeeId, attendances) {
//         attendances.sort((a, b) {
//           final dateA = DateTime.parse(a['date']);
//           final dateB = DateTime.parse(b['date']);
//           return _sortAscending
//               ? dateA.compareTo(dateB)
//               : dateB.compareTo(dateA);
//         });
//       });
//     });
//   }

//   Future<void> _pickDate(BuildContext context, bool isFromDate) async {
//     final initialDate = isFromDate
//         ? (_fromDate ?? DateTime.now())
//         : (_toDate ?? DateTime.now());
//     final firstDate = DateTime(2000);
//     final lastDate = DateTime.now();

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: lastDate,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: AppColors.primaryTeal,
//               onPrimary: AppColors.white,
//               onSurface: AppColors.darkGray,
//             ),
//             textButtonTheme: TextButtonThemeData(
//               style:
//                   TextButton.styleFrom(foregroundColor: AppColors.primaryTeal),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isFromDate) {
//           _fromDate = picked;
//           _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//         } else {
//           _toDate = picked;
//           _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
//         }
//         _applyFilterAndSort();
//       });
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final parsedDate = DateTime.parse(date);
//       return DateFormat('dd MMM yyyy').format(parsedDate);
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   String _formatTime(String? time) {
//     if (time == null || time == '00:00') return 'N/A';
//     try {
//       final parsedTime = DateFormat('HH:mm').parse(time);
//       return DateFormat('h:mm a').format(parsedTime);
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   String _formatWorkingHours(String? hours) {
//     if (hours == null) return '00:00';
//     try {
//       final decimalHours = double.parse(hours);
//       final int totalMinutes = (decimalHours * 60).round();
//       final int h = totalMinutes ~/ 60;
//       final int m = totalMinutes % 60;
//       return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return '00:00';
//     }
//   }

//   String _formatMobileModel(String? model) {
//     return model ?? 'N/A';
//   }

//   void _showAttendanceDetails(BuildContext context, int employeeId) {
//     final attendances = _attendanceByEmployee[employeeId] ?? [];
//     final employee = _employees[employeeId] ?? {};

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (context, anim1, anim2) {
//         return ScaleTransition(
//           scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
//           child: Dialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             child: Container(
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.7,
//                 maxWidth: MediaQuery.of(context).size.width * 0.9,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [AppColors.primaryTeal, AppColors.accentBlue],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           employee['name'] ?? 'Unknown',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.white,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: AppColors.white),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Flexible(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: attendances.isEmpty
//                             ? Center(
//                                 child: Text(
//                                   'No attendance records found for this date range.',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     color: AppColors.darkGray,
//                                   ),
//                                 ),
//                               )
//                             : SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   headingRowColor: WidgetStateProperty.all(
//                                       AppColors.lightTeal.withOpacity(0.2)),
//                                   dataRowColor:
//                                       WidgetStateProperty.all(AppColors.white),
//                                   columns: [
//                                     DataColumn(
//                                       label: Text(
//                                         'Date',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'In Time',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Out Time',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Hours',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     DataColumn(
//                                       label: Text(
//                                         'Mobile Model',
//                                         style: GoogleFonts.poppins(
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                   ],
//                                   rows: attendances.map((attendance) {
//                                     return DataRow(
//                                       cells: [
//                                         DataCell(Text(
//                                           _formatDate(
//                                               attendance['date'] ?? 'N/A'),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatTime(attendance['intime']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatTime(attendance['outtime']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatWorkingHours(
//                                               attendance['working_hours']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                         DataCell(Text(
//                                           _formatMobileModel(
//                                               attendance['mobile_model']),
//                                           style: GoogleFonts.poppins(),
//                                         )),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryTeal,
//         title: Text(
//           'Employee Attendance',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             color: AppColors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: AppColors.white),
//             onPressed: _fetchAttendances,
//           ),
//         ],
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.lightGray, AppColors.lightTeal],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SmartRefresher(
//           controller: _refreshController,
//           onRefresh: _fetchAttendances,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Date Filter Section
//                   Card(
//                     elevation: 6,
//                     color: AppColors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Filter by Date Range',
//                             style: GoogleFonts.poppins(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primaryTeal,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _fromDateController,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'From Date',
//                                     labelStyle: GoogleFonts.poppins(
//                                         color: AppColors.darkGray),
//                                     prefixIcon: const Icon(Icons.calendar_today,
//                                         color: AppColors.primaryTeal),
//                                     filled: true,
//                                     fillColor:
//                                         AppColors.lightGray.withOpacity(0.2),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: const BorderSide(
//                                           color: AppColors.primaryTeal,
//                                           width: 2),
//                                     ),
//                                   ),
//                                   onTap: () => _pickDate(context, true),
//                                   style: GoogleFonts.poppins(),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: TextField(
//                                   controller: _toDateController,
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: 'To Date',
//                                     labelStyle: GoogleFonts.poppins(
//                                         color: AppColors.darkGray),
//                                     prefixIcon: const Icon(Icons.calendar_today,
//                                         color: AppColors.primaryTeal),
//                                     filled: true,
//                                     fillColor:
//                                         AppColors.lightGray.withOpacity(0.2),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: const BorderSide(
//                                           color: AppColors.primaryTeal,
//                                           width: 2),
//                                     ),
//                                   ),
//                                   onTap: () => _pickDate(context, false),
//                                   style: GoogleFonts.poppins(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 setState(() {
//                                   _fromDate = null;
//                                   _toDate = null;
//                                   _fromDateController.clear();
//                                   _toDateController.clear();
//                                   _applyFilterAndSort();
//                                 });
//                               },
//                               icon: const Icon(Icons.clear, size: 18),
//                               label: Text(
//                                 'Clear Filters',
//                                 style: GoogleFonts.poppins(),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.accentBlue,
//                                 foregroundColor: AppColors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Employee List
//                   Card(
//                     elevation: 6,
//                     color: AppColors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: _isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                                 color: AppColors.primaryTeal),
//                           )
//                         : _errorMessage != null
//                             ? Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       _errorMessage!,
//                                       style: GoogleFonts.poppins(
//                                           color: AppColors.errorRed),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     ElevatedButton.icon(
//                                       onPressed: _fetchAttendances,
//                                       icon: const Icon(Icons.refresh, size: 18),
//                                       label: Text(
//                                         'Retry',
//                                         style: GoogleFonts.poppins(),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.primaryTeal,
//                                         foregroundColor: AppColors.white,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : _employees.isEmpty
//                                 ? Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Text(
//                                         'No employees found for the selected date range.',
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 16,
//                                           color: AppColors.darkGray,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   )
//                                 : ListView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: _employees.length,
//                                     itemBuilder: (context, index) {
//                                       final employeeId =
//                                           _employees.keys.elementAt(index);
//                                       final employee = _employees[employeeId]!;
//                                       final photoPath = employee['photo_path'];

//                                       return Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 8.0, horizontal: 16.0),
//                                         child: AnimatedContainer(
//                                           duration:
//                                               const Duration(milliseconds: 300),
//                                           curve: Curves.easeInOut,
//                                           child: Card(
//                                             elevation: 4,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(16),
//                                             ),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   colors: [
//                                                     AppColors.white,
//                                                     AppColors.lightTeal
//                                                         .withOpacity(0.1),
//                                                   ],
//                                                   begin: Alignment.topLeft,
//                                                   end: Alignment.bottomRight,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(16),
//                                               ),
//                                               child: ListTile(
//                                                 leading: CircleAvatar(
//                                                   radius: 30,
//                                                   backgroundColor:
//                                                       AppColors.lightGray,
//                                                   child: ClipOval(
//                                                     child: photoPath != null &&
//                                                             _isBase64(photoPath)
//                                                         ? FutureBuilder<Image>(
//                                                             future:
//                                                                 _decodeBase64Image(
//                                                                     photoPath),
//                                                             builder: (context,
//                                                                 snapshot) {
//                                                               if (snapshot
//                                                                       .connectionState ==
//                                                                   ConnectionState
//                                                                       .waiting) {
//                                                                 return const SizedBox(
//                                                                   height: 60,
//                                                                   width: 60,
//                                                                   child: Center(
//                                                                       child:
//                                                                           CircularProgressIndicator()),
//                                                                 );
//                                                               } else if (snapshot
//                                                                       .hasError ||
//                                                                   snapshot.data ==
//                                                                       null) {
//                                                                 return const Icon(
//                                                                   Icons.person,
//                                                                   size: 40,
//                                                                   color: AppColors
//                                                                       .darkGray,
//                                                                 );
//                                                               }
//                                                               return SizedBox(
//                                                                 height: 60,
//                                                                 width: 60,
//                                                                 child: snapshot
//                                                                     .data!,
//                                                               );
//                                                             },
//                                                           )
//                                                         : Image.network(
//                                                             photoPath ?? '',
//                                                             height: 60,
//                                                             width: 60,
//                                                             fit: BoxFit.cover,
//                                                             errorBuilder: (context,
//                                                                     error,
//                                                                     stackTrace) =>
//                                                                 const Icon(
//                                                               Icons.person,
//                                                               size: 40,
//                                                               color: AppColors
//                                                                   .darkGray,
//                                                             ),
//                                                           ),
//                                                   ),
//                                                 ),
//                                                 title: Text(
//                                                   employee['name'] ?? 'N/A',
//                                                   style: GoogleFonts.poppins(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                                 subtitle: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       employee['email'] ??
//                                                           'N/A',
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         fontSize: 14,
//                                                         color:
//                                                             AppColors.darkGray,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       employee['contact'] ??
//                                                           'N/A',
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         fontSize: 14,
//                                                         color:
//                                                             AppColors.darkGray,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 onTap: () =>
//                                                     _showAttendanceDetails(
//                                                         context, employeeId),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quick_roll/services/global.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<int, Map<String, dynamic>> _employees = {};
  Map<int, List<dynamic>> _attendanceByEmployee = {};
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _sortAscending = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAttendances();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  bool _isBase64(String str) {
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Regex.hasMatch(str) && (str.length % 4 == 0);
  }

  Future<Image> _decodeBase64Image(String base64String) async {
    try {
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      throw Exception('Failed to decode image: $e');
    }
  }

  Future<void> _fetchAttendances() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse('$baseURL/attendances?company_id=$global_cid');
      debugPrint('📤 Fetching attendances for company_id: $global_cid');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> attendances = jsonResponse['data'] ?? [];

        setState(() {
          _employees.clear();
          _attendanceByEmployee.clear();

          for (var attendance in attendances) {
            final employee = attendance['employee'] ?? {};
            final employeeId = employee['id'] ?? 0;

            if (employeeId != 0) {
              _employees[employeeId] = employee;
              _attendanceByEmployee.putIfAbsent(employeeId, () => []);
              _attendanceByEmployee[employeeId]!.add(attendance);
            }
          }

          _applyFilterAndSort();
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load attendance records: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
      debugPrint('❌ Error fetching attendances: $e');
    } finally {
      setState(() => _isLoading = false);
      _refreshController.refreshCompleted();
    }
  }

  void _applyFilterAndSort() {
    setState(() {
      _employees.clear();
      final Map<int, List<dynamic>> filteredAttendance = {};

      _attendanceByEmployee.forEach((employeeId, attendances) {
        final filtered = attendances.where((attendance) {
          final attendanceDate = DateTime.parse(attendance['date']);
          bool matchesDateRange = true;

          if (_fromDate != null) {
            matchesDateRange = matchesDateRange &&
                (attendanceDate.isAtSameMomentAs(_fromDate!) ||
                    attendanceDate.isAfter(_fromDate!));
          }
          if (_toDate != null) {
            matchesDateRange = matchesDateRange &&
                (attendanceDate.isAtSameMomentAs(_toDate!) ||
                    attendanceDate
                        .isBefore(_toDate!.add(const Duration(days: 1))));
          }

          return matchesDateRange;
        }).toList();

        if (filtered.isNotEmpty) {
          filteredAttendance[employeeId] = filtered;
          _employees[employeeId] =
              _attendanceByEmployee[employeeId]!.first['employee'];
        }
      });

      _attendanceByEmployee = filteredAttendance;

      _attendanceByEmployee.forEach((employeeId, attendances) {
        attendances.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return _sortAscending
              ? dateA.compareTo(dateB)
              : dateB.compareTo(dateA);
        });
      });
    });
  }

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    final initialDate = isFromDate
        ? (_fromDate ?? DateTime.now())
        : (_toDate ?? DateTime.now());
    final firstDate = DateTime(2000);
    final lastDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: AppColors.white,
              onSurface: AppColors.darkGray,
            ),
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.primaryTeal),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          _fromDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _toDate = picked;
          _toDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
        _applyFilterAndSort();
      });
    }
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String? time) {
    if (time == null || time == '00:00') return 'N/A';
    try {
      final parsedTime = DateFormat('HH:mm').parse(time);
      return DateFormat('h:mm a').format(parsedTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatWorkingHours(String? hours) {
    if (hours == null) return '00:00';
    try {
      final decimalHours = double.parse(hours);
      final int totalMinutes = (decimalHours * 60).round();
      final int h = totalMinutes ~/ 60;
      final int m = totalMinutes % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

  String _formatMobileModel(String? model) {
    return model ?? 'N/A';
  }

  Future<void> _generateAndSavePDF(int employeeId) async {
    final employee = _employees[employeeId] ?? {};
    final attendances = _attendanceByEmployee[employeeId] ?? [];
    final employeeName = employee['name']?.replaceAll(' ', '_') ?? 'Employee';
    final employeeEmail = employee['email'] ?? 'N/A';

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Employee Attendance Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Name: $employeeName',
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                  pw.Text(
                    'Email: $employeeEmail',
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),
            pw.Table.fromTextArray(
              headers: ['Date', 'In Time', 'Out Time', 'Hours', 'Mobile Model'],
              data: attendances.map((attendance) {
                return [
                  _formatDate(attendance['date'] ?? 'N/A'),
                  _formatTime(attendance['intime']),
                  _formatTime(attendance['outtime']),
                  _formatWorkingHours(attendance['working_hours']),
                  _formatMobileModel(attendance['mobile_model']),
                ];
              }).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 12),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 1),
                ),
              ),
              cellHeight: 30,
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1),
                4: const pw.FlexColumnWidth(2),
              },
            ),
          ];
        },
      ),
    );

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$employeeName-attendance.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved to ${file.path}'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  void _showAttendanceDetails(BuildContext context, int employeeId) {
    final attendances = _attendanceByEmployee[employeeId] ?? [];
    final employee = _employees[employeeId] ?? {};

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryTeal, AppColors.accentBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          employee['name'] ?? 'Unknown',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: attendances.isEmpty
                            ? Center(
                                child: Text(
                                  'No attendance records found for this date range.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                      AppColors.lightTeal.withOpacity(0.2)),
                                  dataRowColor:
                                      WidgetStateProperty.all(AppColors.white),
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Date',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'In Time',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Out Time',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Hours',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Mobile Model',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                  rows: attendances.map((attendance) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(
                                          _formatDate(
                                              attendance['date'] ?? 'N/A'),
                                          style: GoogleFonts.poppins(),
                                        )),
                                        DataCell(Text(
                                          _formatTime(attendance['intime']),
                                          style: GoogleFonts.poppins(),
                                        )),
                                        DataCell(Text(
                                          _formatTime(attendance['outtime']),
                                          style: GoogleFonts.poppins(),
                                        )),
                                        DataCell(Text(
                                          _formatWorkingHours(
                                              attendance['working_hours']),
                                          style: GoogleFonts.poppins(),
                                        )),
                                        DataCell(Text(
                                          _formatMobileModel(
                                              attendance['mobile_model']),
                                          style: GoogleFonts.poppins(),
                                        )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryTeal,
        title: Text(
          'Employee Attendance',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _fetchAttendances,
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightGray, AppColors.lightTeal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _fetchAttendances,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Filter Section
                  Card(
                    elevation: 6,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter by Date Range',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _fromDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'From Date',
                                    labelStyle: GoogleFonts.poppins(
                                        color: AppColors.darkGray),
                                    prefixIcon: const Icon(Icons.calendar_today,
                                        color: AppColors.primaryTeal),
                                    filled: true,
                                    fillColor:
                                        AppColors.lightGray.withOpacity(0.2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: AppColors.primaryTeal,
                                          width: 2),
                                    ),
                                  ),
                                  onTap: () => _pickDate(context, true),
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _toDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'To Date',
                                    labelStyle: GoogleFonts.poppins(
                                        color: AppColors.darkGray),
                                    prefixIcon: const Icon(Icons.calendar_today,
                                        color: AppColors.primaryTeal),
                                    filled: true,
                                    fillColor:
                                        AppColors.lightGray.withOpacity(0.2),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: AppColors.primaryTeal,
                                          width: 2),
                                    ),
                                  ),
                                  onTap: () => _pickDate(context, false),
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _fromDate = null;
                                  _toDate = null;
                                  _fromDateController.clear();
                                  _toDateController.clear();
                                  _applyFilterAndSort();
                                });
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              label: Text(
                                'Clear Filters',
                                style: GoogleFonts.poppins(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentBlue,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Employee List
                  Card(
                    elevation: 6,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryTeal),
                          )
                        : _errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _errorMessage!,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.errorRed),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: _fetchAttendances,
                                      icon: const Icon(Icons.refresh, size: 18),
                                      label: Text(
                                        'Retry',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryTeal,
                                        foregroundColor: AppColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _employees.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'No employees found for the selected date range.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: AppColors.darkGray,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _employees.length,
                                    itemBuilder: (context, index) {
                                      final employeeId =
                                          _employees.keys.elementAt(index);
                                      final employee = _employees[employeeId]!;
                                      final photoPath = employee['photo_path'];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.white,
                                                    AppColors.lightTeal
                                                        .withOpacity(0.1),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      AppColors.lightGray,
                                                  child: ClipOval(
                                                    child: photoPath != null &&
                                                            _isBase64(photoPath)
                                                        ? FutureBuilder<Image>(
                                                            future:
                                                                _decodeBase64Image(
                                                                    photoPath),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const SizedBox(
                                                                  height: 60,
                                                                  width: 60,
                                                                  child: Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                                );
                                                              } else if (snapshot
                                                                      .hasError ||
                                                                  snapshot.data ==
                                                                      null) {
                                                                return const Icon(
                                                                  Icons.person,
                                                                  size: 40,
                                                                  color: AppColors
                                                                      .darkGray,
                                                                );
                                                              }
                                                              return SizedBox(
                                                                height: 60,
                                                                width: 60,
                                                                child: snapshot
                                                                    .data!,
                                                              );
                                                            },
                                                          )
                                                        : Image.network(
                                                            photoPath ?? '',
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context,
                                                                    error,
                                                                    stackTrace) =>
                                                                const Icon(
                                                              Icons.person,
                                                              size: 40,
                                                              color: AppColors
                                                                  .darkGray,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                title: Text(
                                                  employee['name'] ?? 'N/A',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      employee['email'] ??
                                                          'N/A',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.darkGray,
                                                      ),
                                                    ),
                                                    Text(
                                                      employee['contact'] ??
                                                          'N/A',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.darkGray,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.download,
                                                    color:
                                                        AppColors.primaryTeal,
                                                  ),
                                                  onPressed: () =>
                                                      _generateAndSavePDF(
                                                          employeeId),
                                                ),
                                                onTap: () =>
                                                    _showAttendanceDetails(
                                                        context, employeeId),
                                              ),
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
        ),
      ),
    );
  }
}
