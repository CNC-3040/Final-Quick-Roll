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

import 'package:flutter/material.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/user/user_login_screen.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.forestGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Image.asset(
                    'assets/Artboard_6.png',
                    height: size.height * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.09),
                Text(
                  'Choose your Role',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleContainer(
                      context,
                      title: 'Company Administrator',
                      icon: Icons.business,
                      color: AppColors.forestGreen,
                      bgColor: AppColors.planeGray,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildRoleContainer(
                      context,
                      title: 'Employee',
                      icon: Icons.person,
                      color: AppColors.forestGreen,
                      bgColor: AppColors.planeGray,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Userlogin()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
