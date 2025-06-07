// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/image_upload.dart';
// import 'package:quick_roll/widgets/password.dart';
// import 'package:flutter/services.dart';

// class Employee {
//   String? name;
//   DateTime? dob;
//   String? email;
//   String? password;
//   String? pan;
//   String? aadhaar;
//   String? contact;
//   String? alternateContact;
//   String? designation;
//   String? salary;
//   DateTime? joiningDate;
//   String? address;
//   String? photoPath;
//   final int? companyId;

//   Employee({
//     this.name,
//     this.dob,
//     this.email,
//     this.password,
//     this.pan,
//     this.aadhaar,
//     this.contact,
//     this.alternateContact,
//     this.designation,
//     this.salary,
//     this.joiningDate,
//     this.address,
//     this.photoPath,
//     required this.companyId,
//   });

//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       companyId: json['company_id'] != null
//           ? (json['company_id'] is int
//               ? json['company_id']
//               : int.tryParse(json['company_id'].toString()) ?? global_cid)
//           : global_cid,
//       name: json['name']?.toString(),
//       dob: json['dob'] != null
//           ? DateTime.tryParse(json['dob'].toString())
//           : null,
//       email: json['email']?.toString(),
//       password: json['password']?.toString(),
//       pan: json['pan']?.toString(),
//       aadhaar: json['aadhaar']?.toString(),
//       contact: json['contact']?.toString(),
//       alternateContact: json['alternate_contact']?.toString(),
//       designation: json['designation']?.toString(),
//       salary: json['salary']?.toString(),
//       joiningDate: json['joining_date'] != null
//           ? DateTime.tryParse(json['joining_date'].toString())
//           : null,
//       address: json['address']?.toString(),
//       photoPath: json['photo_path']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'company_id': companyId,
//       'name': name,
//       'dob': dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : null,
//       'email': email,
//       'password': password,
//       'pan': pan,
//       'aadhaar': aadhaar,
//       'contact': contact,
//       'alternate_contact': alternateContact ?? '',
//       'designation': designation,
//       'salary': salary,
//       'joining_date': joiningDate != null
//           ? DateFormat('yyyy-MM-dd').format(joiningDate!)
//           : null,
//       'address': address,
//       'photo_path': photoPath ?? '',
//     }..removeWhere((key, value) => value == null || value == '');
//   }
// }

// class CapitalizeFirstFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final text = newValue.text;
//     if (text.isEmpty) {
//       return newValue;
//     }
//     final formattedText =
//         text[0].toUpperCase() + text.substring(1).toLowerCase();
//     return TextEditingValue(
//       text: formattedText,
//       selection: newValue.selection,
//     );
//   }
// }

// class EmployeeService {
//   static const String _baseUrl = 'https://qr.albsocial.in/api/add-employees';

//   static Future<Employee> register(Employee employee) async {
//     try {
//       final jsonData = employee.toJson();
//       debugPrint('📤 Sending Employee Data: ${jsonEncode(jsonData)}');

