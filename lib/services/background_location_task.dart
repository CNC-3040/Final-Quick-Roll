// import 'dart:convert';
// import 'dart:ui';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:quick_roll/services/global.dart';

// const String fetchBackgroundTask = "fetchLocationTask";

// /// Background dispatcher for WorkManager
// @pragma('vm:entry-point') // 🔥 Required for background execution
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("📦 Executing task: $task");

//     // Ensure location services are enabled and permission is handled in _sendLocation or earlier
//     bool moved =
//         await hasMovedMoreThan500Meters(globalLatitude, globalLongitude);

//     if (moved) {
//       print("📍 Moved ≥ 500 meters. Sending location...");
//       await _sendLocation();
//     } else {
//       print("📍 Movement < 500 meters. Skipping send.");
//     }

//     return Future.value(true); // ✅ Required for background tasks
//   });
// }

// /// Registers a periodic task once (called in main.
// Future<void> initializeBackgroundLocationTask() async {
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true, // Set to false for production
//   );

//   await Workmanager().registerPeriodicTask(
//     "periodic-location-task-id", // Must be unique
//     fetchBackgroundTask,
//     frequency: const Duration(minutes: 15), // ⏱ Minimum for Android
//     initialDelay: const Duration(seconds: 10),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//   );
// }

// @pragma('vm:entry-point') // Needed for background isolates
// Future<void> _sendLocation() async {
//   try {
//     // 1. Get current GPS position
//     final Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     print(
//         "📍 Latitude: ${position.latitude}, Longitude: ${position.longitude}");

//     // 2. Load stored values
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedUserId = prefs.getString('loggedInUserId');
//     String? storedCompanyId = prefs.getString('loggedInUserCompanyId');

//     int? userId = int.tryParse(storedUserId ?? '');
//     int? companyId = int.tryParse(storedCompanyId ?? '');

//     if (userId == null || companyId == null) {
//       print(
//           "❗ Invalid or missing IDs — userId=$storedUserId, companyId=$storedCompanyId");
//       return;
//     }

//     // 3. Reverse geocode the address
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude,
//       position.longitude,
//     );

//     Placemark place = placemarks[0];
//     String address = [
//       place.street,
//       place.subLocality,
//       place.locality,
//       place.subAdministrativeArea,
//       place.administrativeArea,
//       place.postalCode,
//       place.country
//     ].where((e) => e != null && e.isNotEmpty).join(', ');

//     print('📦 User ID: $userId');
//     print('🏢 Company ID: $companyId');
//     print('📫 Address: $address');
//     final now = DateTime.now(); // This gives you local time
//     final trimmed = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       now.hour,
//       now.minute,
//       now.second,
//     );

//     // 4. Create and send the payload
//     final Map<String, dynamic> payload = {
//       "company_id": companyId,
//       "employee_id": userId,
//       "location_address": address,
//       "latitude": position.latitude.toDouble(),
//       "longitude": position.longitude.toDouble(),
//       "timestamp": trimmed
//           .toIso8601String()
//           .replaceFirst('T', ' ')
//           .replaceFirst('Z', ''),
//     };

//     print("📤 JSON Payload: ${jsonEncode(payload)}");
// // Convert to JSON string

//     final response = await http.post(
//       Uri.parse('https://qr.albsocial.in/api/postlocation'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(payload),
//     );

//     print("📬 Server response: ${response.statusCode}, Body: ${response.body}");

//     if (response.statusCode == 200) {
//       print("✅ Location sent: ${position.latitude}, ${position.longitude}");
//     } else {
//       print("❌ Server error: ${response.statusCode}");
//     }

//     print("📍 Final log: Lat=${position.latitude}, Lon=${position.longitude}");
//   } catch (e) {
//     print("❌ Location send error (likely permission or GPS off): $e");
//   }
// }

// Future<bool> hasMovedMoreThan500Meters(
//     double initialLat, double initialLng) async {
//   // Ensure location permissions are granted
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       throw Exception('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     throw Exception('Location permissions are permanently denied');
//   }

//   // Get current position
//   Position currentPosition = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );

//   // Calculate distance
//   double distanceInMeters = Geolocator.distanceBetween(
//     initialLat,
//     initialLng,
//     currentPosition.latitude,
//     currentPosition.longitude,
//   );

//   // Return true if moved more than or equal to 500 meters
//   return distanceInMeters >= 500;
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:quick_roll/services/global.dart';

const String fetchBackgroundTask = 'fetchLocationTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Executing task: $task');

    try {
      final moved =
          await hasMovedMoreThan500Meters(globalLatitude, globalLongitude);
      if (moved) {
        debugPrint('Moved ≥ 500 meters. Sending location...');
        await _sendLocation();
      } else {
        debugPrint('Movement < 500 meters. Skipping send.');
      }
    } catch (e) {
      debugPrint('Error in background task: $e');
    }

    return Future.value(true);
  });
}

Future<void> initializeBackgroundLocationTask() async {
  try {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Set to false for production
    );

    await Workmanager().registerPeriodicTask(
      'periodic-location-task-id',
      fetchBackgroundTask,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    debugPrint('WorkManager initialized successfully');
  } catch (e) {
    debugPrint('Error initializing WorkManager: $e');
  }
}

@pragma('vm:entry-point')
Future<void> _sendLocation() async {
  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint(
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}');

    // Save to SharedPreferences
    await saveGlobalLocation(position.latitude, position.longitude);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loggedInUserId');
    final companyId = prefs.getString('loggedInUserCompanyId');

    if (userId == null || companyId == null) {
      debugPrint(
          'Invalid or missing IDs: userId=$userId, companyId=$companyId');
      return;
    }

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address = 'Unknown location';
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      address = [
        place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    }

    final now = DateTime.now();
    final trimmed = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    final payload = {
      'company_id': companyId,
      'employee_id': userId,
      'location_address': address,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': trimmed
          .toIso8601String()
          .replaceFirst('T', ' ')
          .replaceFirst('Z', ''),
    };

    final response = await http.post(
      Uri.parse('https://qr.albsocial.in/api/postlocation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    debugPrint(
        'Server response: ${response.statusCode}, Body: ${response.body}');

    if (response.statusCode == 200) {
      debugPrint('Location sent: ${position.latitude}, ${position.longitude}');
    } else {
      debugPrint('Server error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Location send error: $e');
  }
}

Future<bool> hasMovedMoreThan500Meters(
    double initialLat, double initialLng) async {
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final distanceInMeters = Geolocator.distanceBetween(
      initialLat,
      initialLng,
      currentPosition.latitude,
      currentPosition.longitude,
    );

    return distanceInMeters >= 500;
  } catch (e) {
    debugPrint('Error checking movement: $e');
    return false;
  }
}
