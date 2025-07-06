// import 'dart:convert';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

// const String fetchBackgroundTask = "fetchLocationTask";

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     print("📦 Executing task: $task");

//     if (task == fetchBackgroundTask) {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();

//         // Check if user has scanned in-time (we should be tracking)
//         bool isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
//         bool isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;

//         // Only run if user has scanned in-time but hasn't scanned out-time
//         if (isInTimeFilled && !isOutTimeFilled) {
//           bool moved = await hasMovedMoreThan500Meters();
//           if (moved) {
//             print("📍 Moved ≥ 500 meters. Sending location...");
//             await _sendLocation();
//           } else {
//             print("📍 Movement < 500 meters. Skipping send.");
//           }
//         } else {
//           print(
//               "🚫 Not tracking - inTime: $isInTimeFilled, outTime: $isOutTimeFilled");
//         }
//       } catch (e) {
//         print("❌ Error in background task: $e");
//       }
//     }

//     return Future.value(true);
//   });
// }

// @pragma('vm:entry-point')
// Future<void> initializeBackgroundLocationTask() async {
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true,
//   );

//   await Workmanager().registerPeriodicTask(
//     "periodic-location-task-id",
//     fetchBackgroundTask,
//     frequency: const Duration(minutes: 15),
//     initialDelay: const Duration(seconds: 1),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//   );
// }

// Future<void> _sendLocation() async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     // Only read in-time location, do NOT overwrite!
//     double? intimeLat = prefs.getDouble('lastLatitude');
//     double? intimeLon = prefs.getDouble('lastLongitude');
//     if (intimeLat == null || intimeLon == null) {
//       print("❌ No in-time location found. Skipping background post.");
//       return;
//     }

//     // Get current position
//     Position currentPosition = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     double actualLat = currentPosition.latitude;
//     double actualLon = currentPosition.longitude;

//     // Get address from current position
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(actualLat, actualLon);
//     Placemark place = placemarks.first;

//     String address = [
//       place.street,
//       place.subLocality,
//       place.locality,
//       place.subAdministrativeArea,
//       place.administrativeArea,
//       place.postalCode,
//       place.country
//     ].where((e) => e != null && e.isNotEmpty).join(', ');

//     String? storedUserId = prefs.getString('loggedInUserId');
//     String? storedCompanyId = prefs.getString('loggedInUserCompanyId');

//     int? userId = int.tryParse(storedUserId ?? '');
//     int? companyId = int.tryParse(storedCompanyId ?? '');

//     if (userId == null || companyId == null) {
//       print(
//           "❗ Invalid or missing IDs — userId=$storedUserId, companyId=$storedCompanyId");
//       return;
//     }

//     final now = DateTime.now();
//     final trimmed = DateTime(
//         now.year, now.month, now.day, now.hour, now.minute, now.second);

//     final Map<String, dynamic> payload = {
//       "company_id": companyId,
//       "employee_id": userId,
//       "location_address": address,
//       "latitude": actualLat,
//       "longitude": actualLon,
//       "timestamp": trimmed
//           .toIso8601String()
//           .replaceFirst('T', ' ')
//           .replaceFirst('Z', ''),
//     };

//     print("📤 JSON Payload: ${jsonEncode(payload)}");

//     final response = await http.post(
//       Uri.parse('https://qr.albsocial.in/api/postlocation'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(payload),
//     );

//     print("📬 Server response: ${response.statusCode}, Body: ${response.body}");

//     if (response.statusCode == 200) {
//       print("✅ Location sent successfully");
//     } else {
//       print("❌ Server error: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("❌ Error sending location: $e");
//   }
// }

// Future<bool> hasMovedMoreThan500Meters() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   double? initialLat = prefs.getDouble('lastLatitude');
//   double? initialLng = prefs.getDouble('lastLongitude');

//   if (initialLat == null || initialLng == null) {
//     print("❗ No previous location saved in SharedPreferences.");
//     return false;
//   }

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

//   Position currentPosition = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );

//   double distanceInMeters = Geolocator.distanceBetween(
//     initialLat,
//     initialLng,
//     currentPosition.latitude,
//     currentPosition.longitude,
//   );

//   print("📏 Distance moved: ${distanceInMeters.toStringAsFixed(2)} meters");

//   return distanceInMeters >= 500;
// }

