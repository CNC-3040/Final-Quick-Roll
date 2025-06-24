// import 'package:flutter/material.dart';

// class EmployeeSignupModel extends ChangeNotifier {
//   String name = '';
//   String designation = '';
//   String dob = '';
//   String email = '';
//   String contact = '';
//   String password = '';
//   String address = '';
//   String documentImage = '';
//   String photoPath = '';
//   String? nameError;
//   String? designationError;
//   String? dobError;
//   String? emailError;
//   String? contactError;
//   String? passwordError;
//   String? addressError;
//   String? documentImageError;
//   String? photoPathError;
//   String? apiError;
//   int screenIndex = 0;

//   void setValue(String field, String value) {
//     switch (field) {
//       case 'name':
//         name = value;
//         break;
//       case 'designation':
//         designation = value;
//         break;
//       case 'dob':
//         dob = value;
//         break;
//       case 'email':
//         email = value;
//         break;
//       case 'contact':
//         contact = value;
//         break;
//       case 'password':
//         password = value;
//         break;
//       case 'address':
//         address = value;
//         break;
//       case 'documentImage':
//         documentImage = value;
//         break;
//       case 'photoPath':
//         photoPath = value;
//         break;
//     }
//     notifyListeners();
//   }

//   void setScreenIndex(int index) {
//     screenIndex = index;
//     notifyListeners();
//   }

//   double getGreenStripWidth(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return screenWidth * (screenIndex / 7);
//   }

//   bool validateName() {
//     if (name.isEmpty) {
//       nameError = 'Name is required';
//       notifyListeners();
//       return false;
//     } else if (name.length < 2) {
//       nameError = 'Name must be at least 2 characters';
//       notifyListeners();
//       return false;
//     }
//     nameError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDesignation() {
//     if (designation.isEmpty) {
//       designationError = 'Designation is required';
//       notifyListeners();
//       return false;
//     }
//     designationError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDOB() {
//     if (dob.isEmpty) {
//       dobError = 'Date of Birth is required';
//       notifyListeners();
//       return false;
//     }
//     final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
//     if (!datePattern.hasMatch(dob)) {
//       dobError = 'Enter date in YYYY-MM-DD format';
//       notifyListeners();
//       return false;
//     }
//     try {
//       final date = DateTime.parse(dob);
//       final now = DateTime.now();
//       if (date.isAfter(now)) {
//         dobError = 'Date of Birth cannot be in the future';
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       dobError = 'Invalid date format';
//       notifyListeners();
//       return false;
//     }
//     dobError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateEmail() {
//     if (email.isEmpty) {
//       emailError = 'Email is required';
//       notifyListeners();
//       return false;
//     }
//     final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailPattern.hasMatch(email)) {
//       emailError = 'Enter a valid email address';
//       notifyListeners();
//       return false;
//     }
//     emailError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateContact() {
//     if (contact.isEmpty) {
//       contactError = 'Contact number is required';
//       notifyListeners();
//       return false;
//     }
//     final contactPattern = RegExp(r'^\+?[\d\s-]{10,}$');
//     if (!contactPattern.hasMatch(contact)) {
//       contactError = 'Enter a valid contact number';
//       notifyListeners();
//       return false;
//     }
//     contactError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validatePassword() {
//     if (password.isEmpty) {
//       passwordError = 'Password is required';
//       notifyListeners();
//       return false;
//     }
//     if (password.length < 8) {
//       passwordError = 'Password must be at least 8 characters';
//       notifyListeners();
//       return false;
//     }
//     passwordError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateAddress() {
//     if (address.isEmpty) {
//       addressError = null;
//       notifyListeners();
//       return true; // Address is optional
//     }
//     if (address.length < 5) {
//       addressError = 'Address must be at least 5 characters';
//       notifyListeners();
//       return false;
//     }
//     addressError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDocuments() {
//     if (documentImage.isEmpty) {
//       documentImageError = 'Document image is required';
//       notifyListeners();
//       return false;
//     }
//     if (photoPath.isEmpty) {
//       photoPathError = 'Photo is required';
//       notifyListeners();
//       return false;
//     }
//     documentImageError = null;
//     photoPathError = null;
//     notifyListeners();
//     return true;
//   }

