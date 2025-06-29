// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:quick_roll/admin/home_screen.dart';
// import 'package:quick_roll/core/role_selection_screen.dart';
// import 'package:quick_roll/user/user_home_screen.dart';
// import 'package:quick_roll/utils/user_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _handleStartup();
//   }

//   Future<void> _handleStartup() async {
//     await Future.delayed(const Duration(milliseconds: 500)); // allow UI to show

//     bool permissionGranted = await _checkAndRequestLocationPermission();

//     if (!permissionGranted) {
//       await Geolocator.openAppSettings();
//       return;
//     }

//     await Future.delayed(const Duration(seconds: 2)); // splash delay

//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     final role = prefs.getString('role');

//     if (isLoggedIn && role != null) {
//       switch (role) {
//         case 'Admin':
//           _navigateTo(const HomeScreen());
//           return;
//         case 'User':
//         case 'Employee':
//           _navigateTo(const UserHomeScreen());
//           return;
//       }
//     }
//     _navigateTo(const RoleSelectionScreen());
//   }

//   Future<bool> _checkAndRequestLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.deniedForever ||
//         permission == LocationPermission.denied) {
//       return false;
//     }

//     return true;
//   }

//   void _navigateTo(Widget page) {
//     Navigator.pushReplacement(
//       context,
//       NoAnimationPageRoute(builder: (_) => page),
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
//             const CircularProgressIndicator(color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Reuse custom no-animation transition
// class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
//   NoAnimationPageRoute({required WidgetBuilder builder})
//       : super(builder: builder);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/user/user_home_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_roll/services/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Allow UI to render

    // Load global location
    try {
      await loadGlobalLocation();
    } catch (e) {
      debugPrint('Error loading global location: $e');
    }

    // Check location permission
    final permissionGranted = await _checkAndRequestLocationPermission();
    if (!permissionGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable location permissions in settings.'),
            duration: Duration(seconds: 5),
          ),
        );
        await Geolocator.openAppSettings();
      }
      return;
    }

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    // Navigate based on login status and role
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final role = prefs.getString('role');

      if (isLoggedIn && role != null) {
        switch (role) {
          case 'Admin':
            _navigateTo(const HomeScreen());
            return;
          case 'User':
          case 'Employee':
            _navigateTo(const UserHomeScreen());
            return;
        }
      }
      _navigateTo(const RoleSelectionScreen());
    } catch (e) {
      debugPrint('Error accessing SharedPreferences: $e');
      _navigateTo(const RoleSelectionScreen());
    }
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  void _navigateTo(Widget page) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        NoAnimationPageRoute(builder: (_) => page),
      );
    }
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
            const CircularProgressIndicator(color: Colors.white),
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
    return child;
  }
}