//       final url = Uri.parse(_baseUrl);
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(jsonData),
//       );

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         try {
//           final responseBody = jsonDecode(response.body);
//           if (responseBody is Map<String, dynamic>) {
//             return Employee.fromJson(responseBody);
//           } else {
//             debugPrint(
//                 '⚠️ Unexpected response format, but registration succeeded');
//             return employee;
//           }
//         } catch (e) {
//           debugPrint('⚠️ JSON Parse Error: $e');
//           return employee;
//         }
//       } else {
//         String errorMessage = 'Failed to register employee';
//         try {
//           final errorResponse = jsonDecode(response.body);
//           if (errorResponse is Map<String, dynamic> &&
//               errorResponse['message'] != null) {
//             errorMessage = errorResponse['message'];
//           }
//         } catch (_) {
//           errorMessage = 'Server error: ${response.statusCode}';
//         }
//         throw Exception(errorMessage);
//       }
//     } catch (e) {
//       debugPrint('❌ Error: $e');
//       rethrow;
//     }
//   }
// }

// class AadhaarInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final rawText = newValue.text.replaceAll(' ', '');
//     if (rawText.length > 12) return oldValue;
//     final buffer = StringBuffer();
//     for (int i = 0; i < rawText.length; i++) {
//       if (i > 0 && i % 4 == 0) buffer.write(' ');
//       buffer.write(rawText[i]);
//     }
//     return TextEditingValue(
//       text: buffer.toString(),
//       selection: TextSelection.collapsed(offset: buffer.length),
//     );
//   }
// }

// class DateInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final rawText = newValue.text.replaceAll('-', '');
//     if (rawText.length > 8) return oldValue;
//     final buffer = StringBuffer();
//     for (int i = 0; i < rawText.length; i++) {
//       if (i == 4 || i == 6) buffer.write('-');
//       buffer.write(rawText[i]);
//     }
//     return TextEditingValue(
//       text: buffer.toString(),
//       selection: TextSelection.collapsed(offset: buffer.length),
//     );
//   }
// }

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController panController = TextEditingController();
//   final TextEditingController aadhaarController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController alternateContactController =
//       TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final TextEditingController salaryController = TextEditingController();
//   final TextEditingController joiningDateController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   String? photoPath;
//   bool isLoading = false;

//   @override
//   void dispose() {
//     nameController.dispose();
//     dobController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     panController.dispose();
//     aadhaarController.dispose();
//     contactController.dispose();
//     alternateContactController.dispose();
//     designationController.dispose();
//     salaryController.dispose();
//     joiningDateController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   void _clearForm() {
//     nameController.clear();
//     dobController.clear();
//     emailController.clear();
//     passwordController.clear();
//     panController.clear();
//     aadhaarController.clear();
//     contactController.clear();
//     alternateContactController.clear();
//     designationController.clear();
//     salaryController.clear();
//     joiningDateController.clear();
//     addressController.clear();
//     setState(() {
//       photoPath = null;
//     });
//     _formKey.currentState?.reset();
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => isLoading = true);
//       try {
//         final employee = Employee(
//           companyId: global_cid,
//           name: nameController.text.trim(),
//           dob: DateTime.tryParse(dobController.text),
//           email: emailController.text.trim(),
//           password: passwordController.text,
//           pan: panController.text.trim().toUpperCase(),
//           aadhaar: aadhaarController.text.replaceAll(' ', ''),
//           contact: contactController.text.trim(),
//           alternateContact: alternateContactController.text.trim().isEmpty
//               ? null
//               : alternateContactController.text.trim(),
//           designation: designationController.text,
//           salary: salaryController.text.trim(),
//           joiningDate: DateTime.tryParse(joiningDateController.text),
//           address: addressController.text.trim(),
//           photoPath: photoPath,
//         );

//         await EmployeeService.register(employee);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Employee registered successfully')),
//           );
//           _clearForm(); // Clear the form after successful registration
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Registration failed: $e')),
//           );
//         }
//       } finally {
//         if (mounted) setState(() => isLoading = false);
//       }
//     }
//   }

