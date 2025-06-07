import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isPhoneSelected = true;
  bool showOtpField = false;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  void sendCode() {
    final input = isPhoneSelected
        ? phoneController.text.trim()
        : emailController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Field cannot be empty')));
      return;
    }

    setState(() {
      showOtpField = true;
    });
  }

  Widget _buildOptionSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Row(
            children: const [
              Icon(Icons.phone, size: 18),
              SizedBox(width: 4),
              Text("Phone"),
            ],
          ),
          selected: isPhoneSelected,
          onSelected: (selected) {
            setState(() {
              isPhoneSelected = true;
              showOtpField = false;
            });
          },
          selectedColor: Colors.teal.shade100,
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: Row(
            children: const [
              Icon(Icons.email, size: 18),
              SizedBox(width: 4),
              Text("Email"),
            ],
          ),
          selected: !isPhoneSelected,
          onSelected: (selected) {
            setState(() {
              isPhoneSelected = false;
              showOtpField = false;
            });
          },
          selectedColor: Colors.teal.shade100,
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: isPhoneSelected ? phoneController : emailController,
      keyboardType:
          isPhoneSelected ? TextInputType.phone : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText:
            isPhoneSelected ? 'Enter phone number' : 'Enter email address',
        prefixIcon: Icon(
          isPhoneSelected ? Icons.phone : Icons.email,
          color: Colors.grey,
        ),
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
          "Please enter the 6-digit code sent to your ${isPhoneSelected ? 'phone' : 'email'}.",
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
            onPressed: () {
              setState(() {
                showOtpField = false;
                otpController.clear();
              });
            },
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
            onPressed: () {
              // OTP verify logic
            },
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

  Widget _buildInputSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          isPhoneSelected ? "Enter Phone Number" : "Enter Email Address",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          isPhoneSelected
              ? "You'll receive a 6 digit code on your phone"
              : "You'll receive a 6 digit code on your email",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        _buildInputField(),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: sendCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Send Code",
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
              // const SizedBox(height: 10),
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 16),
              // Card container
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
                    _buildOptionSelector(),
                    showOtpField ? _buildOtpSection() : _buildInputSection(),
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
