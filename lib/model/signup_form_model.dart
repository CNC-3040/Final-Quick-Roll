import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignupFormModel extends ChangeNotifier {
  // Form fields
  String userName = '';
  String category = '';
  String email = '';
  String contactNo = '';
  String password = '';
  String ownerName = '';
  String businessAddress = '';
  String website = '';

  // Validation errors
  String? userNameError;
  String? categoryError;
  String? emailError;
  String? contactNoError;
  String? passwordError;
  String? ownerNameError;
  String? businessAddressError;
  String? websiteError;
  String? apiError;

  // Progress tracking
  int currentScreenIndex = 0;
  final int totalScreens = 8;

  double getGreenStripWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (currentScreenIndex + 1) / totalScreens;
  }

  void setScreenIndex(int index) {
    currentScreenIndex = index;
    notifyListeners();
  }

  // Validation methods
  bool validateUserName() {
    if (userName.isEmpty) {
      userNameError = 'Business name is required';
      notifyListeners();
      return false;
    }
    userNameError = null;
    notifyListeners();
    return true;
  }

  bool validateCategory() {
    if (category.isEmpty) {
      categoryError = 'Category is required';
      notifyListeners();
      return false;
    }
    categoryError = null;
    notifyListeners();
    return true;
  }

  bool validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      emailError = 'Email is required';
      notifyListeners();
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      emailError = 'Enter a valid email';
      notifyListeners();
      return false;
    }
    emailError = null;
    notifyListeners();
    return true;
  }

  bool validateContactNo() {
    final contactRegex = RegExp(r'^\d{10}$'); // Assuming 10-digit phone number
    if (contactNo.isEmpty) {
      contactNoError = 'Contact number is required';
      notifyListeners();
      return false;
    } else if (!contactRegex.hasMatch(contactNo)) {
      contactNoError = 'Enter a valid 10-digit number';
      notifyListeners();
      return false;
    }
    contactNoError = null;
    notifyListeners();
    return true;
  }

  bool validatePassword() {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (password.isEmpty) {
      passwordError = 'Password is required';
      notifyListeners();
      return false;
    } else if (!passwordRegex.hasMatch(password)) {
      passwordError =
          'Password must be 8+ characters with uppercase, lowercase, number, and special character';
      notifyListeners();
      return false;
    }
    passwordError = null;
    notifyListeners();
    return true;
  }

  bool validateOwnerName() {
    if (ownerName.isEmpty) {
      ownerNameError = null;
      notifyListeners();
      return true; // Optional field
    }
    final ownerNameRegex = RegExp(r'^[A-Za-z]+\s[A-Za-z]+$');
    if (!ownerNameRegex.hasMatch(ownerName)) {
      ownerNameError = 'Enter two words (e.g., John Smith)';
      notifyListeners();
      return false;
    }
    ownerNameError = null;
    notifyListeners();
    return true;
  }

  bool validateBusinessAddress() {
    businessAddressError = null;
    notifyListeners();
    return true; // Optional field
  }

  bool validateWebsite() {
    if (website.isEmpty) {
      websiteError = null;
      notifyListeners();
      return true; // Optional field
    }
    final urlRegex = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    if (!urlRegex.hasMatch(website)) {
      websiteError = 'Enter a valid URL (e.g., https://example.com)';
      notifyListeners();
      return false;
    }
    websiteError = null;
    notifyListeners();
    return true;
  }

  // API call to register company
  Future<bool> registerCompany(BuildContext context) async {
    apiError = null;
    notifyListeners();

    final url = Uri.parse('https://qr.albsocial.in/api/company-infos');
    final payload = {
      'user_name': userName,
      'email_id': email,
      'password': password,
      'contact_no': contactNo,
      'category': category,
      if (ownerName.isNotEmpty) 'owner_name': ownerName,
      if (businessAddress.isNotEmpty) 'business_address': businessAddress,
      if (website.isNotEmpty) 'website': website,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 422) {
        final errors =
            jsonDecode(response.body)['errors'] as Map<String, dynamic>;
        apiError = errors.entries
            .map((e) => e.value.map((msg) => msg as String).join(', '))
            .join('; ');
        notifyListeners();
        return false;
      } else {
        apiError = 'Registration failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      apiError = 'Network error: $e';
      notifyListeners();
      return false;
    }
  }
}
