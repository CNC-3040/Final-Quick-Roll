// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../services/global_API.dart';

// class AttendanceScanner extends StatefulWidget {
//   const AttendanceScanner({super.key});

//   @override
//   State<AttendanceScanner> createState() => _AttendanceScannerState();
// }

// class _AttendanceScannerState extends State<AttendanceScanner> {
//   String scannedData = 'No data scanned yet';
//   String? scannedInTime;
//   String? scannedOutTime;
//   String? scannedLocation;
//   String? loggedInUserId;
//   String? companyId;
//   String? mobileModel;
//   bool isLoading = false;
//   bool isInTimeFilled = false;
//   bool isOutTimeFilled = false;
//   String? lastScanDate;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLoggedInUserId();
//     _checkAttendanceStatus();
//     _fetchMobileModel();
//   }

//   Future<void> _fetchMobileModel() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         setState(() {
//           mobileModel = androidInfo.model;
//         });
//       } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         setState(() {
//           mobileModel = iosInfo.model;
//         });
//       } else {
//         setState(() {
//           mobileModel = 'Unknown';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         mobileModel = 'Error fetching device model';
//       });
//     }
//   }

//   Future<void> _fetchLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? contact = prefs.getString('loggedInUserContact');
//     String? storedCompanyId = prefs.getString('loggedInUserCompanyId');
//     print('Stored Company ID: $storedCompanyId'); // Debugging
//     if (contact != null) {
//       String userId = await _fetchEmployeeID(contact);
//       setState(() {
//         loggedInUserId = userId;
//         companyId = storedCompanyId;
//       });
//     } else {
//       setState(() {
//         loggedInUserId = 'No user ID found';
//         companyId = null;
//       });
//     }
//   }

//   Future<void> _checkAttendanceStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedDate = prefs.getString('lastScanDate');
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

//     if (storedDate == today) {
//       setState(() {
//         isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
//         isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;
//         scannedInTime = prefs.getString('scannedInTime');
//         scannedOutTime = prefs.getString('scannedOutTime');
//         scannedLocation = prefs.getString('scannedLocation');
//         lastScanDate = storedDate;
//       });
//     } else {
//       await prefs.setBool('isInTimeFilled', false);
//       await prefs.setBool('isOutTimeFilled', false);
//       await prefs.remove('scannedInTime');
//       await prefs.remove('scannedOutTime');
//       await prefs.remove('scannedLocation');
//       setState(() {
//         isInTimeFilled = false;
//         isOutTimeFilled = false;
//         scannedInTime = null;
//         scannedOutTime = null;
//         scannedLocation = null;
//         lastScanDate = null;
//       });
//     }
//   }