//   Future<void> _pickDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: AppColors.slateTeal,
//               onPrimary: AppColors.white,
//               onSurface: AppColors.charcoalGray,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       controller.text = DateFormat('yyyy-MM-dd').format(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Employee Registration',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.white, AppColors.lightSkyBlue],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//             child: Card(
//               elevation: 8,
//               color: AppColors.babyBlue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           'Create Employee Account',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.slateTeal,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       _buildTextField(
//                         controller: nameController,
//                         label: 'Full Name',
//                         icon: Icons.person,
//                         validator: (value) =>
//                             value!.isEmpty ? 'Name is required' : null,
//                       ),
//                       _buildTextField(
//                         controller: dobController,
//                         label: 'Date of Birth (yyyy-mm-dd)',
//                         icon: Icons.cake,
//                         keyboardType: TextInputType.datetime,
//                         inputFormatters: [
//                           DateInputFormatter(),
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty)
//                             return 'Date of Birth is required';
//                           if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
//                             return 'Enter DOB in yyyy-mm-dd format';
//                           }
//                           try {
//                             DateTime.parse(value);
//                           } catch (e) {
//                             return 'Invalid date format';
//                           }
//                           return null;
//                         },
//                         onTap: () => _pickDate(dobController),
//                       ),
//                       _buildTextField(
//                         controller: emailController,
//                         label: 'Email',
//                         icon: Icons.email,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value!.isEmpty) return 'Email is required';
//                           if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       PasswordTextBox(
//                         controller: passwordController,
//                         onChanged: (value) {},
//                         decoration: _buildInputDecoration(
//                           label: 'Password',
//                           icon: Icons.lock,
//                         ),
//                         // If PasswordTextBox supports validator, uncomment below and remove this comment:
//                         // validator: (value) {
//                         //   if (value!.isEmpty) return 'Password is required';
//                         //   if (value.length < 6) return 'Password must be at least 6 characters';
//                         //   return null;
//                         // },
//                       ),
//                       _buildTextField(
//                         controller: panController,
//                         label: 'PAN',
//                         icon: Icons.credit_card,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(10),
//                           FilteringTextInputFormatter.allow(
//                               RegExp(r'[A-Za-z0-9]')),
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty) return 'PAN is required';
//                           if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
//                               .hasMatch(value)) {
//                             return 'Enter a valid PAN (e.g., ABCDE1234F)';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: aadhaarController,
//                         label: 'Aadhaar',
//                         icon: Icons.fingerprint,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           AadhaarInputFormatter(),
//                           LengthLimitingTextInputFormatter(14),
//                         ],
//                         validator: (value) {
//                           final rawValue = value!.replaceAll(' ', '');
//                           if (rawValue.isEmpty) return 'Aadhaar is required';
//                           if (rawValue.length != 12)
//                             return 'Aadhaar must be 12 digits';
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: contactController,
//                         label: 'Contact Number',
//                         icon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty)
//                             return 'Contact Number is required';
//                           if (value.length != 10)
//                             return 'Enter a valid 10-digit number';
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: alternateContactController,
//                         label: 'Alternate Contact Number (Optional)',
//                         icon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                         validator: (value) =>
//                             value!.isNotEmpty && value.length != 10
//                                 ? 'Enter a valid 10-digit number'
//                                 : null,
//                       ),
//                       _buildTextField(
//                         controller: designationController,
//                         label: 'Designation',
//                         icon: Icons.work,
//                         inputFormatters: [
//                           CapitalizeFirstFormatter(),
//                           LengthLimitingTextInputFormatter(17),
//                         ],
//                         validator: (value) =>
//                             value!.isEmpty ? 'Designation is required' : null,
//                       ),
//                       _buildTextField(
//                         controller: salaryController,
//                         label: 'Salary',
//                         icon: Icons.money,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty) return 'Salary is required';
//                           if (int.tryParse(value) == null ||
//                               int.parse(value) <= 0) {
//                             return 'Enter a valid salary';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: joiningDateController,
//                         label: 'Joining Date (yyyy-mm-dd)',
//                         icon: Icons.calendar_today,
//                         keyboardType: TextInputType.datetime,
//                         inputFormatters: [
//                           DateInputFormatter(),
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                         validator: (value) {
//                           if (value!.isEmpty) return 'Joining Date is required';
//                           if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
//                             return 'Enter Joining Date in yyyy-mm-dd format';
//                           }
//                           try {
//                             DateTime.parse(value);
//                           } catch (e) {
//                             return 'Invalid date format';
//                           }
//                           return null;
//                         },
//                         onTap: () => _pickDate(joiningDateController),
//                       ),
//                       _buildTextField(
//                         controller: addressController,
//                         label: 'Address',
//                         icon: Icons.home,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: 3,
//                         validator: (value) =>
//                             value!.isEmpty ? 'Address is required' : null,
//                       ),
//                       const SizedBox(height: 16),
//                       Center(
//                         child: ElevatedButton.icon(
//                           onPressed: () async {
//                             photoPath = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ImageUpload(
//                                   onImageUploaded: () => setState(() {}),
//                                 ),
//                               ),
//                             );
//                             if (photoPath != null) setState(() {});
//                           },
//                           icon: const Icon(Icons.upload_file,
//                               color: AppColors.white),
//                           label: Text(
//                             photoPath == null
//                                 ? 'Upload Photo'
//                                 : 'Photo Uploaded',
//                             style: const TextStyle(color: AppColors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.slateTeal,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 24, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Center(
//                         child: isLoading
//                             ? const CircularProgressIndicator(
//                                 color: AppColors.slateTeal,
//                               )
//                             : ElevatedButton(
//                                 onPressed: _submitForm,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.slateTeal,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 40, vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Register',
//                                   style: TextStyle(
//                                     color: AppColors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration(
//       {required String label, required IconData icon}) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: AppColors.charcoalGray),
//       prefixIcon: Icon(icon, color: AppColors.slateTeal),
//       focusedBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: AppColors.slateTeal, width: 2),
//       ),
//       enabledBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: AppColors.slateTeal),
//       ),
//       errorBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: Colors.red, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//     VoidCallback? onTap,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         decoration: _buildInputDecoration(label: label, icon: icon),
//         keyboardType: keyboardType,
//         inputFormatters: inputFormatters,
//         validator: validator,
//         style: const TextStyle(color: AppColors.charcoalGray),
//         cursorColor: AppColors.slateTeal,
//         maxLines: maxLines,
//         onTap: onTap,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quick_roll/services/global.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/image_upload.dart';
import 'package:quick_roll/widgets/password.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Employee {
  String? name;
  DateTime? dob;
  String? email;
  String? password;
  String? bloodGroup;
  String? pan;
  String? aadhaar;
  String? contact;
  String? alternateContact;
  String? designation;
  String? salary;
  String? ta;
  String? da;
  String? hra;
  DateTime? joiningDate;
  String? address;
  String? photoPath;
  final int? companyId;

  Employee({
    this.name,
    this.dob,
    this.email,
    this.password,
    this.bloodGroup,
    this.pan,
    this.aadhaar,
    this.contact,
    this.alternateContact,
    this.designation,
    this.salary,
    this.ta,
    this.da,
    this.hra,
    this.joiningDate,
    this.address,
    this.photoPath,
    required this.companyId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      companyId: json['company_id'] != null
          ? (json['company_id'] is int
              ? json['company_id']
              : int.tryParse(json['company_id'].toString()) ?? global_cid)
          : global_cid,
      name: json['name']?.toString(),
      dob: json['dob'] != null
          ? DateTime.tryParse(json['dob'].toString())
          : null,
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      pan: json['pan']?.toString(),
      aadhaar: json['aadhaar']?.toString(),
      contact: json['contact']?.toString(),
      alternateContact: json['alternate_contact']?.toString(),
      designation: json['designation']?.toString(),
      salary: json['salary']?.toString(),
      ta: json['TA']?.toString(),
      da: json['DA']?.toString(),
      hra: json['HRA']?.toString(),
      joiningDate: json['joining_date'] != null
          ? DateTime.tryParse(json['joining_date'].toString())
          : null,
      address: json['address']?.toString(),
      photoPath: json['photo_path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'name': name,
      'dob': dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : null,
      'email': email,
      'password': password,
      'blood_group': bloodGroup ?? '',
      'pan': pan,
      'aadhaar': aadhaar,
      'contact': contact,
      'alternate_contact': alternateContact ?? '',
      'designation': designation,
      'salary': salary,
      'TA': ta ?? '0',
      'DA': da ?? '0',
      'HRA': hra ?? '0',
      'joining_date': joiningDate != null
          ? DateFormat('yyyy-MM-dd').format(joiningDate!)
          : null,
      'address': address,
      'photo_path': photoPath ?? '',
    }..removeWhere((key, value) => value == null || value == '');
  }
}

class CapitalizeFirstFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    final formattedText =
        text[0].toUpperCase() + text.substring(1).toLowerCase();
    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}

