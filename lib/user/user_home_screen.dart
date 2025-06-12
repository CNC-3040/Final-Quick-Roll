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

// import 'package:flutter/material.dart';
// import 'package:quick_roll/user/time_management_screen.dart';
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
//       drawer: CustomDrawer(
//         scaffoldKey: _scaffoldKey,
//         footer: ListTile(
//           leading: const Icon(Icons.logout, color: AppColors.darkNavyBlue),
//           title: const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Logout',
//               style: TextStyle(color: AppColors.darkNavyBlue),
//             ),
//           ),
//           selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
//           onTap: _logout,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 30),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1565C0),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       height: 140,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Expanded(
//                                 child: Padding(
//                                   padding: EdgeInsets.only(bottom: 8),
//                                   child: Center(
//                                     child: Text(
//                                       'Albsocial',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                   text: 'Status: ',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: 'working',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: const [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '04:14',
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Remaining',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     '08:00',
//                                     style: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Working Hours',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.qr_code,
//                       label: 'Fill Attendance',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const AttendanceScanner()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.badge,
//                       label: 'Employee ID Card',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const UserIdCard()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.attach_money,
//                       label: 'Generate Salary Slip',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SalarySlipScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.timelapse,
//                       label: 'Overtime Employees',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 const OvertimeEmployeesScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.access_time,
//                       label: 'Manage Time Entries',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const TimeManagementScreen()),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserHomeScreen()),
//               );
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserIdCard()),
//               );
//               break;
//             case 2:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const OvertimeEmployeesScreen()),
//               );
//               break;
//           }
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

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Dashboard Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

// class AdminScreen extends StatelessWidget {
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Admin Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

// class ContactScreen extends StatelessWidget {
//   const ContactScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contact'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Contact Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/admin/user_registration.dart';
// import 'package:quick_roll/user/time_management_screen.dart';
// import 'package:quick_roll/user/user_id_card.dart';
// import 'package:quick_roll/user/user_intime_scanner.dart';
// import 'package:quick_roll/user/user_login_screen.dart';
// import 'package:quick_roll/user/user_outime_screen.dart';
// import 'package:quick_roll/user/user_overtime_employees_screen.dart';
// import 'package:quick_roll/user/user_salary_slip_screen.dart';
// import 'package:quick_roll/utils/user_colors.dart';
// import 'package:quick_roll/widgets/user_drawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<UserHomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String employeeName = 'Loading...';
//   String remainingHours = '00:00';
//   // String requiredHours = '08:00';
//   String workedHours = '08:00';
//   String status = 'not working';
//   String currentDate = '';
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _fetchCurrentDateAndStatus();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _fetchCurrentDateAndStatus();
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedEmployeeName = prefs.getString('loggedInUserName');
//     if (savedEmployeeName != null && savedEmployeeName.isNotEmpty) {
//       setState(() {
//         employeeName = savedEmployeeName;
//       });
//     }
//   }

//   Future<void> _fetchCurrentDateAndStatus() async {
//     try {
//       // Fetch current IST date
//       final dateResponse = await http.get(
//         Uri.parse(
//             'https://timeapi.io/api/Time/current/zone?timeZone=Asia/Kolkata'),
//       );

//       if (dateResponse.statusCode == 200) {
//         final dateData = jsonDecode(dateResponse.body);
//         final date = dateData['date'].split('/');
//         // Format date as YYYY-MM-DD
//         currentDate =
//             '${date[2]}-${date[0].padLeft(2, '0')}-${date[1].padLeft(2, '0')}';
//         print('Current date: $currentDate');

//         // Fetch attendance status
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         final companyId = prefs.getString('loggedInUserCompanyId');
//         final employeeId = prefs.getString('loggedInUserId');

//         if (companyId == null || employeeId == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text('User data not found. Please login again.')),
//           );
//           return;
//         }

//         final statusResponse = await http.get(
//           Uri.parse(
//               'https://qr.albsocial.in/api/status?company_id=$companyId&employee_id=$employeeId&date=$currentDate'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//         );

//         print('Status API response status: ${statusResponse.statusCode}');
//         print('Status API response body: ${statusResponse.body}');

