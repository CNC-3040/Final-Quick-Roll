import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'model/signup_form_model.dart';
import 'model/employee_signup_model.dart';
import 'core/splash_screen.dart';
import 'services/background_location_task.dart'; // Ensure callbackDispatcher is annotated

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager with the background callback
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Set to false for production
  );

  // Register periodic background task
  await initializeBackgroundLocationTask();

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