import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const String fetchBackgroundTask = "fetchLocationTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("📦 Executing task: $task");

    if (task == fetchBackgroundTask) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Check if user has scanned in-time (we should be tracking)
        bool isInTimeFilled = prefs.getBool('isInTimeFilled') ?? false;
        bool isOutTimeFilled = prefs.getBool('isOutTimeFilled') ?? false;

        // Only run if user has scanned in-time but hasn't scanned out-time
        if (isInTimeFilled && !isOutTimeFilled) {
          bool moved = await hasMovedMoreThan500Meters();
          if (moved) {
            print("📍 Moved ≥ 500 meters. Sending location...");
            await _sendLocation();
          } else {
            print("📍 Movement < 500 meters. Skipping send.");
          }
        } else {
          print(
              "🚫 Not tracking - inTime: $isInTimeFilled, outTime: $isOutTimeFilled");
        }
      } catch (e) {
        print("❌ Error in background task: $e");
      }
    }

    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future<void> initializeBackgroundLocationTask() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Retrieve the workplace from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? workPlace = prefs.getString('loggedInUserWorkPlace');

  // Set frequency based on workplace
  Duration frequency;
  if (workPlace == 'Field Sales') {
    frequency = const Duration(hours: 1); // Check every hour for Field Sales
  } else {
    frequency = const Duration(minutes: 15); // Default to 15 minutes for others
  }

  await Workmanager().registerPeriodicTask(
    "periodic-location-task-id",
    fetchBackgroundTask,
    frequency: frequency,
    initialDelay: const Duration(seconds: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

Future<void> _sendLocation() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Only read in-time location, do NOT overwrite!
    double? intimeLat = prefs.getDouble('lastLatitude');
    double? intimeLon = prefs.getDouble('lastLongitude');
    if (intimeLat == null || intimeLon == null) {
      print("❌ No in-time location found. Skipping background post.");
      return;
    }

    // Get current position
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double actualLat = currentPosition.latitude;
    double actualLon = currentPosition.longitude;

    // Get address from current position
    List<Placemark> placemarks =
        await placemarkFromCoordinates(actualLat, actualLon);
    Placemark place = placemarks.first;

    String address = [
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.postalCode,
      place.country
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    String? storedUserId = prefs.getString('loggedInUserId');
    String? storedCompanyId = prefs.getString('loggedInUserCompanyId');
    String? workPlace = prefs.getString('loggedInUserWorkPlace');
    String? deviceName = prefs.getString('mobileModel');

    int? userId = int.tryParse(storedUserId ?? '');
    int? companyId = int.tryParse(storedCompanyId ?? '');

    if (userId == null || companyId == null) {
      print(
          "❗ Invalid or missing IDs — userId=$storedUserId, companyId=$storedCompanyId");
      return;
    }

    if (deviceName == null) {
      print("❗ Device name not found in SharedPreferences.");
      return;
    }

    final now = DateTime.now();
    final trimmed = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    final Map<String, dynamic> payload = {
      "company_id": companyId,
      "employee_id": userId,
      "location_address": address,
      "latitude": actualLat.toString(),
      "longitude": actualLon.toString(),
      "timestamp": trimmed
          .toIso8601String()
          .replaceFirst('T', ' ')
          .replaceFirst('Z', ''),
      "device_name": deviceName,
    };

    print("📤 JSON Payload: ${jsonEncode(payload)}");

    // Determine the API endpoint based on workplace
    String apiEndpoint = workPlace == 'Field Sales'
        ? 'https://qr.albsocial.in/api/sales-location'
        : 'https://qr.albsocial.in/api/postlocation';

    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print("📬 Server response: ${response.statusCode}, Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ Location sent successfully to $apiEndpoint");
    } else {
      print("❌ Server error: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error sending location: $e");
  }
}

Future<bool> hasMovedMoreThan500Meters() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double? initialLat = prefs.getDouble('lastLatitude');
  double? initialLng = prefs.getDouble('lastLongitude');

  if (initialLat == null || initialLng == null) {
    print("❗ No previous location saved in SharedPreferences.");
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied');
  }

  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  double distanceInMeters = Geolocator.distanceBetween(
    initialLat,
    initialLng,
    currentPosition.latitude,
    currentPosition.longitude,
  );

  print("📏 Distance moved: ${distanceInMeters.toStringAsFixed(2)} meters");

  return distanceInMeters >= 500;
}
