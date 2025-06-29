// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:workmanager/workmanager.dart';

// import 'model/signup_form_model.dart';
// import 'model/employee_signup_model.dart';
// import 'core/splash_screen.dart';
// import 'services/background_location_task.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ Initialize WorkManager only (No permission checks here)
//   await Workmanager().initialize(
//     callbackDispatcher,
//     isInDebugMode: true,
//   );

//   await Workmanager().registerPeriodicTask(
//     "periodic-location-task-id",
//     fetchBackgroundTask,
//     frequency: const Duration(minutes: 15),
//     initialDelay: const Duration(seconds: 10),
//     constraints: Constraints(
//       networkType: NetworkType.connected,
//     ),
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => SignupFormModel()),
//         ChangeNotifierProvider(create: (_) => EmployeeSignupModel()),
//       ],
//       child: MaterialApp(
//         title: 'Quick Roll',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_roll/model/signup_form_model.dart';
import 'package:quick_roll/model/employee_signup_model.dart';
import 'package:quick_roll/core/splash_screen.dart';
import 'package:quick_roll/services/background_location_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager
  try {
    await initializeBackgroundLocationTask();
  } catch (e) {
    debugPrint('Error initializing WorkManager: $e');
  }

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
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