//   Future<bool> registerEmployee(BuildContext context) async {
//     // Placeholder for API call
//     try {
//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 1));
//       apiError = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       apiError = 'Registration failed. Please try again.';
//       notifyListeners();
//       return false;
//     }
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class EmployeeSignupModel extends ChangeNotifier {
//   String companyId = '';
//   String name = '';
//   String designation = '';
//   String dob = '';
//   String email = '';
//   String contact = '';
//   String password = '';
//   String address = '';
//   String documentImage = '';
//   String photoPath = '';
//   String? companyIdError;
//   String? nameError;
//   String? designationError;
//   String? dobError;
//   String? emailError;
//   String? contactError;
//   String? passwordError;
//   String? addressError;
//   String? documentImageError;
//   String? photoPathError;
//   String? apiError;
//   int screenIndex = 0;

//   void setValue(String field, String value) {
//     switch (field) {
//       case 'companyId':
//         companyId = value;
//         break;
//       case 'name':
//         name = value;
//         break;
//       case 'designation':
//         designation = value;
//         break;
//       case 'dob':
//         dob = value;
//         break;
//       case 'email':
//         email = value;
//         break;
//       case 'contact':
//         contact = value;
//         break;
//       case 'password':
//         password = value;
//         break;
//       case 'address':
//         address = value;
//         break;
//       case 'documentImage':
//         documentImage = value;
//         break;
//       case 'photoPath':
//         photoPath = value;
//         break;
//     }
//     notifyListeners();
//   }

//   void setScreenIndex(int index) {
//     screenIndex = index;
//     notifyListeners();
//   }

//   double getGreenStripWidth(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return screenWidth * (screenIndex / 8);
//   }

//   bool validateCompanyId() {
//     if (companyId.isEmpty) {
//       companyIdError = 'Company ID is required';
//       notifyListeners();
//       return false;
//     }
//     final idPattern = RegExp(r'^\d+$');
//     if (!idPattern.hasMatch(companyId)) {
//       companyIdError = 'Company ID must be a valid integer';
//       notifyListeners();
//       return false;
//     }
//     companyIdError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateName() {
//     if (name.isEmpty) {
//       nameError = 'Name is required';
//       notifyListeners();
//       return false;
//     } else if (name.length < 2) {
//       nameError = 'Name must be at least 2 characters';
//       notifyListeners();
//       return false;
//     }
//     nameError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDesignation() {
//     if (designation.isEmpty) {
//       designationError = 'Designation is required';
//       notifyListeners();
//       return false;
//     }
//     designationError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDOB() {
//     if (dob.isEmpty) {
//       dobError = 'Date of Birth is required';
//       notifyListeners();
//       return false;
//     }
//     final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
//     if (!datePattern.hasMatch(dob)) {
//       dobError = 'Enter date in YYYY-MM-DD format';
//       notifyListeners();
//       return false;
//     }
//     try {
//       final date = DateTime.parse(dob);
//       final now = DateTime.now();
//       if (date.isAfter(now)) {
//         dobError = 'Date of Birth cannot be in the future';
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       dobError = 'Invalid date format';
//       notifyListeners();
//       return false;
//     }
//     dobError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateEmail() {
//     if (email.isEmpty) {
//       emailError = 'Email is required';
//       notifyListeners();
//       return false;
//     }
//     final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailPattern.hasMatch(email)) {
//       emailError = 'Enter a valid email address';
//       notifyListeners();
//       return false;
//     }
//     emailError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateContact() {
//     if (contact.isEmpty) {
//       contactError = 'Contact number is required';
//       notifyListeners();
//       return false;
//     }
//     final contactPattern = RegExp(r'^\+?[\d\s-]{10,}$');
//     if (!contactPattern.hasMatch(contact)) {
//       contactError = 'Enter a valid contact number';
//       notifyListeners();
//       return false;
//     }
//     contactError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validatePassword() {
//     if (password.isEmpty) {
//       passwordError = 'Password is required';
//       notifyListeners();
//       return false;
//     }
//     if (password.length < 6) {
//       passwordError = 'Password must be at least 6 characters';
//       notifyListeners();
//       return false;
//     }
//     passwordError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateAddress() {
//     if (address.isEmpty) {
//       addressError = null;
//       notifyListeners();
//       return true; // Address is optional
//     }
//     if (address.length < 5) {
//       addressError = 'Address must be at least 5 characters';
//       notifyListeners();
//       return false;
//     }
//     addressError = null;
//     notifyListeners();
//     return true;
//   }

//   bool validateDocuments() {
//     documentImageError = null;
//     photoPathError = null;
//     notifyListeners();
//     return true;
//   }

//   Future<String> _convertImageToBase64(XFile image) async {
//     final bytes = await File(image.path).readAsBytes();
//     return 'data:image/png;base64,${base64Encode(bytes)}';
//   }

//   Future<void> pickImage(String field, ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: source,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );
//     if (pickedFile != null) {
//       final base64Image = await _convertImageToBase64(pickedFile);
//       setValue(field, base64Image);
//       validateDocuments();
//     }
//   }

//   Future<bool> registerEmployee(BuildContext context) async {
//     if (!validateCompanyId() ||
//         !validateName() ||
//         !validateDesignation() ||
//         !validateDOB() ||
//         !validateEmail() ||
//         !validateContact() ||
//         !validatePassword() ||
//         !validateAddress() ||
//         !validateDocuments()) {
//       apiError = 'Please fix all errors before submitting';
//       notifyListeners();
//       return false;
//     }

//     try {
//       final url = Uri.parse('https://qr.albsocial.in/api/add-employees');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'company_id': companyId,
//           'name': name,
//           'dob': dob,
//           'email': email,
//           'password': password,
//           'contact': contact.isEmpty ? null : contact,
//           'designation': designation.isEmpty ? null : designation,
//           'address': address.isEmpty ? null : address,
//           'document_image': documentImage.isEmpty ? null : documentImage,
//           'photo_path': photoPath.isEmpty ? null : photoPath,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         if (responseData['status'] == 'success') {
//           apiError = null;
//           notifyListeners();
//           return true;
//         } else {
//           apiError = responseData['message'] ?? 'Registration failed';
//           notifyListeners();
//           return false;
//         }
//       } else if (response.statusCode == 422) {
//         final responseData = jsonDecode(response.body);
//         apiError = responseData['errors'].toString();
//         notifyListeners();
//         return false;
//       } else {
//         apiError = 'Server error: ${response.statusCode}';
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       apiError = 'Network error: $e';
//       notifyListeners();
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quick_roll/admin/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSignupModel extends ChangeNotifier {
  String companyId = '';
  String name = '';
  String designation = '';
  String dob = '';
  String email = '';
  String contact = '';
  String password = '';
  String address = '';
  String documentImage = '';
  String photoPath = '';
  String? companyIdError;
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

  EmployeeSignupModel() {
    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final companyIdFromPrefs = await AuthService.getLoggedInUserCompanyId();
    if (companyIdFromPrefs != null) {
      companyId = companyIdFromPrefs;
      notifyListeners();
    }
  }

  void setValue(String field, String value) {
    switch (field) {
      case 'companyId':
        companyId = value;
        break;
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
    return screenWidth * (screenIndex / 7); // Adjusted for 7 screens
  }

  bool validateCompanyId() {
    if (companyId.isEmpty) {
      companyIdError = 'Company ID is required';
      notifyListeners();
      return false;
    }
    final idPattern = RegExp(r'^\d+$');
    if (!idPattern.hasMatch(companyId)) {
      companyIdError = 'Company ID must be a valid integer';
      notifyListeners();
      return false;
    }
    companyIdError = null;
    notifyListeners();
    return true;
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
    if (password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
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
      return true;
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
    documentImageError = null;
    photoPathError = null;
    notifyListeners();
    return true;
  }

  Future<String> _convertImageToBase64(XFile image) async {
    final bytes = await File(image.path).readAsBytes();
    return 'data:image/png;base64,${base64Encode(bytes)}';
  }

  Future<void> pickImage(String field, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final base64Image = await _convertImageToBase64(pickedFile);
      setValue(field, base64Image);
      validateDocuments();
    }
  }

  Future<bool> registerEmployee(BuildContext context) async {
    if (!validateName() ||
        !validateDesignation() ||
        !validateDOB() ||
        !validateEmail() ||
        !validateContact() ||
        !validatePassword() ||
        !validateAddress() ||
        !validateDocuments()) {
      apiError = 'Please fix all errors before submitting';
      notifyListeners();
      return false;
    }

    try {
      final url = Uri.parse('https://qr.albsocial.in/api/add-employees');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'company_id': companyId,
          'name': name,
          'dob': dob,
          'email': email,
          'password': password,
          'contact': contact.isEmpty ? null : contact,
          'designation': designation.isEmpty ? null : designation,
          'address': address.isEmpty ? null : address,
          'document_image': documentImage.isEmpty ? null : documentImage,
          'photo_path': photoPath.isEmpty ? null : photoPath,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          apiError = null;
          notifyListeners();
          return true;
        } else {
          apiError = responseData['message'] ?? 'Registration failed';
          notifyListeners();
          return false;
        }
      } else if (response.statusCode == 422) {
        final responseData = jsonDecode(response.body);
        apiError = responseData['errors'].toString();
        notifyListeners();
        return false;
      } else {
        apiError = 'Server error: ${response.statusCode}';
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
