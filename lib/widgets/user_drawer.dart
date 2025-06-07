// import 'package:flutter/material.dart';
// import 'package:quick_roll/utils/user_colors.dart';

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
//                 decoration: const BoxDecoration(color: AppColors.softSlateBlue),
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
//                           color: AppColors.darkNavyBlue,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'www.quickroll.com',
//                         style: TextStyle(
//                           color: AppColors.darkNavyBlue,
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
//       leading: Icon(icon, color: AppColors.darkNavyBlue),
//       title: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: const TextStyle(color: AppColors.darkNavyBlue),
//         ),
//       ),
//       selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
//       selected: selected,
//       onTap: onTap,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quick_roll/user/user_home_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? footer;

  const CustomDrawer({
    super.key,
    required this.scaffoldKey,
    this.footer,
  });

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
                decoration: const BoxDecoration(color: AppColors.softSlateBlue),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/image.png',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quick Roll',
                        style: TextStyle(
                          color: AppColors.darkNavyBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'www.quickroll.com',
                        style: TextStyle(
                          color: AppColors.darkNavyBlue,
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
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserHomeScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashboardScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.contact_mail,
                    title: 'Contact',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.darkNavyBlue),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: AppColors.darkNavyBlue),
        ),
      ),
      selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