//   Future<String> _fetchEmployeeID(String contact) async {
//     try {
//       final response = await http.get(Uri.parse('$baseURL/employees'));
//       if (response.statusCode == 200) {
//         List<dynamic> employees = json.decode(response.body);
//         for (var employee in employees) {
//           if (employee['contact'] == contact ||
//               employee['alternate_contact'] == contact) {
//             return employee['id'].toString();
//           }
//         }
//         return 'Employee not found';
//       } else {
//         throw Exception('Failed to fetch employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       return 'Error fetching employee ID: $e';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Scanner'),
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: isLoading
//                 ? null
//                 : () {
//                     Share.share(
//                         'Attendance: In: $scannedInTime, Out: $scannedOutTime, Location: $scannedLocation, Device: $mobileModel');
//                   },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildStatusIndicator(
//                                 'In-Time',
//                                 isInTimeFilled,
//                                 scannedInTime,
//                               ),
//                               _buildStatusIndicator(
//                                 'Out-Time',
//                                 isOutTimeFilled,
//                                 scannedOutTime,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             scannedData,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (scannedLocation != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Location: $scannedLocation',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (mobileModel != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Device: $mobileModel',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (loggedInUserId != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'User ID: $loggedInUserId',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: (isInTimeFilled && isOutTimeFilled)
//                         ? null
//                         : _scanQRCode,
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text(
//                       'Scan Attendance',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                       textStyle: const TextStyle(fontSize: 16),
//                       backgroundColor: const Color(0xFF092676),
//                     ),
//                   ),
//                   if (isInTimeFilled && isOutTimeFilled) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Today\'s attendance already recorded!',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatusIndicator(String title, bool isFilled, String? time) {
//     return Column(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isFilled ? Colors.green : Colors.grey,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Text(
//           time ?? 'Not Recorded',
//           style: TextStyle(
//             fontSize: 14,
//             color: isFilled ? Colors.green : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _scanQRCode() async {
//     // Check if mobileModel or loggedInUserId is null or empty
//     if (mobileModel == null ||
//         mobileModel!.isEmpty ||
//         mobileModel == 'Unknown' ||
//         mobileModel == 'Error fetching device model') {
//       setState(() {
//         scannedData = 'Cannot scan: Device model not available';
//       });
//       return;
//     }

//     if (loggedInUserId == null ||
//         loggedInUserId!.isEmpty ||
//         loggedInUserId == 'No user ID found' ||
//         loggedInUserId == 'Employee not found') {
//       setState(() {
//         scannedData = 'Cannot scan: User ID not available';
//       });
//       return;
//     }

//     if (isInTimeFilled && isOutTimeFilled) {
//       setState(() {
//         scannedData = 'Today\'s attendance already recorded!';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await BarcodeScanner.scan();
//       if (result.rawContent.isEmpty) {
//         setState(() {
//           scannedData = 'No QR code found!';
//         });
//         return;
//       }

//       // Parse QR code content
//       Map<String, dynamic> qrData = json.decode(result.rawContent);
//       String? scannedCompanyId = qrData['data']?['id']?.toString();

//       print('Scanned Company ID: $scannedCompanyId'); // Debugging
//       print('Stored Company ID: $companyId'); // Debugging

//       if (scannedCompanyId == null || scannedCompanyId.isEmpty) {
//         setState(() {
//           scannedData = 'Invalid QR code format!';
//         });
//         return;
//       }

//       if (companyId == null) {
//         setState(() {
//           scannedData = 'No company ID found for logged-in user!';
//         });
//         return;
//       }

//       if (scannedCompanyId != companyId) {
//         setState(() {
//           scannedData =
//               'QR code does not match company! (Scanned: $scannedCompanyId, Expected: $companyId)';
//         });
//         return;
//       }

//       String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//       String location = await _getReadableLocation();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? contact = prefs.getString('loggedInUserContact');
//       String userId = contact != null
//           ? await _fetchEmployeeID(contact)
//           : 'No user ID found';

//       if (userId == 'No user ID found') {
//         setState(() {
//           scannedData = 'Invalid scan data!';
//         });
//         return;
//       }

//       Map<String, dynamic> requestData = {
//         "company_id": companyId,
//         "employee_id": userId,
//         "date": formattedDate,
//         "location": location,
//         "mobile_model": mobileModel,
//       };

//       String endpoint = isInTimeFilled
//           ? '$baseURL/attendance/outtime'
//           : '$baseURL/attendance/intime';
//       requestData[isInTimeFilled ? 'outtime' : 'intime'] = formattedTime;

//       print('Sending request to $endpoint: $requestData'); // Debugging

//       var response = await http.post(
//         Uri.parse(endpoint),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           scannedData = 'Attendance recorded successfully!';
//           scannedLocation = location;
//           loggedInUserId = userId;
//           lastScanDate = formattedDate;

//           if (isInTimeFilled) {
//             isOutTimeFilled = true;
//             scannedOutTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isOutTimeFilled', true);
//             prefs.setString('scannedOutTime', scannedOutTime!);
//           } else {
//             isInTimeFilled = true;
//             scannedInTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isInTimeFilled', true);
//             prefs.setString('scannedInTime', scannedInTime!);
//           }
//           prefs.setString('scannedLocation', location);
//           prefs.setString('lastScanDate', formattedDate);
//         });
//       } else {
//         setState(() {
//           scannedData = 'Failed to save attendance: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         scannedData = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<String> _getReadableLocation() async {
//     try {
//       Position position = await _determinePosition();
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String address = [
//           place.street,
//           place.locality,
//           place.administrativeArea,
//           place.country
//         ].where((element) => element != null && element.isNotEmpty).join(", ");

//         return address.isNotEmpty ? address : "Unknown location";
//       }
//       return 'Location unavailable';
//     } catch (e) {
//       return 'Error fetching location: $e';
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Enable location services.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../services/global_API.dart';

// class AttendanceScanner extends StatefulWidget {
//   const AttendanceScanner({super.key});

//   @override
//   State<AttendanceScanner> createState() => _AttendanceScannerState();
// }

// class _AttendanceScannerState extends State<AttendanceScanner> {
//   String scannedData = 'No data scanned yet';
//   String? scannedInTime;
//   String? scannedOutTime;
//   String? scannedLocation;
//   String? loggedInUserId;
//   String? companyId;
//   String? mobileModel;
//   bool isLoading = false;
//   bool isInTimeFilled = false;
//   bool isOutTimeFilled = false;
//   String? lastScanDate;
//   String selectedShift = 'Day'; // Default shift

//   @override
//   void initState() {
//     super.initState();
//     _fetchLoggedInUserId();
//     _checkAttendanceStatus();
//     _fetchMobileModel();
//   }

//   Future<void> _fetchMobileModel() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         setState(() {
//           mobileModel = androidInfo.model;
//         });
//       } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         setState(() {
//           mobileModel = iosInfo.model;
//         });
//       } else {
//         setState(() {
//           mobileModel = 'Unknown';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         mobileModel = 'Error fetching device model';
//       });
//     }
//   }

//   Future<void> _fetchLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? contact = prefs.getString('loggedInUserContact');
//     String? storedCompanyId = prefs.getString('loggedInUserCompanyId');
//     String? storedShift = prefs.getString('selectedShift') ?? 'Day';
//     print('Stored Company ID: $storedCompanyId'); // Debugging
//     if (contact != null) {
//       String userId = await _fetchEmployeeID(contact);
//       setState(() {
//         loggedInUserId = userId;
//         companyId = storedCompanyId;
//         selectedShift = storedShift;
//       });
//     } else {
//       setState(() {
//         loggedInUserId = 'No user ID found';
//         companyId = null;
//         selectedShift = 'Day';
//       });
//     }
//   }

//   Future<void> _checkAttendanceStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedDate = prefs.getString('lastScanDate');
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     DateTime now = DateTime.now();
//     bool shouldReset = false;

//     if (storedDate != null) {
//       DateTime lastScan = DateTime.parse(storedDate);
//       if (selectedShift == 'Day') {
//         // Day shift resets after 12:00 AM
//         shouldReset = now.day != lastScan.day;
//       } else {
//         // Night shift resets after 12:00 PM
//         DateTime noonToday = DateTime(now.year, now.month, now.day, 12, 0);
//         shouldReset = now.isAfter(noonToday) &&
//             (lastScan.isBefore(noonToday) || lastScan.day != now.day);
//       }
//     } else {
//       shouldReset = true;
//     }

//     if (shouldReset) {
//       await prefs.setBool('isInTimeFilled', false);
//       await prefs.setBool('isOutTimeFilled', false);
//       await prefs.remove('scannedInTime');
//       await prefs.remove('scannedOutTime');
//       await prefs.remove('scannedLocation');
//       await prefs.remove('lastScanDate');
//       setState(() {
//         isInTimeFilled = false;
//         isOutTimeFilled = false;
//         scannedInTime = null;
//         scannedOutTime = null;
//         scannedLocation = null;
//         lastScanDate = null;
//       });
//     } else {
//       setState(() {
//         isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
//         isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;
//         scannedInTime = prefs.getString('scannedInTime');
//         scannedOutTime = prefs.getString('scannedOutTime');
//         scannedLocation = prefs.getString('scannedLocation');
//         lastScanDate = storedDate;
//       });
//     }
//   }

//   Future<String> _fetchEmployeeID(String contact) async {
//     try {
//       final response = await http.get(Uri.parse('$baseURL/employees'));
//       if (response.statusCode == 200) {
//         List<dynamic> employees = json.decode(response.body);
//         for (var employee in employees) {
//           if (employee['contact'] == contact ||
//               employee['alternate_contact'] == contact) {
//             return employee['id'].toString();
//           }
//         }
//         return 'Employee not found';
//       } else {
//         throw Exception('Failed to fetch employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       return 'Error fetching employee ID: $e';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Scanner'),
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: isLoading
//                 ? null
//                 : () {
//                     Share.share(
//                         'Attendance: Shift: $selectedShift, In: $scannedInTime, Out: $scannedOutTime, Location: $scannedLocation, Device: $mobileModel');
//                   },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           DropdownButton<String>(
//                             value: selectedShift,
//                             items: ['Day', 'Night'].map((String shift) {
//                               return DropdownMenuItem<String>(
//                                 value: shift,
//                                 child: Text(shift),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) async {
//                               if (newValue != null) {
//                                 SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                 await prefs.setString(
//                                     'selectedShift', newValue);
//                                 setState(() {
//                                   selectedShift = newValue;
//                                 });
//                                 await _checkAttendanceStatus();
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildStatusIndicator(
//                                 'In-Time',
//                                 isInTimeFilled,
//                                 scannedInTime,
//                               ),
//                               _buildStatusIndicator(
//                                 'Out-Time',
//                                 isOutTimeFilled,
//                                 scannedOutTime,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             scannedData,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (scannedLocation != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Location: $scannedLocation',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (mobileModel != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Device: $mobileModel',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (loggedInUserId != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'User ID: $loggedInUserId',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           const SizedBox(height: 10),
//                           Text(
//                             'Shift: $selectedShift',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: (isInTimeFilled && isOutTimeFilled)
//                         ? null
//                         : _scanQRCode,
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text(
//                       'Scan Attendance',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                       textStyle: const TextStyle(fontSize: 16),
//                       backgroundColor: const Color(0xFF092676),
//                     ),
//                   ),
//                   if (isInTimeFilled && isOutTimeFilled) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Today\'s attendance already recorded!',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatusIndicator(String title, bool isFilled, String? time) {
//     return Column(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isFilled ? Colors.green : Colors.grey,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Text(
//           time ?? 'Not Recorded',
//           style: TextStyle(
//             fontSize: 14,
//             color: isFilled ? Colors.green : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _scanQRCode() async {
//     if (mobileModel == null ||
//         mobileModel!.isEmpty ||
//         mobileModel == 'Unknown' ||
//         mobileModel == 'Error fetching device model') {
//       setState(() {
//         scannedData = 'Cannot scan: Device model not available';
//       });
//       return;
//     }

//     if (loggedInUserId == null ||
//         loggedInUserId!.isEmpty ||
//         loggedInUserId == 'No user ID found' ||
//         loggedInUserId == 'Employee not found') {
//       setState(() {
//         scannedData = 'Cannot scan: User ID not available';
//       });
//       return;
//     }

//     if (isInTimeFilled && isOutTimeFilled) {
//       setState(() {
//         scannedData = 'Today\'s attendance already recorded!';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await BarcodeScanner.scan();
//       if (result.rawContent.isEmpty) {
//         setState(() {
//           scannedData = 'No QR code found!';
//         });
//         return;
//       }

//       Map<String, dynamic> qrData = json.decode(result.rawContent);
//       String? scannedCompanyId = qrData['data']?['id']?.toString();

//       print('Scanned Company ID: $scannedCompanyId'); // Debugging
//       print('Stored Company ID: $companyId'); // Debugging

//       if (scannedCompanyId == null || scannedCompanyId.isEmpty) {
//         setState(() {
//           scannedData = 'Invalid QR code format!';
//         });
//         return;
//       }

//       if (companyId == null) {
//         setState(() {
//           scannedData = 'No company ID found for logged-in user!';
//         });
//         return;
//       }

//       if (scannedCompanyId != companyId) {
//         setState(() {
//           scannedData =
//               'QR code does not match company! (Scanned: $scannedCompanyId, Expected: $companyId)';
//         });
//         return;
//       }

//       String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//       String location = await _getReadableLocation();
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? contact = prefs.getString('loggedInUserContact');
//       String userId = contact != null
//           ? await _fetchEmployeeID(contact)
//           : 'No user ID found';

//       if (userId == 'No user ID found') {
//         setState(() {
//           scannedData = 'Invalid scan data!';
//         });
//         return;
//       }

//       Map<String, dynamic> requestData = {
//         "company_id": companyId,
//         "employee_id": userId,
//         "date": formattedDate,
//         "location": location,
//         "mobile_model": mobileModel,
//         "shift": selectedShift,
//       };

//       String endpoint = isInTimeFilled
//           ? '$baseURL/attendance/outtime'
//           : '$baseURL/attendance/intime';
//       requestData[isInTimeFilled ? 'outtime' : 'intime'] = formattedTime;

//       print('Sending request to $endpoint: $requestData'); // Debugging

//       var response = await http.post(
//         Uri.parse(endpoint),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           scannedData = 'Attendance recorded successfully!';
//           scannedLocation = location;
//           loggedInUserId = userId;
//           lastScanDate = formattedDate;

//           if (isInTimeFilled) {
//             isOutTimeFilled = true;
//             scannedOutTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isOutTimeFilled', true);
//             prefs.setString('scannedOutTime', scannedOutTime!);
//           } else {
//             isInTimeFilled = true;
//             scannedInTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isInTimeFilled', true);
//             prefs.setString('scannedInTime', scannedInTime!);
//           }
//           prefs.setString('scannedLocation', location);
//           prefs.setString('lastScanDate', formattedDate);
//         });
//       } else {
//         setState(() {
//           scannedData = 'Failed to save attendance: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         scannedData = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<String> _getReadableLocation() async {
//     try {
//       Position position = await _determinePosition();
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String address = [
//           place.street,
//           place.locality,
//           place.administrativeArea,
//           place.country
//         ].where((element) => element != null && element.isNotEmpty).join(", ");

//         return address.isNotEmpty ? address : "Unknown location";
//       }
//       return 'Location unavailable';
//     } catch (e) {
//       return 'Error fetching location: $e';
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Enable location services.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../services/global_API.dart';

// class AttendanceScanner extends StatefulWidget {
//   const AttendanceScanner({super.key});

//   @override
//   State<AttendanceScanner> createState() => _AttendanceScannerState();
// }

// class _AttendanceScannerState extends State<AttendanceScanner> {
//   String scannedData = 'No data scanned yet';
//   String? scannedInTime;
//   String? scannedOutTime;
//   String? scannedLocation;
//   String? loggedInUserId;
//   String? companyId;
//   String? mobileModel;
//   bool isLoading = false;
//   bool isInTimeFilled = false;
//   bool isOutTimeFilled = false;
//   String? lastScanDate;
//   String selectedShift = 'Day'; // Default shift

//   @override
//   void initState() {
//     super.initState();
//     _fetchLoggedInUserId();
//     _checkAttendanceStatus();
//     _fetchMobileModel();
//   }

//   Future<void> _fetchMobileModel() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Theme.of(context).platform == TargetPlatform.android) {
//         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         setState(() {
//           mobileModel = androidInfo.model;
//         });
//       } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         setState(() {
//           mobileModel = iosInfo.model;
//         });
//       } else {
//         setState(() {
//           mobileModel = 'Unknown';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         mobileModel = 'Error fetching device model';
//       });
//     }
//   }

//   Future<void> _fetchLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedUserId = prefs.getString('loggedInUserId');
//     String? storedCompanyId = prefs.getString('loggedInUserCompanyId');
//     String? storedShift = prefs.getString('selectedShift') ?? 'Day';

//     setState(() {
//       loggedInUserId = storedUserId ?? 'No user ID found';
//       companyId = storedCompanyId;
//       selectedShift = storedShift;
//     });
//   }

//   Future<void> _checkAttendanceStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedDate = prefs.getString('lastScanDate');
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     DateTime now = DateTime.now();
//     bool shouldReset = false;

//     if (storedDate != null) {
//       DateTime lastScan = DateTime.parse(storedDate);
//       if (selectedShift == 'Day') {
//         // Day shift resets after 12:00 AM
//         shouldReset = now.day != lastScan.day;
//       } else {
//         // Night shift resets after 12:00 PM
//         DateTime noonToday = DateTime(now.year, now.month, now.day, 12, 0);
//         shouldReset = now.isAfter(noonToday) &&
//             (lastScan.isBefore(noonToday) || lastScan.day != now.day);
//       }
//     } else {
//       shouldReset = true;
//     }

//     if (shouldReset) {
//       await prefs.setBool('isInTimeFilled', false);
//       await prefs.setBool('isOutTimeFilled', false);
//       await prefs.remove('scannedInTime');
//       await prefs.remove('scannedOutTime');
//       await prefs.remove('scannedLocation');
//       await prefs.remove('lastScanDate');
//       setState(() {
//         isInTimeFilled = false;
//         isOutTimeFilled = false;
//         scannedInTime = null;
//         scannedOutTime = null;
//         scannedLocation = null;
//         lastScanDate = null;
//       });
//     } else {
//       setState(() {
//         isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
//         isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;
//         scannedInTime = prefs.getString('scannedInTime');
//         scannedOutTime = prefs.getString('scannedOutTime');
//         scannedLocation = prefs.getString('scannedLocation');
//         lastScanDate = storedDate;
//       });
//     }
//   }

//   Future<String> _fetchEmployeeID(String contact) async {
//     try {
//       final response = await http.get(Uri.parse('$baseURL/employees'));
//       if (response.statusCode == 200) {
//         List<dynamic> employees = json.decode(response.body);
//         for (var employee in employees) {
//           if (employee['contact'] == contact ||
//               employee['alternate_contact'] == contact) {
//             return employee['id'].toString();
//           }
//         }
//         return 'Employee not found';
//       } else {
//         throw Exception('Failed to fetch employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       return 'Error fetching employee ID: $e';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Scanner'),
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: isLoading
//                 ? null
//                 : () {
//                     Share.share(
//                         'Attendance: Shift: $selectedShift, In: $scannedInTime, Out: $scannedOutTime, Location: $scannedLocation, Device: $mobileModel');
//                   },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           DropdownButton<String>(
//                             value: selectedShift,
//                             items: ['Day', 'Night'].map((String shift) {
//                               return DropdownMenuItem<String>(
//                                 value: shift,
//                                 child: Text(shift),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) async {
//                               if (newValue != null) {
//                                 SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                 await prefs.setString(
//                                     'selectedShift', newValue);
//                                 setState(() {
//                                   selectedShift = newValue;
//                                 });
//                                 await _checkAttendanceStatus();
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildStatusIndicator(
//                                 'In-Time',
//                                 isInTimeFilled,
//                                 scannedInTime,
//                               ),
//                               _buildStatusIndicator(
//                                 'Out-Time',
//                                 isOutTimeFilled,
//                                 scannedOutTime,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             scannedData,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           if (scannedLocation != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Location: $scannedLocation',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (mobileModel != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'Device: $mobileModel',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           if (loggedInUserId != null) ...[
//                             const SizedBox(height: 10),
//                             Text(
//                               'User ID: $loggedInUserId',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                           const SizedBox(height: 10),
//                           Text(
//                             'Shift: $selectedShift',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: (isInTimeFilled && isOutTimeFilled)
//                         ? null
//                         : _scanQRCode,
//                     icon: const Icon(Icons.qr_code_scanner),
//                     label: const Text(
//                       'Scan Attendance',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 12),
//                       textStyle: const TextStyle(fontSize: 16),
//                       backgroundColor: const Color(0xFF092676),
//                     ),
//                   ),
//                   if (isInTimeFilled && isOutTimeFilled) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Today\'s attendance already recorded!',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatusIndicator(String title, bool isFilled, String? time) {
//     return Column(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isFilled ? Colors.green : Colors.grey,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Text(
//           time ?? 'Not Recorded',
//           style: TextStyle(
//             fontSize: 14,
//             color: isFilled ? Colors.green : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _scanQRCode() async {
//     if (mobileModel == null ||
//         mobileModel!.isEmpty ||
//         mobileModel == 'Unknown' ||
//         mobileModel == 'Error fetching device model') {
//       setState(() {
//         scannedData = 'Cannot scan: Device model not available';
//       });
//       return;
//     }

//     if (loggedInUserId == null ||
//         loggedInUserId!.isEmpty ||
//         loggedInUserId == 'No user ID found' ||
//         loggedInUserId == 'Employee not found') {
//       setState(() {
//         scannedData = 'Cannot scan: User ID not available';
//       });
//       return;
//     }

//     if (isInTimeFilled && isOutTimeFilled) {
//       setState(() {
//         scannedData = 'Today\'s attendance already recorded!';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       var result = await BarcodeScanner.scan();
//       if (result.rawContent.isEmpty) {
//         setState(() {
//           scannedData = 'No QR code found!';
//         });
//         return;
//       }

//       Map<String, dynamic> qrData = json.decode(result.rawContent);
//       String? scannedCompanyId = qrData['data']?['id']?.toString();

//       print('Scanned Company ID: $scannedCompanyId'); // Debugging
//       print('Stored Company ID: $companyId'); // Debugging

//       if (scannedCompanyId == null || scannedCompanyId.isEmpty) {
//         setState(() {
//           scannedData = 'Invalid QR code format!';
//         });
//         return;
//       }

//       if (companyId == null) {
//         setState(() {
//           scannedData = 'No company ID found for logged-in user!';
//         });
//         return;
//       }

//       if (scannedCompanyId != companyId) {
//         setState(() {
//           scannedData =
//               'QR code does not match company! (Scanned: $scannedCompanyId, Expected: $companyId)';
//         });
//         return;
//       }

//       String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//       String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
//       String location = await _getReadableLocation();
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       Map<String, dynamic> requestData = {
//         "company_id": companyId,
//         "employee_id": loggedInUserId,
//         "date": formattedDate,
//         "location": location,
//         "mobile_model": mobileModel,
//         "shift": selectedShift,
//       };

//       String endpoint = isInTimeFilled
//           ? '$baseURL/attendance/outtime'
//           : '$baseURL/attendance/intime';
//       requestData[isInTimeFilled ? 'outtime' : 'intime'] = formattedTime;

//       print('Sending request to $endpoint: $requestData'); // Debugging

//       var response = await http.post(
//         Uri.parse(endpoint),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestData),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           scannedData = 'Attendance recorded successfully!';
//           scannedLocation = location;
//           lastScanDate = formattedDate;

//           if (isInTimeFilled) {
//             isOutTimeFilled = true;
//             scannedOutTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isOutTimeFilled', true);
//             prefs.setString('scannedOutTime', scannedOutTime!);
//           } else {
//             isInTimeFilled = true;
//             scannedInTime = formattedDate + ' ' + formattedTime;
//             prefs.setBool('isInTimeFilled', true);
//             prefs.setString('scannedInTime', scannedInTime!);
//           }
//           prefs.setString('scannedLocation', location);
//           prefs.setString('lastScanDate', formattedDate);
//         });
//       } else {
//         setState(() {
//           scannedData = 'Failed to save attendance: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         scannedData = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<String> _getReadableLocation() async {
//     try {
//       Position position = await _determinePosition();
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String address = [
//           place.street,
//           place.locality,
//           place.administrativeArea,
//           place.country
//         ].where((element) => element != null && element.isNotEmpty).join(", ");

//         return address.isNotEmpty ? address : "Unknown location";
//       }
//       return 'Location unavailable';
//     } catch (e) {
//       return 'Error fetching location: $e';
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Enable location services.');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions permanently denied.');
//     }

//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
// }

import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class AttendanceScanner extends StatefulWidget {
  const AttendanceScanner({super.key});

  @override
  State<AttendanceScanner> createState() => _AttendanceScannerState();
}

class _AttendanceScannerState extends State<AttendanceScanner> {
  String scannedData = 'No data scanned yet';
  String? scannedInTime;
  String? scannedOutTime;
  String? scannedLocation;
  String? loggedInUserId;
  String? companyId;
  String? mobileModel;
  bool isLoading = false;
  bool isInTimeFilled = false;
  bool isOutTimeFilled = false;
  String? lastScanDate;
  String selectedShift = 'Day'; // Default shift

  // Secret key and signature for AES encryption (store securely in production)
  static const String _qrSignature = 'ATTENDANCE_APP_V1_2025';
  static final _key = encrypt.Key.fromUtf8(
      'your-32-byte-secret-key-here1234'); // 32 bytes for AES-256
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUserId();
    _checkAttendanceStatus();
    _fetchMobileModel();
  }

  Future<void> _fetchMobileModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          mobileModel = androidInfo.model;
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          mobileModel = iosInfo.model;
        });
      } else {
        setState(() {
          mobileModel = 'Unknown';
        });
      }
    } catch (e) {
      setState(() {
        mobileModel = 'Error fetching device model';
      });
    }
  }

  Future<void> _fetchLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('loggedInUserId');
    String? storedCompanyId = prefs.getString('loggedInUserCompanyId');
    String? storedShift = prefs.getString('selectedShift') ?? 'Day';

    setState(() {
      loggedInUserId = storedUserId ?? 'No user ID found';
      companyId = storedCompanyId;
      selectedShift = storedShift;
    });
  }

  Future<void> _checkAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString('lastScanDate');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime now = DateTime.now();
    bool shouldReset = false;

    if (storedDate != null) {
      DateTime lastScan = DateTime.parse(storedDate);
      if (selectedShift == 'Day') {
        shouldReset = now.day != lastScan.day;
      } else {
        DateTime noonToday = DateTime(now.year, now.month, now.day, 12, 0);
        shouldReset = now.isAfter(noonToday) &&
            (lastScan.isBefore(noonToday) || lastScan.day != now.day);
      }
    } else {
      shouldReset = true;
    }

    if (shouldReset) {
      await prefs.setBool('isInTimeFilled', false);
      await prefs.setBool('isOutTimeFilled', false);
      await prefs.remove('scannedInTime');
      await prefs.remove('scannedOutTime');
      await prefs.remove('scannedLocation');
      await prefs.remove('lastScanDate');
      setState(() {
        isInTimeFilled = false;
        isOutTimeFilled = false;
        scannedInTime = null;
        scannedOutTime = null;
        scannedLocation = null;
        lastScanDate = null;
      });
    } else {
      setState(() {
        isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
        isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;
        scannedInTime = prefs.getString('scannedInTime');
        scannedOutTime = prefs.getString('scannedOutTime');
        scannedLocation = prefs.getString('scannedLocation');
        lastScanDate = storedDate;
      });
    }
  }

  Future<String> _fetchEmployeeID(String contact) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/employees'));
      if (response.statusCode == 200) {
        List<dynamic> employees = json.decode(response.body);
        for (var employee in employees) {
          if (employee['contact'] == contact ||
              employee['alternate_contact'] == contact) {
            return employee['id'].toString();
          }
        }
        return 'Employee not found';
      } else {
        throw Exception('Failed to fetch employees: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error fetching employee ID: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Scanner'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: isLoading
                ? null
                : () {
                    Share.share(
                        'Attendance: Shift: $selectedShift, In: $scannedInTime, Out: $scannedOutTime, Location: $scannedLocation, Device: $mobileModel');
                  },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DropdownButton<String>(
                            value: selectedShift,
                            items: ['Day', 'Night'].map((String shift) {
                              return DropdownMenuItem<String>(
                                value: shift,
                                child: Text(shift),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (newValue != null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    'selectedShift', newValue);
                                setState(() {
                                  selectedShift = newValue;
                                });
                                await _checkAttendanceStatus();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusIndicator(
                                'In-Time',
                                isInTimeFilled,
                                scannedInTime,
                              ),
                              _buildStatusIndicator(
                                'Out-Time',
                                isOutTimeFilled,
                                scannedOutTime,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            scannedData,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (scannedLocation != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Location: $scannedLocation',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                          if (mobileModel != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Device: $mobileModel',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                          if (loggedInUserId != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'User ID: $loggedInUserId',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            'Shift: $selectedShift',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: (isInTimeFilled && isOutTimeFilled)
                        ? null
                        : _scanQRCode,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text(
                      'Scan Attendance',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: const Color(0xFF092676),
                    ),
                  ),
                  if (isInTimeFilled && isOutTimeFilled) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Today\'s attendance already recorded!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStatusIndicator(String title, bool isFilled, String? time) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? Colors.green : Colors.grey,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          time ?? 'Not Recorded',
          style: TextStyle(
            fontSize: 14,
            color: isFilled ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _scanQRCode() async {
    if (mobileModel == null ||
        mobileModel!.isEmpty ||
        mobileModel == 'Unknown' ||
        mobileModel == 'Error fetching device model') {
      setState(() {
        scannedData = 'Cannot scan: Device model not available';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cannot scan: Device model not available')),
      );
      return;
    }

    if (loggedInUserId == null ||
        loggedInUserId!.isEmpty ||
        loggedInUserId == 'No user ID found' ||
        loggedInUserId == 'Employee not found') {
      setState(() {
        scannedData = 'Cannot scan: User ID not available';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot scan: User ID not available')),
      );
      return;
    }

    if (isInTimeFilled && isOutTimeFilled) {
      setState(() {
        scannedData = 'Today\'s attendance already recorded!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Today\'s attendance already recorded!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isEmpty) {
        setState(() {
          scannedData = 'No QR code found!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No QR code found!')),
        );
        return;
      }

      // Split QR code data to extract IV and encrypted content
      List<String> qrParts = result.rawContent.split(':');
      if (qrParts.length != 2) {
        setState(() {
          scannedData = 'Invalid Scanner: Malformed QR code format!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid Scanner: Malformed QR code format!')),
        );
        return;
      }

      // Decode IV and encrypted data
      encrypt.IV iv;
      String encryptedData;
      try {
        iv = encrypt.IV.fromBase64(qrParts[0]);
        encryptedData = qrParts[1];
      } catch (e) {
        setState(() {
          scannedData = 'Invalid Scanner: Invalid IV or data format!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid Scanner: Invalid IV or data format!')),
        );
        return;
      }

      // Attempt to decrypt QR code data
      String decryptedData;
      try {
        decryptedData = _encrypter.decrypt64(encryptedData, iv: iv);
      } catch (e) {
        setState(() {
          scannedData = 'Invalid Scanner: Unable to decrypt QR code!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid Scanner: Unable to decrypt QR code!')),
        );
        return;
      }

      // Check for signature
      if (!decryptedData.startsWith(_qrSignature)) {
        setState(() {
          scannedData = 'Invalid Scanner: QR code not generated by this app!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Invalid Scanner: QR code not generated by this app!')),
        );
        return;
      }

      // Extract JSON data
      String jsonData = decryptedData.substring(_qrSignature.length);
      Map<String, dynamic> qrData;
      try {
        qrData = json.decode(jsonData);
      } catch (e) {
        setState(() {
          scannedData = 'Invalid Scanner: Malformed QR code data!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid Scanner: Malformed QR code data!')),
        );
        return;
      }

      String? scannedCompanyId = qrData['data']?['id']?.toString();

      if (scannedCompanyId == null || scannedCompanyId.isEmpty) {
        setState(() {
          scannedData = 'Invalid QR code: Missing company ID!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR code: Missing company ID!')),
        );
        return;
      }

      if (companyId == null) {
        setState(() {
          scannedData = 'No company ID found for logged-in user!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No company ID found for logged-in user!')),
        );
        return;
      }

      if (scannedCompanyId != companyId) {
        setState(() {
          scannedData =
              'QR code does not match company! (Scanned: $scannedCompanyId, Expected: $companyId)';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'QR code does not match company! (Scanned: $scannedCompanyId, Expected: $companyId)')),
        );
        return;
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
      String location = await _getReadableLocation();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> requestData = {
        "company_id": companyId,
        "employee_id": loggedInUserId,
        "date": formattedDate,
        "location": location,
        "mobile_model": mobileModel,
        "shift": selectedShift,
      };

      String endpoint = isInTimeFilled
          ? '$baseURL/attendance/outtime'
          : '$baseURL/attendance/intime';
      requestData[isInTimeFilled ? 'outtime' : 'intime'] = formattedTime;

      var response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        setState(() {
          scannedData = 'Attendance recorded successfully!';
          scannedLocation = location;
          lastScanDate = formattedDate;

          if (isInTimeFilled) {
            isOutTimeFilled = true;
            scannedOutTime = formattedDate + ' ' + formattedTime;
            prefs.setBool('isOutTimeFilled', true);
            prefs.setString('scannedOutTime', scannedOutTime!);
          } else {
            isInTimeFilled = true;
            scannedInTime = formattedDate + ' ' + formattedTime;
            prefs.setBool('isInTimeFilled', true);
            prefs.setString('scannedInTime', scannedInTime!);
          }
          prefs.setString('scannedLocation', location);
          prefs.setString('lastScanDate', formattedDate);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance recorded successfully!')),
        );
      } else {
        setState(() {
          scannedData = 'Failed to save attendance: ${response.body}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save attendance: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        scannedData = 'Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getReadableLocation() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = [
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((element) => element != null && element.isNotEmpty).join(", ");

        return address.isNotEmpty ? address : "Unknown location";
      }
      return 'Location unavailable';
    } catch (e) {
      return 'Error fetching location: $e';
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Enable location services.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
