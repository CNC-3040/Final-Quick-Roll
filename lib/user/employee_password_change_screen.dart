import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:quick_roll/services/global_API.dart';

class EmployeePasswordChangeScreen extends StatefulWidget {
  const EmployeePasswordChangeScreen({super.key});

  @override
  State<EmployeePasswordChangeScreen> createState() =>
      _EmployeePasswordChangeScreenState();
}

class _EmployeePasswordChangeScreenState
    extends State<EmployeePasswordChangeScreen> {
  bool showOtpField = false;
  bool showPasswordFields = false;
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email cannot be empty')),
      );
      return;
    }

    // Check if email exists
    final response = await http.post(
      Uri.parse('$baseURL/employee/check-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['exists']) {
        // Generate 6-digit OTP
        final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000))
            .toString();
        await EmailSender.sendEmail(
          recipientEmail: email,
          subject: 'QuickRoll Password Reset OTP',
          body:
              'Your OTP for password reset is: <b>$otp</b>. It is valid for 5 minutes.',
        );

        // Store OTP in backend
        await http.post(
          Uri.parse('$baseURL/employee/store-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'otp': otp, 'type': 'employee'}),
        );

        setState(() {
          showOtpField = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking email')),
      );
    }
  }

  Future<void> verifyOtpAndShowPasswordFields() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    final response = await http.post(
      Uri.parse('$baseURL/employee/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'type': 'employee'}),
    );

    if (response.statusCode == 200) {
      setState(() {
        showOtpField = false;
        showPasswordFields = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or expired OTP')),
      );
    }
  }

  Future<void> changePassword() async {
    final email = emailController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$baseURL/employee/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': newPassword}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error changing password')),
      );
    }
  }

  Widget _buildEmailInput() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Enter email address',
        prefixIcon: const Icon(Icons.email, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.lock_outline, size: 50, color: Colors.amber),
        const SizedBox(height: 10),
        const Text(
          "Enter OTP Code",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Please enter the 6-digit code sent to your email. Valid for 5 minutes.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        PinCodeTextField(
          appContext: context,
          length: 6,
          controller: otpController,
          onChanged: (value) {},
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor: Colors.black,
            selectedColor: Colors.teal,
            inactiveColor: Colors.grey,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: sendOtp,
            child: const Text(
              "Resend Code",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: verifyOtpAndShowPasswordFields,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Verify Code",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          "Set New Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your new password below.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'New Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Change Password",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.vpn_key, size: 60, color: Colors.orange),
                    const SizedBox(height: 16),
                    if (!showOtpField && !showPasswordFields) ...[
                      const Text(
                        "Reset Employee Password",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildEmailInput(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Send OTP",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ] else if (showOtpField) ...[
                      _buildOtpSection(),
                    ] else if (showPasswordFields) ...[
                      _buildPasswordFields(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailSender {
  static const String username = 'admin@quickroll.in';
  static const String password = 'Onelove@3040';

  static Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final smtpServer = SmtpServer(
      'smtp.hostinger.com',
      port: 465,
      ssl: true,
      username: username,
      password: password,
    );

    const String htmlHeader = '''
      <div style="background-color:#35BC52;padding:20px;text-align:center;color:#ffffff;font-family:Arial,sans-serif;">
        <h1 style="margin:0;">QuickRoll</h1>
        <p style="margin:0;font-size:16px;">Your trusted partner in seamless operations</p>
      </div>
    ''';

    const String htmlFooter = '''
      <div style="background-color:#f0f0f0;padding:20px;text-align:center;font-family:Arial,sans-serif;font-size:12px;color:#666;">
        <p style="margin:0;">© 2025 QuickRoll. All rights reserved.</p>
        <p style="margin:5px 0 0;">Follow us on 
          <a href="https://twitter.com/quickroll" style="color:#35BC52;text-decoration:none;">Twitter</a>, 
          <a href="https://facebook.com/quickroll" style="color:#35BC52;text-decoration:none;">Facebook</a>
        </p>
      </div>
    ''';

    final String fullHtmlBody = '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body style="margin:0;padding:0;">
          $htmlHeader
          <div style="padding:20px;font-family:Arial,sans-serif;font-size:14px;line-height:1.6;color:#333;">
            $body
          </div>
          $htmlFooter
        </body>
      </html>
    ''';

    final message = Message()
      ..from = Address(username, 'QuickRoll Admin')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = fullHtmlBody;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Email failed to send.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}
