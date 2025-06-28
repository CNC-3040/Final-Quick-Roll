import 'dart:convert';
import 'dart:ui';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:quick_roll/services/global.dart';

const String fetchBackgroundTask = "fetchLocationTask";

/// Background dispatcher for WorkManager
@pragma('vm:entry-point') // 🔥 Required for background execution
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("📦 Executing task: $task");

    // Ensure location services are enabled and permission is handled in _sendLocation or earlier
    bool moved =
        await hasMovedMoreThan500Meters(globalLatitude, globalLongitude);

    if (moved) {
      print("📍 Moved ≥ 500 meters. Sending location...");
      await _sendLocation();
    } else {
      print("📍 Movement < 500 meters. Skipping send.");
    }

    return Future.value(true); // ✅ Required for background tasks
  });
}

/// Registers a periodic task once (called in main.
Future<void> initializeBackgroundLocationTask() async {
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false for production
  );

  await Workmanager().registerPeriodicTask(
    "periodic-location-task-id", // Must be unique
    fetchBackgroundTask,
    frequency: const Duration(minutes: 15), // ⏱ Minimum for Android
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

@pragma('vm:entry-point') // Needed for background isolates
Future<void> _sendLocation() async {
  try {
    // 1. Get current GPS position
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print(
        "📍 Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    // 2. Load stored values
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

    // 3. Reverse geocode the address
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

    print('📦 User ID: $userId');
    print('🏢 Company ID: $companyId');
    print('📫 Address: $address');
    final now = DateTime.now(); // This gives you local time
    final trimmed = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );

    // 4. Create and send the payload
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
// Convert to JSON string

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

Future<bool> hasMovedMoreThan500Meters(
    double initialLat, double initialLng) async {
  // Ensure location permissions are granted
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

  // Get current position
  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Calculate distance
  double distanceInMeters = Geolocator.distanceBetween(
    initialLat,
    initialLng,
    currentPosition.latitude,
    currentPosition.longitude,
  );

  // Return true if moved more than or equal to 500 meters
  return distanceInMeters >= 500;
}
