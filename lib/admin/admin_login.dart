import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_roll/admin/company_password_change_screen.dart';
import 'package:quick_roll/admin/company_registration_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/admin/auth_service.dart' as admin_auth;
import 'package:quick_roll/user/user_auth_service.dart' as user_auth;
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/user/user_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

    // Try company login first
    var loginResult = await admin_auth.AuthService.isUserRegistered(
      identifierController.text,
      passwordController.text,
    );

    // If company login fails, try employee login
    if (loginResult['status'] != 'success') {
      loginResult = await user_auth.AuthService.isUserRegistered(
        identifierController.text,
        passwordController.text,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (loginResult['status'] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString(
          'loginType', loginResult['type']); // Save login type

      if (loginResult['type'] == 'company') {
        await prefs.setString('role', 'Admin');
        // Navigate to HomeScreen for company
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (loginResult['type'] == 'employee') {
        await prefs.setString('role', 'User');
        // Save additional employee details
        String? userEmail = await user_auth.AuthService.getLoggedInUserEmail();
        String? userContact =
            await user_auth.AuthService.getLoggedInUserContact();
        String? userId = await user_auth.AuthService.getLoggedInUserId();
        String? companyId = await user_auth.AuthService.getLoggedInCompanyId();
        String? userName = await user_auth.AuthService.getLoggedInUserName();
        String? salary = await user_auth.AuthService.getLoggedInUserSalary();
        String? companyName =
            await user_auth.AuthService.getLoggedInUserCompanyName();
        String? workPlace =
            await user_auth.AuthService.getLoggedInUserWorkPlace();
        String? workingHours =
            await user_auth.AuthService.getLoggedInUserWorkingHours();

        await prefs.setString('loggedInUserEmail', userEmail ?? '');
        await prefs.setString('loggedInUserContact', userContact ?? '');
        await prefs.setString('loggedInUserId', userId ?? '');
        await prefs.setString('loggedInUserCompanyId', companyId ?? '');
        await prefs.setString('loggedInUserName', userName ?? '');
        await prefs.setString('loggedInUserSalary', salary ?? '0.0');
        await prefs.setString('loggedInUserCompanyName', companyName ?? '');
        await prefs.setString('loggedInUserWorkPlace', workPlace ?? '');
        await prefs.setString('loggedInUserWorkingHours', workingHours ?? '');

        // Navigate to UserHomeScreen for employee
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserHomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(loginResult['message'] ??
                "Invalid credentials. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
            );
          },
        ),
        title: Text(
          'Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
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
                        'assets/Artboard_16_copy.png',
                        height: size.height * 0.1,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Login to Your Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
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
                          labelText: 'Username, Email or Contact',
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
                                backgroundColor: AppColors.forestGreen,
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
                                    const CompanyPasswordChangeScreen()),
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
                          backgroundColor: AppColors.forestGreen,
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
                              builder: (context) => BusinessNameScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'New Company Registration',
                          style: TextStyle(
                            color: AppColors.white,
                          ),
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