class EmployeeService {
  static const String _baseUrl = 'https://qr.albsocial.in/api/add-employees';

  static Future<Employee> register(Employee employee) async {
    try {
      final jsonData = employee.toJson();
      debugPrint('📤 Sending Employee Data: ${jsonEncode(jsonData)}');

      final url = Uri.parse(_baseUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map<String, dynamic> &&
              responseBody['employee'] != null) {
            return Employee.fromJson(responseBody['employee']);
          } else {
            debugPrint(
                '⚠️ Unexpected response format, but registration succeeded');
            return employee;
          }
        } catch (e) {
          debugPrint('⚠️ JSON Parse Error: $e');
          return employee;
        }
      } else {
        String errorMessage = 'Failed to register employee';
        try {
          final errorResponse = jsonDecode(response.body);
          if (errorResponse is Map<String, dynamic> &&
              errorResponse['errors'] != null) {
            final errors = errorResponse['errors'] as Map<String, dynamic>;
            errorMessage = errors.values.join(', ');
          } else if (errorResponse['message'] != null) {
            errorMessage = errorResponse['message'];
          }
        } catch (_) {
          errorMessage = 'Server error: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      rethrow;
    }
  }
}

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(' ', '');
    if (rawText.length > 12) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(rawText[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll('-', '');
    if (rawText.length > 8) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if (i == 4 || i == 6) buffer.write('-');
      buffer.write(rawText[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController alternateContactController =
      TextEditingController();
  String? selectedDesignation;
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController taController = TextEditingController();
  final TextEditingController daController = TextEditingController();
  final TextEditingController hraController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? photoPath;
  bool isLoading = false;
  List<String> designations = [];

  @override
  void initState() {
    super.initState();
    _loadDesignations();
  }

  Future<void> _loadDesignations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDesignations = prefs.getString('designations');
    if (storedDesignations != null) {
      setState(() {
        designations = List<String>.from(jsonDecode(storedDesignations));
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bloodGroupController.dispose();
    panController.dispose();
    aadhaarController.dispose();
    contactController.dispose();
    alternateContactController.dispose();
    salaryController.dispose();
    taController.dispose();
    daController.dispose();
    hraController.dispose();
    joiningDateController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _clearForm() {
    nameController.clear();
    dobController.clear();
    emailController.clear();
    passwordController.clear();
    bloodGroupController.clear();
    panController.clear();
    aadhaarController.clear();
    contactController.clear();
    alternateContactController.clear();
    salaryController.clear();
    taController.clear();
    daController.clear();
    hraController.clear();
    joiningDateController.clear();
    addressController.clear();
    setState(() {
      selectedDesignation = null;
      photoPath = null;
    });
    _formKey.currentState?.reset();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        final employee = Employee(
          companyId: global_cid,
          name: nameController.text.trim(),
          dob: DateTime.tryParse(dobController.text),
          email: emailController.text.trim(),
          password: passwordController.text,
          bloodGroup: bloodGroupController.text.trim().isEmpty
              ? null
              : bloodGroupController.text.trim(),
          pan: panController.text.trim().toUpperCase(),
          aadhaar: aadhaarController.text.replaceAll(' ', ''),
          contact: contactController.text.trim(),
          alternateContact: alternateContactController.text.trim().isEmpty
              ? null
              : alternateContactController.text.trim(),
          designation: selectedDesignation,
          salary: salaryController.text.trim(),
          ta: taController.text.trim().isEmpty ? '0' : taController.text.trim(),
          da: daController.text.trim().isEmpty ? '0' : daController.text.trim(),
          hra: hraController.text.trim().isEmpty
              ? '0'
              : hraController.text.trim(),
          joiningDate: DateTime.tryParse(joiningDateController.text),
          address: addressController.text.trim(),
          photoPath: photoPath,
        );

        await EmployeeService.register(employee);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee registered successfully')),
          );
          _clearForm();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.slateTeal,
              onPrimary: AppColors.white,
              onSurface: AppColors.charcoalGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Employee Registration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, AppColors.lightSkyBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Card(
              elevation: 8,
              color: AppColors.babyBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Create Employee Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        inputFormatters: [CapitalizeFirstFormatter()],
                        validator: (value) =>
                            value!.isEmpty ? 'Name is required' : null,
                      ),
                      _buildTextField(
                        controller: dobController,
                        label: 'Date of Birth (yyyy-mm-dd)',
                        icon: Icons.cake,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          DateInputFormatter(),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Date of Birth is required';
                          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                            return 'Enter DOB in yyyy-mm-dd format';
                          }
                          try {
                            final date = DateTime.parse(value);
                            if (date.isAfter(DateTime.now())) {
                              return 'Date of Birth cannot be in the future';
                            }
                          } catch (e) {
                            return 'Invalid date format';
                          }
                          return null;
                        },
                        onTap: () => _pickDate(dobController),
                      ),
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Email is required';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      PasswordTextBox(
                        controller: passwordController,
                        onChanged: (value) {},
                        decoration: _buildInputDecoration(
                          label: 'Password (min 8 characters)',
                          icon: Icons.lock,
                        ),
                      ),
                      _buildTextField(
                        controller: bloodGroupController,
                        label: 'Blood Group (Optional)',
                        icon: Icons.medical_services,
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              !RegExp(r'^(A|B|AB|O)[+-]$').hasMatch(value)) {
                            return 'Enter a valid blood group (e.b., A+, B-, AB+, O-)';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: panController,
                        label: 'PAN',
                        icon: Icons.credit_card,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9]')),
                          TextInputFormatter.withFunction(
                              (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.toUpperCase())),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) return 'PAN is required';
                          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                              .hasMatch(value)) {
                            return 'Enter a valid PAN (e.g., ABCDE1234F)';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: aadhaarController,
                        label: 'Aadhaar',
                        icon: Icons.fingerprint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          AadhaarInputFormatter(),
                          LengthLimitingTextInputFormatter(14),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          final rawValue = value!.replaceAll(' ', '');
                          if (rawValue.isEmpty) return 'Aadhaar is required';
                          if (rawValue.length != 12)
                            return 'Aadhaar must be 12 digits';
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: contactController,
                        label: 'Contact Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Contact Number is required';
                          if (value.length != 10)
                            return 'Enter a valid 10-digit number';
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: alternateContactController,
                        label: 'Alternate Contact Number (Optional)',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) =>
                            value!.isNotEmpty && value.length != 10
                                ? 'Enter a valid 10-digit number'
                                : null,
                      ),
                      _buildDropdownField(),
                      _buildTextField(
                        controller: salaryController,
                        label: 'Salary',
                        icon: Icons.money,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) return 'Salary is required';
                          if (double.tryParse(value) == null ||
                              double.parse(value) < 0) {
                            return 'Enter a valid salary';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: taController,
                        label: 'Travel Allowance (Optional)',
                        icon: Icons.directions_car,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.parse(value) < 0)) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: daController,
                        label: 'Dearness Allowance (Optional)',
                        icon: Icons.monetization_on,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.parse(value) < 0)) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: hraController,
                        label: 'House Rent Allowance (Optional)',
                        icon: Icons.home_work,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        validator: (value) {
                          if (value!.isNotEmpty &&
                              (double.tryParse(value) == null ||
                                  double.parse(value) < 0)) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: joiningDateController,
                        label: 'Joining Date (yyyy-mm-dd)',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          DateInputFormatter(),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) return 'Joining Date is required';
                          if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                            return 'Enter Joining Date in yyyy-mm-dd format';
                          }
                          try {
                            DateTime.parse(value);
                          } catch (e) {
                            return 'Invalid date format';
                          }
                          return null;
                        },
                        onTap: () => _pickDate(joiningDateController),
                      ),
                      _buildTextField(
                        controller: addressController,
                        label: 'Address',
                        icon: Icons.home,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) =>
                            value!.isEmpty ? 'Address is required' : null,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            photoPath = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageUpload(
                                  onImageUploaded: () => setState(() {}),
                                ),
                              ),
                            );
                            if (photoPath != null) setState(() {});
                          },
                          icon: const Icon(Icons.upload_file,
                              color: AppColors.white),
                          label: Text(
                            photoPath == null
                                ? 'Upload Photo (Optional)'
                                : 'Photo Uploaded',
                            style: const TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.slateTeal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.slateTeal,
                              )
                            : ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.slateTeal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.charcoalGray),
      prefixIcon: Icon(icon, color: AppColors.slateTeal),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.slateTeal, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.slateTeal),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: _buildInputDecoration(label: label, icon: icon),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(color: AppColors.charcoalGray),
        cursorColor: AppColors.slateTeal,
        maxLines: maxLines,
        onTap: onTap,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedDesignation,
        decoration: _buildInputDecoration(
          label: 'Designation',
          icon: Icons.work,
        ),
        items: designations
            .map((designation) => DropdownMenuItem(
                  value: designation,
                  child: Text(
                    designation,
                    style: const TextStyle(color: AppColors.charcoalGray),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedDesignation = value;
          });
        },
        validator: (value) => value == null ? 'Designation is required' : null,
        style: const TextStyle(color: AppColors.charcoalGray),
        dropdownColor: AppColors.babyBlue,
        iconEnabledColor: AppColors.slateTeal,
        focusColor: AppColors.slateTeal,
      ),
    );
  }
}
