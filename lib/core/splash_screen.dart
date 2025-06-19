// import 'package:flutter/material.dart';
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
//     _navigateToNextScreen();
//   }

//   void _navigateToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 2)); // Splash delay
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     final role = prefs.getString('role'); // Retrieve stored role (Admin/User)

//     if (isLoggedIn) {
//       if (role == 'Admin') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const UserHomeScreen()),
//         );
//       }
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
//       );
//     }
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

import 'package:flutter/material.dart';
import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/user/user_home_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('role'); // Retrieve stored role (Admin/User)

    if (isLoggedIn) {
      if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          NoAnimationPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          NoAnimationPageRoute(builder: (context) => const UserHomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        NoAnimationPageRoute(builder: (context) => const RoleSelectionScreen()),
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
          ],
        ),
      ),
    );
  }
}

// Define NoAnimationPageRoute if not already in signup_flow.dart
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
