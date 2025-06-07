import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:geolocator/geolocator.dart'; // For fetching location
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'package:shared_preferences/shared_preferences.dart'; // For fetching logged-in user ID
import 'package:share_plus/share_plus.dart'; // Add this import
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/global_API.dart';

class OuttimeScanner extends StatefulWidget {
  const OuttimeScanner({super.key});

  @override
  State<OuttimeScanner> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<OuttimeScanner> {
  String scannedData = 'No data scanned yet';
  String? scannedDateTime;
  String? scannedLocation;
  String? loggedInUserId;
  String? companyId; // Add this line to store company_id
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUserId();
  }

  Future<void> _fetchLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contact = prefs.getString('loggedInUserContact');
    if (contact != null) {
      String userId = await _fetchEmployeeID(contact);
      setState(() {
        loggedInUserId = userId;
        companyId =
            prefs.getString('loggedInUserCompanyId'); // Fetch company_id
      });
    } else {
      setState(() {
        loggedInUserId = 'No user ID found';
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
            return employee['id'].toString(); // Convert ID to String
          }
        }
        return 'Employee not found';
      } else {
        throw Exception(
            'Failed to fetch employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching employee ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (!isLoading) {
                Share.share(scannedData);
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _scanQRCode,
                    child: const Text('Scan QR Code'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    scannedData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (scannedDateTime != null) ...[
                    const SizedBox(height: 10),
                    Text('Scanned Date & Time: $scannedDateTime'),
                  ],
                  if (scannedLocation != null) ...[
                    const SizedBox(height: 10),
                    Text('Scanned Location: $scannedLocation'),
                  ],
                  if (loggedInUserId != null) ...[
                    const SizedBox(height: 10),
                    Text('Logged-in User ID: $loggedInUserId'),
                  ],
                ],
              ),
            ),
    );
  }

  /// Function to scan the QR code.
  Future<void> _scanQRCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isEmpty) {
        setState(() {
          scannedData = 'No QR code found!';
        });
        return;
      }

      // Parse QR code content to extract company_id
      Map<String, dynamic> qrData = json.decode(result.rawContent);
      String? scannedCompanyId = qrData['id'].toString(); // Extract only the ID

      if (scannedCompanyId == null || scannedCompanyId.isEmpty) {
        setState(() {
          scannedData = 'Invalid QR code!';
        });
        return;
      }

      // Fetch current date & time
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String formattedTime =
          DateFormat('hh:mm a').format(DateTime.now()); // Fix time format

      // Fetch location
      String location = await _getReadableLocation();

      // Fetch logged-in user ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? contact = prefs.getString('loggedInUserContact');
      String userId = contact != null
          ? await _fetchEmployeeID(contact)
          : 'No user ID found';

      if (userId == 'No user ID found') {
        setState(() {
          scannedData = 'Invalid scan data!';
        });
        return;
      }

      // Prepare API request
      Map<String, dynamic> requestData = {
        "company_id": companyId,
        "employee_id": userId,
        "date": formattedDate,
        "outtime": formattedTime,
        "location": location
      };

      var response = await http.post(
        Uri.parse('$baseURL/attendance/outtime'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        setState(() {
          scannedData = 'Attendance recorded successfully!';
          scannedDateTime = formattedDate + ' ' + formattedTime;
          scannedLocation = location;
          loggedInUserId = userId;
        });
      } else {
        setState(() {
          scannedData = 'Failed to save attendance: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        scannedData = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Function to fetch a human-readable location.
  Future<String> _getReadableLocation() async {
    try {
      Position position = await _determinePosition();
      print(
          "Position fetched: Lat(${position.latitude}), Lon(${position.longitude})");

      // Convert coordinates into readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Construct a full, detailed address
        String address = [
          place.street, // Street name
          place.locality, // City or locality
          place.administrativeArea, // State or region
          place.country // Country
        ].where((element) => element != null && element.isNotEmpty).join(", ");

        print("Readable Location: $address");
        return address.isNotEmpty
            ? address
            : "Unable to fetch location details.";
      }

      return 'Location details unavailable';
    } catch (e) {
      print("Error fetching location: $e");
      return 'Unable to fetch location: $e';
    }
  }

  /// Function to determine and request location permissions.
  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print("Location Permission: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Enable them in settings.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(
          "Current Position: Lat(${position.latitude}), Lon(${position.longitude})");
      return position;
    } catch (e) {
      print("Error determining position: $e");
      rethrow;
    }
  }
}
