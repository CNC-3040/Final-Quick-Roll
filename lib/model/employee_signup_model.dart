import 'package:flutter/material.dart';

class EmployeeSignupModel extends ChangeNotifier {
  String name = '';
  String designation = '';
  String dob = '';
  String email = '';
  String contact = '';
  String password = '';
  String address = '';
  String documentImage = '';
  String photoPath = '';
  String? nameError;
  String? designationError;
  String? dobError;
  String? emailError;
  String? contactError;
  String? passwordError;
  String? addressError;
  String? documentImageError;
  String? photoPathError;
  String? apiError;
  int screenIndex = 0;

  void setValue(String field, String value) {
    switch (field) {
      case 'name':
        name = value;
        break;
      case 'designation':
        designation = value;
        break;
      case 'dob':
        dob = value;
        break;
      case 'email':
        email = value;
        break;
      case 'contact':
        contact = value;
        break;
      case 'password':
        password = value;
        break;
      case 'address':
        address = value;
        break;
      case 'documentImage':
        documentImage = value;
        break;
      case 'photoPath':
        photoPath = value;
        break;
    }
    notifyListeners();
  }

  void setScreenIndex(int index) {
    screenIndex = index;
    notifyListeners();
  }

  double getGreenStripWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (screenIndex / 7);
  }

  bool validateName() {
    if (name.isEmpty) {
      nameError = 'Name is required';
      notifyListeners();
      return false;
    } else if (name.length < 2) {
      nameError = 'Name must be at least 2 characters';
      notifyListeners();
      return false;
    }
    nameError = null;
    notifyListeners();
    return true;
  }

  bool validateDesignation() {
    if (designation.isEmpty) {
      designationError = 'Designation is required';
      notifyListeners();
      return false;
    }
    designationError = null;
    notifyListeners();
    return true;
  }

  bool validateDOB() {
    if (dob.isEmpty) {
      dobError = 'Date of Birth is required';
      notifyListeners();
      return false;
    }
    final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!datePattern.hasMatch(dob)) {
      dobError = 'Enter date in YYYY-MM-DD format';
      notifyListeners();
      return false;
    }
    try {
      final date = DateTime.parse(dob);
      final now = DateTime.now();
      if (date.isAfter(now)) {
        dobError = 'Date of Birth cannot be in the future';
        notifyListeners();
        return false;
      }
    } catch (e) {
      dobError = 'Invalid date format';
      notifyListeners();
      return false;
    }
    dobError = null;
    notifyListeners();
    return true;
  }

  bool validateEmail() {
    if (email.isEmpty) {
      emailError = 'Email is required';
      notifyListeners();
      return false;
    }
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailPattern.hasMatch(email)) {
      emailError = 'Enter a valid email address';
      notifyListeners();
      return false;
    }
    emailError = null;
    notifyListeners();
    return true;
  }

  bool validateContact() {
    if (contact.isEmpty) {
      contactError = 'Contact number is required';
      notifyListeners();
      return false;
    }
    final contactPattern = RegExp(r'^\+?[\d\s-]{10,}$');
    if (!contactPattern.hasMatch(contact)) {
      contactError = 'Enter a valid contact number';
      notifyListeners();
      return false;
    }
    contactError = null;
    notifyListeners();
    return true;
  }

  bool validatePassword() {
    if (password.isEmpty) {
      passwordError = 'Password is required';
      notifyListeners();
      return false;
    }
    if (password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
      notifyListeners();
      return false;
    }
    passwordError = null;
    notifyListeners();
    return true;
  }

  bool validateAddress() {
    if (address.isEmpty) {
      addressError = null;
      notifyListeners();
      return true; // Address is optional
    }
    if (address.length < 5) {
      addressError = 'Address must be at least 5 characters';
      notifyListeners();
      return false;
    }
    addressError = null;
    notifyListeners();
    return true;
  }

  bool validateDocuments() {
    if (documentImage.isEmpty) {
      documentImageError = 'Document image is required';
      notifyListeners();
      return false;
    }
    if (photoPath.isEmpty) {
      photoPathError = 'Photo is required';
      notifyListeners();
      return false;
    }
    documentImageError = null;
    photoPathError = null;
    notifyListeners();
    return true;
  }

  Future<bool> registerEmployee(BuildContext context) async {
    // Placeholder for API call
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      apiError = null;
      notifyListeners();
      return true;
    } catch (e) {
      apiError = 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