//         if (statusResponse.statusCode == 200) {
//           final statusData = jsonDecode(statusResponse.body)['data'];
//           setState(() {
//             // companyName = statusData['company_name'] ?? companyName;
//             remainingHours = statusData['remaining_hours'] ?? remainingHours;
//             workedHours = statusData['worked_hours'] ?? workedHours;
//             status = statusData['status'] ?? status;
//             // Save company_name to SharedPreferences if updated
//             if (statusData['company_name'] != null) {
//               prefs.setString(
//                   'loggedInUserCompanyName', statusData['company_name']);
//             }
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     'Failed to fetch status: ${statusResponse.statusCode}')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text('Failed to fetch date: ${dateResponse.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching data: $e')),
//       );
//     }
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
//         color: AppColors.emeraldGreen,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           shadowColor: Colors.black26,
//           elevation: 0,
//         ),
//         onPressed: onPressed,
//         child: Row(
//           children: [
//             Icon(icon, size: 25, color: AppColors.planeGray),
//             const SizedBox(width: 16),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: AppColors.planeGray,
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Method to handle logout
//   void _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Logged out successfully!')),
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const Userlogin()),
//     );
//   }

//   final List<String> _sliderImages = [
//     'assets/image1.jpg',
//     'assets/image2.png',
//     'assets/image3.jpg',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: AppColors.planeGray,
//       appBar: AppBar(
//         backgroundColor: AppColors.forestGreen,
//         title: const Text(
//           'QUICK ROLL',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.planeGray,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, size: 28, color: AppColors.planeGray),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       ),
//       drawer: CustomDrawer(
//         scaffoldKey: _scaffoldKey,
//         footer: ListTile(
//           leading: const Icon(Icons.logout, color: AppColors.darkNavyBlue),
//           title: const Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Logout',
//               style: TextStyle(color: AppColors.darkNavyBlue),
//             ),
//           ),
//           selectedTileColor: AppColors.darkNavyBlue.withOpacity(0.1),
//           onTap: _logout,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     CarouselSlider(
//                       items: _sliderImages
//                           .map(
//                             (imagePath) => ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.asset(
//                                 imagePath,
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       options: CarouselOptions(
//                         height: 180,
//                         autoPlay: true,
//                         enlargeCenterPage: true,
//                         aspectRatio: 16 / 9,
//                         enableInfiniteScroll: true,
//                         viewportFraction: 0.8,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     _buildButton(
//                       context,
//                       icon: Icons.qr_code,
//                       label: 'Fill Attendance',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const AttendanceScanner()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.badge,
//                       label: 'Employee ID Card',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const UserIdCard()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.attach_money,
//                       label: 'Generate Salary Slip',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SalarySlipScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.timelapse,
//                       label: 'Overtime Employees',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 const OvertimeEmployeesScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildButton(
//                       context,
//                       icon: Icons.access_time,
//                       label: 'Manage Time Entries',
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const TimeManagementScreen()),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppColors.forestGreen,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       height: 140,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 8),
//                                   child: Center(
//                                     child: Text(
//                                       employeeName,
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                   text: 'Status: ',
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: status,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     workedHours,
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const Text(
//                                     'Hours Worked',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     remainingHours,
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const Text(
//                                     "Today's Working Hours",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserHomeScreen()),
//               );
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserIdCard()),
//               );
//               break;
//             case 2:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const OvertimeEmployeesScreen()),
//               );
//               break;
//           }
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: AppColors.forestGreen,
//         selectedItemColor: AppColors.beigeSand,
//         unselectedItemColor: AppColors.planeGray,
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

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Dashboard Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

// class AdminScreen extends StatelessWidget {
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Admin Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

// class ContactScreen extends StatelessWidget {
//   const ContactScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contact'),
//         backgroundColor: AppColors.softSlateBlue,
//       ),
//       body: const Center(
//           child: Text('Contact Screen', style: TextStyle(fontSize: 20))),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_roll/admin/user_registration.dart';
import 'package:quick_roll/user/time_management_screen.dart';
import 'package:quick_roll/user/user_id_card.dart';
import 'package:quick_roll/user/user_intime_scanner.dart';
import 'package:quick_roll/user/user_login_screen.dart';
import 'package:quick_roll/user/user_outime_screen.dart';
import 'package:quick_roll/user/user_overtime_employees_screen.dart';
import 'package:quick_roll/user/user_salary_slip_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:quick_roll/widgets/user_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String employeeName = 'Loading...';
  String remainingHours = '00:00';
  String workedHours = '08:00';
  String status = 'not working';
  String currentDate = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCurrentDateAndStatus();
    // Start a timer to periodically update status (every 30 seconds to reduce load)
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchCurrentDateAndStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmployeeName = prefs.getString('loggedInUserName');
    if (savedEmployeeName != null && savedEmployeeName.isNotEmpty) {
      setState(() {
        employeeName = savedEmployeeName;
      });
    }
  }

  Future<void> _fetchCurrentDateAndStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedDate = prefs.getString('cachedCurrentDate');
      String? cacheDateTime = prefs.getString('cacheDateTime');

      // Check if cached date is from today
      bool isDateValid = false;
      if (cachedDate != null && cacheDateTime != null) {
        DateTime cacheTime = DateTime.parse(cacheDateTime);
        DateTime now = DateTime.now();
        isDateValid = cacheTime.day == now.day &&
            cacheTime.month == now.month &&
            cacheTime.year == now.year;
      }

      if (!isDateValid) {
        // Fetch current IST date from API
        final dateResponse = await http.get(
          Uri.parse(
              'https://timeapi.io/api/Time/current/zone?timeZone=Asia/Kolkata'),
        );

        if (dateResponse.statusCode == 200) {
          final dateData = jsonDecode(dateResponse.body);
          final date = dateData['date'].split('/');
          // Format date as YYYY-MM-DD
          currentDate =
              '${date[2]}-${date[0].padLeft(2, '0')}-${date[1].padLeft(2, '0')}';
          print('Current date fetched from API: $currentDate');
          // Cache the date and current timestamp
          await prefs.setString('cachedCurrentDate', currentDate);
          await prefs.setString(
              'cacheDateTime', DateTime.now().toIso8601String());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to fetch date: ${dateResponse.statusCode}')),
          );
          return;
        }
      } else {
        // Use cached date
        currentDate = cachedDate!;
        print('Using cached date: $currentDate');
      }

      // Fetch attendance status
      final companyId = prefs.getString('loggedInUserCompanyId');
      final employeeId = prefs.getString('loggedInUserId');

      if (companyId == null || employeeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User data not found. Please login again.')),
        );
        return;
      }

      final statusResponse = await http.get(
        Uri.parse(
            'https://qr.albsocial.in/api/status?company_id=$companyId&employee_id=$employeeId&date=$currentDate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Status API response status: ${statusResponse.statusCode}');
      print('Status API response body: ${statusResponse.body}');

      if (statusResponse.statusCode == 200) {
        final statusData = jsonDecode(statusResponse.body)['data'];
        setState(() {
          remainingHours = statusData['remaining_hours'] ?? remainingHours;
          workedHours = statusData['worked_hours'] ?? workedHours;
          status = statusData['status'] ?? status;
          // Save company_name to SharedPreferences if updated
          if (statusData['company_name'] != null) {
            prefs.setString(
                'loggedInUserCompanyName', statusData['company_name']);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to fetch status: ${statusResponse.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  // Method to create Buttons
  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.emeraldGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          shadowColor: Colors.black26,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 25, color: AppColors.planeGray),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.planeGray,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Method to handle logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Userlogin()),
    );
  }

  final List<String> _sliderImages = [
    'assets/image1.jpg',
    'assets/image2.png',
    'assets/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.planeGray,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        title: const Text(
          'QR Employee',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.planeGray,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28, color: AppColors.planeGray),
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
                    CarouselSlider(
                      items: _sliderImages
                          .map(
                            (imagePath) => ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.8,
                      ),
                    ),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 16),
                    _buildButton(
                      context,
                      icon: Icons.access_time,
                      label: 'Manage Time Entries',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TimeManagementScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Center(
                                    child: Text(
                                      employeeName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
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
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: status,
                                      style: const TextStyle(
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
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    workedHours,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'Hours Worked',
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
                                    remainingHours,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Today's Working Hours",
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
        backgroundColor: AppColors.forestGreen,
        selectedItemColor: AppColors.beigeSand,
        unselectedItemColor: AppColors.planeGray,
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
