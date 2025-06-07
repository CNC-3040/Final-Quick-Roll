import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_roll/admin/company_registration_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/admin/auth_service.dart';
import 'package:quick_roll/core/splash_screen.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<LoginScreen> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login(BuildContext context) async {
    if (identifierController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter username or email and password")),
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
      await prefs.setString('role', 'Admin'); // Save role as Admin

      // Save user details
      String? userEmail = await AuthService.getLoggedInUserEmail();
      String? userContact = await AuthService.getLoggedInUserContact();
      String? userId = await AuthService.getLoggedInUserId();

      await prefs.setString('loggedInUserEmail', userEmail ?? '');
      await prefs.setString('loggedInUserContact', userContact ?? '');
      await prefs.setString('loggedInUserId', userId ?? '');

      // Navigate to SplashScreen after successful login
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
      backgroundColor: AppColors.slateTeal,
      appBar: AppBar(
        backgroundColor: AppColors.slateTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const RoleSelectionScreen()),
            );
          },
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
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
                    color: AppColors.babyBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/imagee.png',
                        height: size.height * 0.1,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Login to Your Admin Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.charcoalGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: identifierController,
                        cursorColor: AppColors.charcoalGray,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Username or Email',
                          labelStyle: TextStyle(color: AppColors.charcoalGray),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.charcoalGray),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.charcoalGray),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.charcoalGray, width: 2.0),
                          ),
                          prefixIcon:
                              Icon(Icons.person, color: AppColors.charcoalGray),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        cursorColor: AppColors.charcoalGray,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              const TextStyle(color: AppColors.charcoalGray),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.charcoalGray),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.charcoalGray),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.charcoalGray, width: 2.0),
                          ),
                          prefixIcon: const Icon(Icons.lock,
                              color: AppColors.charcoalGray),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.charcoalGray,
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
                                backgroundColor: AppColors.charcoalGray,
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
                                  color: AppColors.white,
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
                                    const OtpVerificationScreen()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.charcoalGray),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .charcoalGray, // Change background color to charcoalGray
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyRegistrationScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'New Company Registration',
                          style: TextStyle(
                              color: AppColors
                                  .white), // Change text color to white
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
