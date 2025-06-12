// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/admin/employees_list.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/admin_drawer.dart';
// import 'id_card_screen.dart';
// import 'salary_slip_screen.dart';
// import 'weekly_summary_screen.dart';
// import 'qr_code_generate_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _currentIndex = 0;
//   String? _userName;

//   // List of images for the slider
//   final List<String> _sliderImages = [
//     'assets/image1.jpg',
//     'assets/image2.png',
//     'assets/image3.jpg',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _getUserName();
//   }

//   // Fetch user data from SharedPreferences
//   Future<void> _getUserName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _userName = prefs.getString('username') ?? 'Guest';
//     });
//   }

//   // Method to create Drawer items
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

//   // Method to create Buttons
//   Widget _buildButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.babyBlue,
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
//             Icon(icon, size: 25, color: AppColors.charcoalGray),
//             const SizedBox(width: 16),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 15,
//                 color: AppColors.charcoalGray,
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
//     await prefs.clear(); // Clears all preferences

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Logged out successfully!')),
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'QUICK ROLL',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, size: 28, color: AppColors.charcoalGray),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       ),
//       body: _currentIndex == 0
//           ? Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Slider for images
//                   CarouselSlider(
//                     items: _sliderImages
//                         .map(
//                           (imagePath) => ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.asset(
//                               imagePath,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     options: CarouselOptions(
//                       height: 180,
//                       autoPlay: true,
//                       enlargeCenterPage: true,
//                       aspectRatio: 16 / 9,
//                       enableInfiniteScroll: true,
//                       viewportFraction: 0.8,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           _buildButton(
//                             context,
//                             icon: Icons.badge,
//                             label: 'Employee List',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ViewEmployeesPage()),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.list,
//                             label: 'Employee ID Card',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const IDCardScreen()),
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
//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.calendar_today,
//                             label: 'Attendance Summary',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const AttendanceScreen()),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           _buildButton(
//                             context,
//                             icon: Icons.qr_code,
//                             label: 'Generate QR Code',
//                             onPressed: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const QRCodeGenerateScreen()),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : const Center(child: Text('Other Pages')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/admin/employees_list.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/admin_drawer.dart';
import 'id_card_screen.dart';
import 'salary_slip_screen.dart';
import 'weekly_summary_screen.dart';
import 'qr_code_generate_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String? _userName;

  // List of images for the slider
  final List<String> _sliderImages = [
    'assets/image1.jpg',
    'assets/image2.png',
    'assets/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  // Fetch user data from SharedPreferences
  Future<void> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? 'Guest';
    });
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
        color: AppColors.oliveGreen,
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
    await prefs.clear(); // Clears all preferences

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.planeGray,
      appBar: AppBar(
        backgroundColor: AppColors.oliveGreen,
        title: const Text(
          'QR Administrator',
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
            if (_scaffoldKey.currentState != null) {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: _currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Slider for images
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildButton(
                            context,
                            icon: Icons.badge,
                            label: 'Employee List',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ViewEmployeesPage()),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context,
                            icon: Icons.list,
                            label: 'Employee ID Card',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IDCardScreen()),
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
                                  builder: (context) => SalarySlipScreen()),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context,
                            icon: Icons.calendar_today,
                            label: 'Attendance Summary',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AttendanceScreen()),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context,
                            icon: Icons.qr_code,
                            label: 'Generate QR Code',
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const QRCodeGenerateScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('Other Pages')),
      // Move bottomNavigationBar here, as a property of Scaffold
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
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
        backgroundColor: AppColors.forestGreen,
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
        backgroundColor: AppColors.forestGreen,
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
        backgroundColor: AppColors.forestGreen,
      ),
      body: const Center(
          child: Text('Contact Screen', style: TextStyle(fontSize: 20))),
    );
  }
}
