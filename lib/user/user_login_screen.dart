// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quick_roll/core/forgot_password_screen.dart';
// import 'package:quick_roll/core/role_selection_screen.dart';
// import 'package:quick_roll/core/splash_screen.dart';
// import 'package:quick_roll/user/user_auth_service.dart';
// import 'package:quick_roll/utils/user_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Userlogin extends StatefulWidget {
//   const Userlogin({super.key});

//   @override
//   _UserloginState createState() => _UserloginState();
// }

// class _UserloginState extends State<Userlogin> {
//   final TextEditingController identifierController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isLoading = false; // Loading indicator

//   void _login(BuildContext context) async {
//     if (identifierController.text.isEmpty || passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please enter email/contact and password")),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true; // Show loader
//     });

//     bool isRegistered = await AuthService.isUserRegistered(
//       identifierController.text,
//       passwordController.text,
//     );

//     setState(() {
//       _isLoading = false; // Hide loader
//     });

//     if (isRegistered) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//       await prefs.setString('role', 'User'); // Save role as User

//       // Save user details
//       String? userEmail = await AuthService.getLoggedInUserEmail();
//       String? userContact = await AuthService.getLoggedInUserContact();
//       String? userId = await AuthService.getLoggedInUserId();
//       String? companyId =
//           await AuthService.getLoggedInCompanyId(); // Get company_id

//       await prefs.setString('loggedInUserEmail', userEmail ?? '');
//       await prefs.setString('loggedInUserContact', userContact ?? '');
//       await prefs.setString('loggedInUserId', userId ?? '');
//       await prefs.setString(
//           'loggedInCompanyId', companyId ?? ''); // Save company_id

//       // Navigate to SplashScreen after successful login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SplashScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid credentials. Please try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.deepSkyBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.deepSkyBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.white),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const RoleSelectionScreen()),
//             );
//           },
//         ),
//         title: const Text(
//           'Login',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.white,
//           ),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Container(
//                   width: size.width * 0.9,
//                   decoration: BoxDecoration(
//                     color: AppColors.lightGrayBlue,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         'assets/imagee.png',
//                         height: size.height * 0.1,
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Login to Your User Account',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.darkNavyBlue,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: identifierController,
//                         cursorColor: AppColors.darkNavyBlue,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                         ],
//                         decoration: const InputDecoration(
//                           labelText: 'Email or Contact',
//                           labelStyle: TextStyle(color: AppColors.darkNavyBlue),
//                           border: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.darkNavyBlue),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.darkNavyBlue),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: AppColors.darkNavyBlue, width: 2.0),
//                           ),
//                           prefixIcon:
//                               Icon(Icons.phone, color: AppColors.darkNavyBlue),
//                         ),
//                         keyboardType: TextInputType.text,
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: passwordController,
//                         cursorColor: AppColors.darkNavyBlue,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle:
//                               const TextStyle(color: AppColors.darkNavyBlue),
//                           border: const OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.darkNavyBlue),
//                           ),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.darkNavyBlue),
//                           ),
//                           focusedBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: AppColors.darkNavyBlue, width: 2.0),
//                           ),
//                           prefixIcon: const Icon(Icons.lock,
//                               color: AppColors.darkNavyBlue),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: AppColors.darkNavyBlue,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: !_isPasswordVisible,
//                       ),
//                       const SizedBox(height: 16),
//                       _isLoading
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.darkNavyBlue,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 40),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               onPressed: () => _login(context),
//                               child: const Text(
//                                 'Login',
//                                 style: TextStyle(
//                                   color: AppColors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                       const SizedBox(height: 2),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     const OtpVerificationScreen()),
//                           );
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                               color: AppColors
//                                   .darkNavyBlue), // or use Colors.grey if you want a gray color
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_roll/core/forgot_password_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/core/splash_screen.dart';
import 'package:quick_roll/user/employee_password_change_screen.dart';
import 'package:quick_roll/user/user_auth_service.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userlogin extends StatefulWidget {
  const Userlogin({super.key});

  @override
  _UserloginState createState() => _UserloginState();
}

class _UserloginState extends State<Userlogin> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login(BuildContext context) async {
    if (identifierController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter email/contact and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool isRegistered = await AuthService.isUserRegistered(
      identifierController.text,
      passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (isRegistered) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('role', 'User');

      // Save user details
      String? userEmail = await AuthService.getLoggedInUserEmail();
      String? userContact = await AuthService.getLoggedInUserContact();
      String? userId = await AuthService.getLoggedInUserId();
      String? companyId = await AuthService.getLoggedInCompanyId();
      String? userName = await AuthService.getLoggedInUserName(); // Added
      String? salary = await AuthService.getLoggedInUserSalary(); // Added

      await prefs.setString('loggedInUserEmail', userEmail ?? '');
      await prefs.setString('loggedInUserContact', userContact ?? '');
      await prefs.setString('loggedInUserId', userId ?? '');
      await prefs.setString('loggedInCompanyId', companyId ?? '');
      await prefs.setString('loggedInUserName', userName ?? ''); // Added
      await prefs.setString('loggedInUserSalary', salary ?? '0.0'); // Added

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.emeraldGreen,
      appBar: AppBar(
        backgroundColor: AppColors.emeraldGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.planeGray),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RoleSelectionScreen()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.planeGray,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    color: AppColors.planeGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/Artboard_5.png',
                        height: size.height * 0.1,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Login to Your Employee Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: identifierController,
                        cursorColor: AppColors.black,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Email or Contact',
                          labelStyle: TextStyle(color: AppColors.black),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.black, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.phone, color: AppColors.black),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        cursorColor: AppColors.black,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: AppColors.black),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.black, width: 2.0),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: AppColors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _login(context),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.planeGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EmployeePasswordChangeScreen()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
