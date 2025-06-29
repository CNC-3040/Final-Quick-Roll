import 'dart:convert';
import 'dart:ui';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:quick_roll/services/global.dart';

const String fetchBackgroundTask = "fetchLocationTask";
const String postHardcodedLocationTask =
    "postHardcodedLocationTask"; // ✅ NEW task for hardcoded post

/// Background dispatcher for WorkManager
@pragma('vm:entry-point') // 🔥 Required for background execution
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("📦 Executing task: $task");

    // 🔁 Load previous location from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double prevLat = prefs.getDouble('lastLatitude') ?? 0.0;
    double prevLng = prefs.getDouble('lastLongitude') ?? 0.0;

    if (task == fetchBackgroundTask) {
      bool moved = await hasMovedMoreThan500Meters();

      if (moved) {
        print("📍 Moved ≥ 500 meters. Sending location...");
        await _sendLocation(); // will update saved lat/lng
      } else {
        print("📍 Movement < 500 meters. Skipping send.");
      }
    }

    // ✅ NEW: Hardcoded location posting every 1 min
    if (task == postHardcodedLocationTask) {
      await _sendHardcodedLocation();
    }

    return Future.value(true); // ✅ Required for background tasks
  });
}

/// Registers periodic tasks (called in main)
Future<void> initializeBackgroundLocationTask() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager().registerPeriodicTask(
    "periodic-location-task-id",
    fetchBackgroundTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  // ✅ Register hardcoded location poster task every 1 minute
  await Workmanager().registerPeriodicTask(
    "post-hardcoded-location-id",
    postHardcodedLocationTask,
    frequency: const Duration(minutes: 1), // ⏱ every 1 minute
    initialDelay: const Duration(seconds: 5),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

@pragma('vm:entry-point') // Needed for background isolates
Future<void> _sendLocation() async {
  try {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(
        "📍 Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('loggedInUserId');
    String? storedCompanyId = prefs.getString('loggedInUserCompanyId');

    int? userId = int.tryParse(storedUserId ?? '');
    int? companyId = int.tryParse(storedCompanyId ?? '');

    if (userId == null || companyId == null) {
      print(
          "❗ Invalid or missing IDs — userId=$storedUserId, companyId=$storedCompanyId");
      return;
    }

    // 🔁 Save current lat/lng in SharedPreferences
    await prefs.setDouble('lastLatitude', position.latitude);
    await prefs.setDouble('lastLongitude', position.longitude);
    print("💾 Saved new lat/lng to SharedPreferences.");

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    String address = [
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.postalCode,
      place.country
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    final now = DateTime.now();
    final trimmed = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    final Map<String, dynamic> payload = {
      "company_id": companyId,
      "employee_id": userId,
      "location_address": address,
      "latitude": position.latitude.toDouble(),
      "longitude": position.longitude.toDouble(),
      "timestamp": trimmed
          .toIso8601String()
          .replaceFirst('T', ' ')
          .replaceFirst('Z', ''),
    };

    print("📤 JSON Payload: ${jsonEncode(payload)}");

    final response = await http.post(
      Uri.parse('https://qr.albsocial.in/api/postlocation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    print("📬 Server response: ${response.statusCode}, Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ Location sent: ${position.latitude}, ${position.longitude}");
    } else {
      print("❌ Server error: ${response.statusCode}");
    }

    print("📍 Final log: Lat=${position.latitude}, Lon=${position.longitude}");
  } catch (e) {
    print("❌ Location send error (likely permission or GPS off): $e");
  }
}

/// ✅ NEW: Hardcoded location poster every 1 min
@pragma('vm:entry-point')
Future<void> _sendHardcodedLocation() async {
  try {
    final Map<String, dynamic> payload = {
      "company_id": 15,
      "employee_id": 6,
      "location_address": "Test Location near Shivaji University",
      "latitude": 16.7049,
      "longitude": 74.2433,
      "timestamp": DateTime.now()
          .toIso8601String()
          .replaceFirst('T', ' ')
          .replaceFirst('Z', ''),
    };

    print("🚀 Posting hardcoded location: ${jsonEncode(payload)}");

    final response = await http.post(
      Uri.parse('https://qr.albsocial.in/api/postlocation'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    print(
        "📬 Hardcoded response: ${response.statusCode}, Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ Hardcoded location sent successfully.");
    } else {
      print("❌ Hardcoded location post failed.");
    }
  } catch (e) {
    print("❌ Hardcoded post error: $e");
  }
}

/// Movement detection function
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
