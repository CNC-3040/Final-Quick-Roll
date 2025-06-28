import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'model/signup_form_model.dart';
import 'model/employee_signup_model.dart';
import 'core/splash_screen.dart';
import 'services/background_location_task.dart'; // Ensure callbackDispatcher is annotated

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Check and request location permission
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.whileInUse) {
    // Open settings if permission is permanently denied or not suitable
    await Geolocator.openAppSettings();
    return;
  }

  // ✅ Initialize WorkManager with periodic task
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false in production
  );

  // ✅ Register periodic background task (every 15 minutes)
  await Workmanager().registerPeriodicTask(
    "periodic-location-task-id", // Must be unique
    fetchBackgroundTask,
    frequency: const Duration(minutes: 15), // Min allowed by Android
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupFormModel()),
        ChangeNotifierProvider(create: (_) => EmployeeSignupModel()),
      ],
      child: MaterialApp(
        title: 'Quick Roll',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
