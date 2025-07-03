// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:quick_roll/admin/home_screen.dart';
// import 'package:quick_roll/core/role_selection_screen.dart';
// import 'package:quick_roll/user/user_home_screen.dart';
// import 'package:quick_roll/utils/user_colors.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }

//   Future<void> _navigateToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 2)); // Splash delay

//     // 🛑 Step 1: Request permissions and save location
//     await _requestPermissions();

//     // 🛑 Step 2: Load login & role info
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     final role = prefs.getString('role');

//     if (isLoggedIn && role != null) {
//       switch (role) {
//         case 'Admin':
//           Navigator.pushReplacement(
//             context,
//             NoAnimationPageRoute(builder: (context) => const HomeScreen()),
//           );
//           break;
//         case 'User':
//         case 'Employee':
//           Navigator.pushReplacement(
//             context,
//             NoAnimationPageRoute(builder: (context) => const UserHomeScreen()),
//           );
//           break;
//         default:
//           _navigateToRoleSelection();
//       }
//     } else {
//       _navigateToRoleSelection();
//     }
//   }

//   Future<void> _requestPermissions() async {
//     // 📍 Location permission
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openAppSettings();
//       return;
//     }

//     // 🔋 Android-specific permissions
//     if (Platform.isAndroid) {
//       if (await Permission.locationAlways.isDenied) {
//         await Permission.locationAlways.request();
//       }

//       if (await Permission.ignoreBatteryOptimizations.isDenied) {
//         await Permission.ignoreBatteryOptimizations.request();
//       }
//     }

//     // ✅ If permission granted, fetch and save location
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       try {
//         final Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );

//         // 🧠 Save latitude and longitude using SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setDouble('lastLatitude', position.latitude);
//         await prefs.setDouble('lastLongitude', position.longitude);
//         print("📍 Saved Lat=${position.latitude}, Lon=${position.longitude}");
//       } catch (e) {
//         print("❌ Failed to get location: $e");
//       }
//     }
//   }

//   void _navigateToRoleSelection() {
//     Navigator.pushReplacement(
//       context,
//       NoAnimationPageRoute(builder: (context) => const RoleSelectionScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.myTeal,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/Artboard_6.png', height: size.height * 0.15),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
//   NoAnimationPageRoute({required WidgetBuilder builder})
//       : super(builder: builder);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child; // 🔁 No animation during transition
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/user/user_home_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    // Step 1: Request permissions and save location
    await _requestPermissions();

    // Step 2: Load login & role info
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role');

    print("🔐 isLoggedIn: $isLoggedIn, role: $role");

    if (isLoggedIn && role != null) {
      switch (role) {
        case 'Admin':
          Navigator.pushReplacement(
            context,
            NoAnimationPageRoute(builder: (_) => const HomeScreen()),
          );
          break;
        case 'User':
        case 'Employee':
          Navigator.pushReplacement(
            context,
            NoAnimationPageRoute(builder: (_) => const UserHomeScreen()),
          );
          break;
        default:
          _navigateToRoleSelection();
      }
    } else {
      _navigateToRoleSelection();
    }
  }

  Future<void> _requestPermissions() async {
    // 1. Location Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(
        title: "Location Required",
        message: "Please enable location permission from app settings.",
      );
      return;
    }

    // 2. Additional Android-specific permissions
    if (Platform.isAndroid) {
      final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
      if (batteryStatus.isDenied) {
        await Permission.ignoreBatteryOptimizations.request();
      }

      final bgLocationStatus = await Permission.locationAlways.status;
      if (bgLocationStatus.isDenied) {
        await Permission.locationAlways.request();
      }
    }

    // 3. Save location if permission is granted
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('lastLatitude', position.latitude);
        await prefs.setDouble('lastLongitude', position.longitude);

        print("📍 Saved Lat=${position.latitude}, Lon=${position.longitude}");
      } catch (e) {
        print("❌ Failed to get location: $e");
      }
    }
  }

  void _navigateToRoleSelection() {
    Navigator.pushReplacement(
      context,
      NoAnimationPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  void _showPermissionDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.myTeal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Artboard_6.png', height: size.height * 0.15),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child; // No animation during transition
  }
}
