// import 'package:flutter/material.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class CustomDrawer extends StatelessWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//   final int currentIndex;
//   final Function(int) onItemTapped;
//   final Widget? footer; // Add footer parameter

//   const CustomDrawer({
//     super.key,
//     required this.scaffoldKey,
//     required this.currentIndex,
//     required this.onItemTapped,
//     this.footer, // Initialize footer
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: AppColors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 250,
//               child: DrawerHeader(
//                 decoration: const BoxDecoration(color: AppColors.skyBlue),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 45,
//                         backgroundColor: Colors.white,
//                         child: ClipOval(
//                           child: Image.asset(
//                             'assets/image.png',
//                             fit: BoxFit.cover,
//                             width: 90,
//                             height: 90,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Quick Roll',
//                         style: TextStyle(
//                           color: AppColors.charcoalGray,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'www.quickroll.com',
//                         style: TextStyle(
//                           color: AppColors.charcoalGray,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   _buildDrawerItem(
//                     icon: Icons.home,
//                     title: 'Home',
//                     selected: currentIndex == 0,
//                     onTap: () => onItemTapped(0),
//                   ),
//                   _buildDrawerItem(
//                     icon: Icons.dashboard,
//                     title: 'Dashboard',
//                     onTap: () => onItemTapped(1),
//                   ),
//                   _buildDrawerItem(
//                     icon: Icons.admin_panel_settings,
//                     title: 'Admin',
//                     onTap: () => onItemTapped(2),
//                   ),
//                   _buildDrawerItem(
//                     icon: Icons.contact_mail,
//                     title: 'Contact',
//                     onTap: () => onItemTapped(3),
//                   ),
//                 ],
//               ),
//             ),
//             if (footer != null) footer!, // Add footer widget if it's not null
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool selected = false,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: AppColors.charcoalGray),
//       title: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: const TextStyle(color: AppColors.charcoalGray),
//         ),
//       ),
//       selectedTileColor: AppColors.charcoalGray.withOpacity(0.1),
//       selected: selected,
//       onTap: onTap,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/admin/designation_screen.dart';
import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({
    super.key,
    required this.scaffoldKey,
  });

  // Logout function to clear user data and navigate to LoginScreen
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Clear user token or session data
    // Navigate to LoginScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.oliveGreen),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Artboard_16.png',
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(height: 8),
                      // const Text(
                      //   'Quick Roll',
                      //   style: TextStyle(
                      //     color: AppColors.charcoalGray,
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const SizedBox(height: 4),
                      const Text(
                        'www.quickroll.com',
                        style: TextStyle(
                          color: AppColors.planeGray,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                      }
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ),
                      );
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                      }
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminScreen(),
                        ),
                      );
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                      }
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.work,
                    title: 'Designation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DesignationScreen(),
                        ),
                      );
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                      }
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.contact_mail,
                    title: 'Contact',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactScreen(),
                        ),
                      );
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                      }
                    },
                  ),
                ],
              ),
            ),
            // Footer with Logout button
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.charcoalGray),
              title: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Logout',
                  style: TextStyle(color: AppColors.charcoalGray),
                ),
              ),
              selectedTileColor: AppColors.charcoalGray.withOpacity(0.1),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.charcoalGray),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: AppColors.charcoalGray),
        ),
      ),
      selectedTileColor: AppColors.charcoalGray.withOpacity(0.1),
      selected: selected,
      onTap: onTap,
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: const Center(child: Text('Contact Screen')),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: const Center(child: Text('Dashboard Screen')),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: AppColors.skyBlue,
      ),
      body: const Center(child: Text('Admin Screen')),
    );
  }
}
