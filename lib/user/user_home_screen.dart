// import 'package:flutter/material.dart';
// import 'package:quick_roll/user/user_id_card.dart';
// import 'package:quick_roll/user/user_intime_scanner.dart';
// import 'package:quick_roll/user/user_login_screen.dart';
// import 'package:quick_roll/user/user_outime_screen.dart';
// import 'package:quick_roll/user/user_overtime_employees_screen.dart';
// import 'package:quick_roll/user/user_salary_slip_screen.dart';
// // import 'package:quick_roll/user/user_weekly_summary_screen.dart';
// import 'package:quick_roll/utils/user_colors.dart';
// import 'package:quick_roll/widgets/user_drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import the login screen

// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<UserHomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _currentIndex = 0;

//   // The list of footer screens
//   final List<Widget> _footerScreens = [
//     const Center(child: Text('Dashboard', style: TextStyle(fontSize: 20))),
//     const Center(child: Text('Admin', style: TextStyle(fontSize: 20))),
//     const Center(child: Text('Contact', style: TextStyle(fontSize: 20))),
//   ];

//   // Method to create Drawer items
//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool selected = false,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: AppColors.darkNavyBlue), // White icon color
//       title: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: const TextStyle(
//               color: AppColors.darkNavyBlue), // Set text color to black
//         ),
//       ),
//       selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
//       selected: selected,
//       onTap: onTap,
//     );
//   }

//   // Method to create Buttons
//   Widget _buildButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors
//             .lightGrayBlue, // Entire container gets the background color
//         borderRadius: BorderRadius.circular(12), // Rounded corners
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent, // Transparent button background
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           shadowColor: Colors.black26,
//           elevation: 0, // No shadow as the container color will be the focus
//         ),
//         onPressed: onPressed,
//         child: Row(
//           children: [
//             Icon(icon, size: 25, color: AppColors.darkNavyBlue),
//             const SizedBox(width: 16),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: AppColors.darkNavyBlue,
//               ),
//             ),
//             const Spacer(), // This spacer pushes the arrow to the right side
//             // const Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.darkNavyBlue), // Remove arrow icon
//           ],
//         ),
//       ),
//     );
//   }

//   void _onDrawerItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     Navigator.pop(context);
//   }

//   // Method to handle logout
//   void _logout() async {
//     // Clear the saved login state
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     // Provide feedback to the user (optional)
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Logged out successfully!')),
//     );

//     // Navigate to the LoginScreen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const Userlogin()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.softSlateBlue,
//         title: const Text(
//           'QUICK ROLL',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.darkNavyBlue,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, size: 28, color: AppColors.darkNavyBlue),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       ),
//       // Integration into Drawer Footer
//       drawer: CustomDrawer(
//         scaffoldKey: _scaffoldKey,
//         currentIndex: _currentIndex,
//         onItemTapped: _onDrawerItemTapped,
//         footer: _buildDrawerItem(
//           icon: Icons.logout,
//           title: 'Logout',
//           onTap: _logout, // Use the updated logout function here
//         ),
//       ),
//       body: _currentIndex == 0
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const SizedBox(height: 30),
//                           _buildButton(
//                             context,
//                             icon: Icons.qr_code,
//                             label: 'Fill Attendance',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const AttendanceScanner()),
//                             ),
//                           ),

//                           // const SizedBox(height: 30),
//                           // _buildButton(
//                           //   context,
//                           //   icon: Icons.qr_code,
//                           //   label: 'Out-time Scan',
//                           //   onPressed: () => Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) => const OuttimeScanner()),
//                           //   ),
//                           // ),

//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.badge,
//                             label: 'Employee ID Card',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const UserIdCard()),
//                             ),
//                           ),

//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.attach_money,
//                             label: 'Generate Salary Slip',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => SalarySlipScreen()),
//                             ),
//                           ),
//                           // const SizedBox(height: 16),
//                           // _buildButton(
//                           //   context,
//                           //   icon: Icons.calendar_today,
//                           //   label: 'Weekly Summary Report',
//                           //   onPressed: () => Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) =>const WeeklySummaryScreen()),
//                           //   ),
//                           // ),
//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.timelapse,
//                             label: 'Overtime Employees',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const OvertimeEmployeesScreen()),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : _footerScreens[_currentIndex - 1],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: AppColors.deepSkyBlue,
//         selectedItemColor: AppColors.softSlateBlue,
//         unselectedItemColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.update),
//             label: 'Update',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.support_agent),
//             label: 'Support',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quick_roll/user/user_id_card.dart';
import 'package:quick_roll/user/user_intime_scanner.dart';
import 'package:quick_roll/user/user_login_screen.dart';
import 'package:quick_roll/user/user_outime_screen.dart';
import 'package:quick_roll/user/user_overtime_employees_screen.dart';
import 'package:quick_roll/user/user_salary_slip_screen.dart';
// import 'package:quick_roll/user/user_weekly_summary_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:quick_roll/widgets/user_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the login screen

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Method to create Buttons
  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors
            .lightGrayBlue, // Entire container gets the background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparent button background
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          shadowColor: Colors.black26,
          elevation: 0, // No shadow as the container color will be the focus
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 25, color: AppColors.darkNavyBlue),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.darkNavyBlue,
              ),
            ),
            const Spacer(), // This spacer pushes the arrow to the right side
            // const Icon(Icons.arrow_forward_ios, size: 20, color: AppColors.darkNavyBlue), // Remove arrow icon
          ],
        ),
      ),
    );
  }

  // Method to handle logout
  void _logout() async {
    // Clear the saved login state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Provide feedback to the user (optional)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );

    // Navigate to the LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Userlogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.softSlateBlue,
        title: const Text(
          'QUICK ROLL',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavyBlue,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28, color: AppColors.darkNavyBlue),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: CustomDrawer(
        scaffoldKey: _scaffoldKey,
        footer: ListTile(
          leading: const Icon(Icons.logout, color: AppColors.darkNavyBlue),
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.darkNavyBlue),
            ),
          ),
          selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
          onTap: _logout,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Center(
                                    child: Text(
                                      'Albsocial',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Status: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'working',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '203',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Remaining',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '08',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Working Hours',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      icon: Icons.qr_code,
                      label: 'Fill Attendance',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AttendanceScanner()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      icon: Icons.badge,
                      label: 'Employee ID Card',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserIdCard()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      icon: Icons.attach_money,
                      label: 'Generate Salary Slip',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalarySlipScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      icon: Icons.timelapse,
                      label: 'Overtime Employees',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const OvertimeEmployeesScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserHomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserIdCard()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OvertimeEmployeesScreen()),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.deepSkyBlue,
        selectedItemColor: AppColors.softSlateBlue,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
      ),
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
        backgroundColor: AppColors.softSlateBlue,
      ),
      body: const Center(
          child: Text('Dashboard Screen', style: TextStyle(fontSize: 20))),
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
        backgroundColor: AppColors.softSlateBlue,
      ),
      body: const Center(
          child: Text('Admin Screen', style: TextStyle(fontSize: 20))),
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
        backgroundColor: AppColors.softSlateBlue,
      ),
      body: const Center(
          child: Text('Contact Screen', style: TextStyle(fontSize: 20))),
    );
  }
}
