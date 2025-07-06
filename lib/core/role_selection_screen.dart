// import 'package:flutter/material.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/user/user_login_screen.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor:
//           AppColors.emeraldGreen, // Set background color to skyBlue
//       appBar: AppBar(
//         // title: const Text(
//         //   'Select Role',
//         //   style: TextStyle(
//         //     fontWeight: FontWeight.bold, // Make "Select Role" bold
//         //   ),
//         // ),
//         centerTitle: true,
//         backgroundColor: AppColors.emeraldGreen,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
//               child: Image.asset(
//                 'assets/Artboard_6.png',
//                 height: size.height * 0.15, // Professional logo size
//                 fit: BoxFit.contain, // Ensure logo scales properly
//               ),
//             ),
//             SizedBox(height: size.height * 0.09),
//             Text(
//               'Choose your Role',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildRoleContainer(
//                   context,
//                   title: 'Company Administrator',
//                   icon: Icons.business,
//                   color: AppColors.forestGreen, // Charcoal Gray
//                   bgColor: AppColors.babyBlue, // Baby Blue Background
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 _buildRoleContainer(
//                   context,
//                   title: 'Employee',
//                   icon: Icons.person,
//                   color: AppColors.forestGreen, // Charcoal Gray
//                   bgColor: AppColors.babyBlue, // Baby Blue Background
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               const Userlogin()), // Navigate to UserLoginScreen
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleContainer(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 150,
//         decoration: BoxDecoration(
//           color: bgColor, // Baby Blue Background
//           borderRadius: BorderRadius.circular(20),
//           // border: Border.all(color: color, width: 2), // Charcoal Gray Border
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: color), // Charcoal Gray Icon
//             const SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color, // Charcoal Gray Text
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/user/user_login_screen.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.forestGreen,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.forestGreen,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
//                   child: Image.asset(
//                     'assets/Artboard_6.png',
//                     height: size.height * 0.15,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 SizedBox(height: size.height * 0.09),
//                 Text(
//                   'Choose your Role',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildRoleContainer(
//                       context,
//                       title: 'Company Administrator',
//                       icon: Icons.business,
//                       color: AppColors.forestGreen,
//                       bgColor: AppColors.planeGray,
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoginScreen()),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildRoleContainer(
//                       context,
//                       title: 'Employee',
//                       icon: Icons.person,
//                       color: AppColors.forestGreen,
//                       bgColor: AppColors.planeGray,
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const Userlogin()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleContainer(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required Color bgColor,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 150,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: color),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/admin/company_registration_screen.dart';
// import 'package:quick_roll/user/user_login_screen.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/customize_widgets_buttons.dart';

// class RoleSelectionScreen extends StatelessWidget {
//   const RoleSelectionScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9F9),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             children: [
//               const Spacer(),
//               // Logo Image
//               Image.asset(
//                 'assets/Artboard_5.png',
//                 height: size.height * 0.15,
//               ),
//               const SizedBox(height: 70),
//               // "Sign Up As," text
//               Text(
//                 'Sign Up As,',
//                 style: GoogleFonts.poppins(
//                   fontSize: 30,
//                   fontWeight: FontWeight.w300,
//                   color: AppColors.myTeal,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Employee Button
//               CustomRoleButton(
//                 text: 'Employee',
//                 backgroundColor: AppColors.myTeal,
//                 textColor: Colors.white,
//                 nextScreen: NoAnimationPageRoute(
//                   builder: (context) => const Userlogin(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Business Button
//               CustomRoleButton(
//                 text: 'Business',
//                 backgroundColor: AppColors.deepTeal,
//                 textColor: Colors.white,
//                 nextScreen: NoAnimationPageRoute(
//                   builder: (context) => BusinessNameScreen(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // Already have an account text
//               Text(
//                 'Already have an account?',
//                 style: GoogleFonts.poppins(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.myTeal,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // Login Button (Outline)
//               CustomRoleButton(
//                 text: 'Login',
//                 backgroundColor:
//                     Colors.transparent, // Not used in outlined mode
//                 textColor: AppColors.myTeal,
//                 nextScreen: NoAnimationPageRoute(
//                   builder: (context) => BusinessNameScreen(),
//                 ),
//                 isOutlined: true,
//                 borderColor: AppColors.myTeal,
//               ),
//               SizedBox(height: size.height * 0.03),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/admin/company_registration_screen.dart';
import 'package:quick_roll/user/user_login_screen.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/customize_widgets_buttons.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.planeGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              SizedBox(
                  height: height * 0.20), // Instead of Spacer for top spacing
              // Logo Image
              Image.asset(
                'assets/Artboard_5.png',
                height: height * 0.21,
              ),
              SizedBox(height: height * 0.07),
              // "Sign Up As," text
              Text(
                'Sign Up As,',
                style: GoogleFonts.poppins(
                  fontSize: height * 0.035, // Around 30 on typical device
                  fontWeight: FontWeight.w300,
                  color: AppColors.myTeal,
                ),
              ),
              SizedBox(height: height * 0.02),
              // Employee Button
              // CustomRoleButton(
              //   text: 'Employee',
              //   backgroundColor: AppColors.myTeal,
              //   textColor: Colors.white,
              //   nextScreen: NoAnimationPageRoute(
              //     builder: (context) => const Userlogin(),
              //   ),
              // ),
              SizedBox(height: height * 0.015),
              // Business Button
              CustomRoleButton(
                text: 'Business',
                backgroundColor: AppColors.deepTeal,
                textColor: Colors.white,
                nextScreen: NoAnimationPageRoute(
                  builder: (context) => const BusinessNameScreen(),
                ),
              ),
              SizedBox(height: height * 0.01),
              // Already have an account text
              Text(
                'Already have an account?',
                style: GoogleFonts.poppins(
                  fontSize: height * 0.018, // ~15 on standard device
                  fontWeight: FontWeight.w400,
                  color: AppColors.myTeal,
                ),
              ),
              SizedBox(height: height * 0.01),
              // Login Button (Outline)
              CustomRoleButton(
                text: 'Login',
                backgroundColor: Colors.transparent,
                textColor: AppColors.myTeal,
                nextScreen: NoAnimationPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                isOutlined: true,
                borderColor: AppColors.myTeal,
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
