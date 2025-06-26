import 'dart:convert';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

/// Task name to register with WorkManager
const String fetchBackgroundTask = "fetchLocationTask";

/// Registers a one-time task (called from background isolate)
@pragma('vm:entry-point') // Needed for background isolates
Future<void> scheduleOneTimeTask(int delayMinutes) async {
  await Workmanager().registerOneOffTask(
    "unique-id-$delayMinutes",
    fetchBackgroundTask,
    initialDelay: Duration(minutes: delayMinutes),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}

/// Background dispatcher for WorkManager
@pragma('vm:entry-point') // 🔥 Mandatory for background execution!
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("📦 Executing task: $task");

    await _sendLocation();

    // Optional: Re-schedule the task manually (use only if NOT using periodic task)
    // await scheduleOneTimeTask(15); // If you prefer chaining manually

    return Future.value(true);
  });
}

/// Registers a periodic task once (called in main.dart)
Future<void> initializeBackgroundLocationTask() async {
  await Workmanager().registerPeriodicTask(
    "periodic-location-task-id", // Must be unique
    fetchBackgroundTask,
    frequency: const Duration(minutes: 15), // 🔁 Android's min interval
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresStorageNotLow: false,
    ),
  );
}

/// Gets current location and sends to server
@pragma('vm:entry-point') // Optional but safe to add here too
Future<void> _sendLocation() async {
  try {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final String clientId = DateTime.now().toIso8601String();

    final Map<String, dynamic> payload = {
      'client_id': clientId,
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    final response = await http.post(
      Uri.parse('https://qr.albsocial.in/api/update-location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print("✅ Location sent: ${position.latitude}, ${position.longitude}");
    } else {
      print("❌ Server error: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Location send error: $e");
  }
}
