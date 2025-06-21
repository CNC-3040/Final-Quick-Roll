// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/password.dart';

// class Company {
//   String? username;
//   String? email;
//   String? website;
//   String? contact;
//   String? gstn;
//   String? password;
//   String? category;
//   String? logoPath;

//   Company({
//     this.username,
//     this.email,
//     this.website,
//     this.contact,
//     this.gstn,
//     this.password,
//     this.category,
//     this.logoPath,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       username: json['user_name'],
//       email: json['email_id'],
//       website: json['website'],
//       contact: json['contact_no'],
//       gstn: json['gstn_no'],
//       password: json['password'],
//       category: json['category'],
//       logoPath: json['company_logo'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'user_name': username,
//       'email_id': email,
//       'website': website,
//       'contact_no': contact,
//       'gstn_no': gstn,
//       'password': password,
//       'category': category,
//       'company_logo': logoPath,
//     };
//   }
// }

// class CompanyService {
//   static Future<Company> register(Company company) async {
//     String jsonData = jsonEncode(company.toJson());
//     print('📤 Sending Company Data: $jsonData');
//     final url = Uri.parse('$baseURL/company-infos');
//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonData,
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return Company.fromJson(jsonDecode(response.body));
//     } else {
//       try {
//         final errorResponse = jsonDecode(response.body);
//         throw Exception(
//             'Failed to register company: ${errorResponse['message']}');
//       } catch (e) {
//         throw Exception('Failed to register company');
//       }
//     }
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

// class CompanyRegistrationScreen extends StatelessWidget {
//   CompanyRegistrationScreen({super.key});

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController websiteController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController gstnController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   File? logoFile;

//   Future<void> _uploadLogo(BuildContext context) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (image != null) {
//       logoFile = File(image.path);
//       print('Logo Path: ${logoFile!.path}');
//     }
//   }

//   Future<void> _submitForm(BuildContext context) async {
//     if (_formKey.currentState!.validate() && logoFile != null) {
//       Company company = Company(
//         username: usernameController.text,
//         email: emailController.text,
//         website: websiteController.text,
//         contact: contactController.text,
//         gstn: gstnController.text,
//         password: passwordController.text,
//         category: categoryController.text,
//         logoPath:
//             logoFile!.path, // Note: API might expect Base64, not file path
//       );

//       try {
//         await CompanyService.register(company);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       } catch (e) {
//         print('Failed to register company: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to register company: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please complete all fields and upload a logo')),
//       );
//     }
//   }

//   InputDecoration _buildInputDecoration({
//     required String label,
//     required IconData icon,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: AppColors.charcoalGray),
//       prefixIcon: const Icon(null, color: AppColors.slateTeal),
//       focusedBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: AppColors.charcoalGray),
//       ),
//       enabledBorder: const UnderlineInputBorder(
//         borderSide: BorderSide(color: AppColors.charcoalGray),
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
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: AppColors.charcoalGray),
//           prefixIcon: Icon(icon, color: AppColors.slateTeal),
//           focusedBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: AppColors.charcoalGray),
//           ),
//           enabledBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: AppColors.charcoalGray),
//           ),
//         ),
//         keyboardType: keyboardType,
//         inputFormatters: inputFormatters,
//         validator: validator,
//         style: const TextStyle(color: AppColors.charcoalGray),
//         cursorColor: AppColors.charcoalGray,
//         maxLines: maxLines,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Company Registration',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.white, AppColors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 8,
//             color: AppColors.babyBlue,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(0.00),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       width: 400.0,
//                       decoration: BoxDecoration(
//                         color: AppColors.slateTeal,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: const Text(
//                         'Create Your Account',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Username Field
//                     _buildTextField(
//                       controller: usernameController,
//                       label: 'Username',
//                       icon: Icons.person,
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Username is required'
//                           : null,
//                     ),
//                     // Email Field
//                     _buildTextField(
//                       controller: emailController,
//                       label: 'Email',
//                       icon: Icons.email,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Email is required';
//                         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                             .hasMatch(value)) {
//                           return 'Enter a valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     // Password Field
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: PasswordTextBox(
//                         controller: passwordController,
//                         onChanged: (value) {},
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle:
//                               const TextStyle(color: AppColors.charcoalGray),
//                           prefixIcon: const Icon(Icons.lock,
//                               color: AppColors.slateTeal),
//                           focusedBorder: const UnderlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.charcoalGray),
//                           ),
//                           enabledBorder: const UnderlineInputBorder(
//                             borderSide:
//                                 BorderSide(color: AppColors.charcoalGray),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Website Field
//                     _buildTextField(
//                       controller: websiteController,
//                       label: 'Website',
//                       icon: Icons.web,
//                       keyboardType: TextInputType.url,
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Website is required'
//                           : null,
//                     ),
//                     // Contact Field
//                     _buildTextField(
//                       controller: contactController,
//                       label: 'Contact No',
//                       icon: Icons.phone,
//                       keyboardType: TextInputType.phone,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Contact No is required';
//                         } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                           return 'Enter a valid 10-digit number';
//                         }
//                         return null;
//                       },
//                     ),
//                     // GSTN Field
//                     _buildTextField(
//                       controller: gstnController,
//                       label: 'GSTN',
//                       icon: Icons.confirmation_number,
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'GSTN is required'
//                           : null,
//                     ),
//                     // Category Field
//                     _buildTextField(
//                       controller: categoryController,
//                       label: 'Category',
//                       icon: Icons.category,
//                       inputFormatters: [
//                         CapitalizeFirstFormatter(),
//                         LengthLimitingTextInputFormatter(17),
//                       ],
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Category is required'
//                           : null,
//                     ),
//                     const SizedBox(height: 16),
//                     // Logo Upload Button
//                     Center(
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.7,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width * 0.01,
//                           vertical: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () => _uploadLogo(context),
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: AppColors.lightSkyBlue,
//                             backgroundColor: AppColors.slateTeal,
//                             padding: EdgeInsets.symmetric(
//                               horizontal:
//                                   MediaQuery.of(context).size.width * 0.0010,
//                               vertical:
//                                   MediaQuery.of(context).size.height * 0.015,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   const SizedBox(width: 8.0),
//                                   Text(
//                                     logoFile == null
//                                         ? 'Upload Logo'
//                                         : 'Logo Selected',
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.slateTeal,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () => _submitForm(context),
//                       child: const Text(
//                         'Register',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:quick_roll/admin/admin_login.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/password.dart';

// class Company {
//   String? username;
//   String? email;
//   String? website;
//   String? contact;
//   String? gstn;
//   String? password;
//   String? category;
//   String? logoPath;

//   Company({
//     this.username,
//     this.email,
//     this.website,
//     this.contact,
//     this.gstn,
//     this.password,
//     this.category,
//     this.logoPath,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) {
//     return Company(
//       username: json['user_name'],
//       email: json['email_id'],
//       website: json['website'],
//       contact: json['contact_no'],
//       gstn: json['gstn_no'],
//       password: json['password'],
//       category: json['category'],
//       logoPath: json['company_logo'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'user_name': username,
//       'email_id': email,
//       'website': website,
//       'contact_no': contact,
//       'gstn_no': gstn,
//       'password': password,
//       'category': category,
//       'company_logo': logoPath,
//     }..removeWhere((key, value) => value == null || value == '');
//   }
// }

// class CompanyService {
//   static Future<Company> register(Company company) async {
//     try {
//       final jsonData = jsonEncode(company.toJson());
//       print('📤 Sending Company Data: $jsonData');
//       final url = Uri.parse('$baseURL/company-infos');
//       final response = await http
//           .post(
//             url,
//             headers: {
//               'Content-Type': 'application/json; charset=UTF-8',
//               'Accept': 'application/json',
//             },
//             body: jsonData,
//           )
//           .timeout(const Duration(seconds: 10));

//       print('📥 Response Status: ${response.statusCode}');
//       print('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseBody = jsonDecode(response.body);
//         if (responseBody is Map<String, dynamic> &&
//             responseBody['company'] != null) {
//           return Company.fromJson(responseBody['company']);
//         }
//         throw Exception('Invalid response format');
//       } else {
//         final errorResponse = jsonDecode(response.body);
//         String errorMessage = errorResponse['errors'] != null
//             ? errorResponse['errors']
//                 .entries
//                 .map((e) => '${e.key}: ${e.value.join(', ')}')
//                 .join('\n')
//             : errorResponse['message'] ?? 'Failed to register company';
//         throw Exception(errorMessage);
//       }
//     } catch (e) {
//       print('❌ Error: $e');
//       rethrow;
//     }
//   }
// }

// class CapitalizeFirstFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final text = newValue.text;
//     if (text.isEmpty) return newValue;
//     final formattedText =
//         text[0].toUpperCase() + text.substring(1).toLowerCase();
//     return TextEditingValue(
//       text: formattedText,
//       selection: newValue.selection,
//     );
//   }
// }

// class CompanyRegistrationScreen extends StatefulWidget {
//   const CompanyRegistrationScreen({super.key});

//   @override
//   State<CompanyRegistrationScreen> createState() =>
//       _CompanyRegistrationScreenState();
// }

// class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController websiteController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();

//   final TextEditingController WorkingHourController = TextEditingController();
//   final TextEditingController gstnController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   File? logoFile;
//   bool isLoading = false;
//   bool isUploadingLogo = false;

//   @override
//   void dispose() {
//     usernameController.dispose();
//     emailController.dispose();
//     websiteController.dispose();
//     contactController.dispose();
//     gstnController.dispose();
//     passwordController.dispose();
//     categoryController.dispose();
//     super.dispose();
//   }

//   Future<void> _uploadLogo() async {
//     setState(() => isUploadingLogo = true);
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 50,
//       );
//       if (image != null) {
//         setState(() {
//           logoFile = File(image.path);
//         });
//         print('📷 Logo Path: ${logoFile!.path}');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to upload logo: $e')),
//         );
//       }
//     } finally {
//       setState(() => isUploadingLogo = false);
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fix the errors in the form')),
//       );
//       return;
//     }
//     if (logoFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload a company logo')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     try {
//       // Convert logo to Base64
//       final bytes = await logoFile!.readAsBytes();
//       final base64Logo = 'data:image/jpeg;base64,${base64Encode(bytes)}';

//       final company = Company(
//         username: usernameController.text.trim(),
//         email: emailController.text.trim(),
//         website: websiteController.text.trim(),
//         contact: contactController.text.trim(),
//         gstn: gstnController.text.trim().toUpperCase(),
//         password: passwordController.text,
//         category: categoryController.text.trim(),
//         logoPath: base64Logo,
//       );

//       await CompanyService.register(company);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Company registered successfully')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const LoginScreen()),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration failed: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   InputDecoration _buildInputDecoration({
//     required String label,
//     IconData? icon,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: AppColors.charcoalGray),
//       prefixIcon: icon != null ? Icon(icon, color: AppColors.slateTeal) : null,
//       filled: true,
//       fillColor: AppColors.planeGray,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.slateTeal),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.slateTeal),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: AppColors.slateTeal, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     IconData? icon,
//     TextInputType? keyboardType,
//     List<TextInputFormatter>? inputFormatters,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//     bool obscureText = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: TextFormField(
//         controller: controller,
//         decoration: _buildInputDecoration(label: label, icon: icon),
//         keyboardType: keyboardType,
//         inputFormatters: inputFormatters,
//         validator: validator,
//         style: const TextStyle(color: AppColors.charcoalGray),
//         cursorColor: AppColors.oliveGreen,
//         maxLines: maxLines,
//         obscureText: obscureText,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.oliveGreen,
//         centerTitle: true,
//         title: const Text(
//           'Company Registration',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: AppColors.planeGray,
//           ),
//           textAlign: TextAlign.left,
//         ),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.planeGray),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.oliveGreen, AppColors.oliveGreen],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Card(
//               elevation: 8,
//               color: AppColors.planeGray,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           'Create Company Account',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.slateTeal,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       _buildTextField(
//                         controller: usernameController,
//                         label: 'Username',
//                         icon: Icons.person,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.deny(RegExp(r'\s')),
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Username is required';
//                           }
//                           if (value.length > 255) {
//                             return 'Username must be less than 255 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: emailController,
//                         label: 'Email',
//                         icon: Icons.email,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Email is required';
//                           }
//                           if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: passwordController,
//                         label: 'Password',
//                         icon: Icons.lock,
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Password is required';
//                           }
//                           if (value.length < 8) {
//                             return 'Password must be at least 8 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: websiteController,
//                         label: 'Website',
//                         icon: Icons.web,
//                         keyboardType: TextInputType.url,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Website is required';
//                           }
//                           if (value.length > 100) {
//                             return 'Website must be less than 100 characters';
//                           }
//                           if (!RegExp(
//                                   r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$')
//                               .hasMatch(value)) {
//                             return 'Enter a valid URL';
//                           }
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
//                           LengthLimitingTextInputFormatter(15),
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Contact number is required';
//                           }
//                           if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
//                             return 'Enter a valid 10-15 digit number';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: WorkingHourController,
//                         label: 'Working Hour',
//                         icon: Icons.hourglass_bottom,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(15),
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Working hour is required';
//                           }
//                           if (!RegExp(r'^\d{4,4}$').hasMatch(value)) {
//                             return 'Enter a valid 4 digit number';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: gstnController,
//                         label: 'GSTN',
//                         icon: Icons.confirmation_number,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(15),
//                           FilteringTextInputFormatter.allow(
//                               RegExp(r'[A-Za-z0-9]')),
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'GSTN is required';
//                           }
//                           if (!RegExp(
//                                   r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$')
//                               .hasMatch(value.toUpperCase())) {
//                             return 'Enter a valid GSTN (e.g., 22AAAAA0000A1Z5)';
//                           }
//                           return null;
//                         },
//                       ),
//                       _buildTextField(
//                         controller: categoryController,
//                         label: 'Category',
//                         icon: Icons.category,
//                         inputFormatters: [
//                           CapitalizeFirstFormatter(),
//                           LengthLimitingTextInputFormatter(17),
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Category is required';
//                           }
//                           if (value.length > 100) {
//                             return 'Category must be less than 100 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Center(
//                         child: Column(
//                           children: [
//                             if (logoFile != null)
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.file(
//                                   logoFile!,
//                                   height: 100,
//                                   width: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             const SizedBox(height: 8),
//                             ElevatedButton.icon(
//                               onPressed: isUploadingLogo ? null : _uploadLogo,
//                               icon: isUploadingLogo
//                                   ? const SizedBox(
//                                       width: 16,
//                                       height: 16,
//                                       child: CircularProgressIndicator(
//                                         color: AppColors.white,
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : const Icon(Icons.upload_file,
//                                       color: AppColors.white),
//                               label: Text(
//                                 logoFile == null
//                                     ? 'Upload Logo'
//                                     : 'Change Logo',
//                                 style: const TextStyle(color: AppColors.white),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.slateTeal,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 24, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Center(
//                         child: isLoading
//                             ? const CircularProgressIndicator(
//                                 color: AppColors.slateTeal)
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
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:quick_roll/core/role_selection_screen.dart';
// import 'package:quick_roll/model/signup_form_model.dart';
// import 'package:quick_roll/widgets/rounded_textbox.dart';
// import 'package:quick_roll/widgets/navigation_arrow.dart';
// import 'home_screen.dart'; // Placeholder or actual HomeScreen

// class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
//   NoAnimationPageRoute({required WidgetBuilder builder})
//       : super(builder: builder);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }

// class BusinessNameScreen extends StatelessWidget {
//   const BusinessNameScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Sign Up As",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Name",
//                 errorText: signupModel.businessNameError,
//                 onChanged: (value) {
//                   signupModel.businessName = _capitalizeWords(value);
//                   signupModel.validateBusinessName();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateBusinessName()) {
//                     signupModel.setScreenIndex(1);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const BusinessCategoryScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BusinessCategoryScreen extends StatelessWidget {
//   const BusinessCategoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Category Of Your",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Category",
//                 dropdownItems: const [
//                   'IT Services',
//                   'Retail',
//                   'Health & Wellness',
//                   'Education',
//                   'Finance',
//                 ],
//                 errorText: signupModel.categoryError,
//                 onDropdownChanged: (value) {
//                   signupModel.category = value ?? '';
//                   signupModel.validateCategory();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(0);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateCategory()) {
//                     signupModel.setScreenIndex(2);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const VerifyScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VerifyScreen extends StatelessWidget {
//   const VerifyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Welcome",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     signupModel.businessName.isEmpty
//                         ? "*Business Name*"
//                         : signupModel.businessName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: Column(
//                 children: [
//                   RoundedTextBox(
//                     hint: "Business Email Address",
//                     errorText: signupModel.emailError,
//                     onChanged: (value) {
//                       signupModel.email = value;
//                       signupModel.validateEmail();
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   RoundedTextBox(
//                     hint: "Contact No.",
//                     errorText: signupModel.contactNoError,
//                     onChanged: (value) {
//                       signupModel.contactNo = value;
//                       signupModel.validateContactNo();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(1);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateEmail() &&
//                       signupModel.validateContactNo()) {
//                     signupModel.setScreenIndex(3);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const PasswordSetupScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PasswordSetupScreen extends StatelessWidget {
//   const PasswordSetupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Security",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Is Important !",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: Column(
//                 children: [
//                   RoundedTextBox(
//                     hint: "User Name",
//                     errorText: signupModel.userNameError,
//                     onChanged: (value) {
//                       signupModel.userName = _capitalizeWords(value);
//                       signupModel.validateUserName();
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   RoundedTextBox(
//                     hint: "Create A Password",
//                     isPassword: true,
//                     errorText: signupModel.passwordError,
//                     onChanged: (value) {
//                       signupModel.password = value;
//                       signupModel.validatePassword();
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   const SizedBox(height: 5),
//                   Text(
//                     "Strong password recommended.*",
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: AppColors.deepTeal,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       RoundedTextBox(
//                         hint: "Remember me",
//                         isCheckbox: true,
//                         checkboxLabel: "Remember me",
//                         onCheckboxChanged: (value) {
//                           // Handle remember me state if needed
//                         },
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(2);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateUserName() &&
//                       signupModel.validatePassword()) {
//                     signupModel.setScreenIndex(4);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const OwnerNameScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OwnerNameScreen extends StatelessWidget {
//   const OwnerNameScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Who's",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "In Charge?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Owner/Administrator Name",
//                 errorText: signupModel.ownerNameError,
//                 onChanged: (value) {
//                   signupModel.ownerName = _capitalizeWords(value);
//                   signupModel.validateOwnerName();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.ownerName = '';
//                   signupModel.setScreenIndex(5);
//                   Navigator.push(
//                     context,
//                     NoAnimationPageRoute(
//                       builder: (context) => const BusinessLocationScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Later",
//                   style: GoogleFonts.poppins(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w300,
//                     color: AppColors.deepTeal,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(3);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateOwnerName()) {
//                     signupModel.setScreenIndex(5);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const BusinessLocationScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BusinessLocationScreen extends StatelessWidget {
//   const BusinessLocationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Location of",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Address",
//                 errorText: signupModel.businessAddressError,
//                 onChanged: (value) {
//                   signupModel.businessAddress = _capitalizeWords(value);
//                   signupModel.validateBusinessAddress();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.businessAddress = '';
//                   signupModel.setScreenIndex(6);
//                   Navigator.push(
//                     context,
//                     NoAnimationPageRoute(
//                       builder: (context) => const WebsiteScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Later",
//                   style: GoogleFonts.poppins(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w300,
//                     color: AppColors.deepTeal,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(4);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateBusinessAddress()) {
//                     signupModel.setScreenIndex(6);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const WebsiteScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WebsiteScreen extends StatelessWidget {
//   const WebsiteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Customer",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Website?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Website URL",
//                 errorText: signupModel.websiteError,
//                 onChanged: (value) {
//                   signupModel.website = value;
//                   signupModel.validateWebsite();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.website = '';
//                   signupModel.setScreenIndex(7);
//                   Navigator.push(
//                     context,
//                     NoAnimationPageRoute(
//                       builder: (context) => const RegistrationSuccessScreen(),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "Later",
//                   style: GoogleFonts.poppins(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w300,
//                     color: AppColors.deepTeal,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(5);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateWebsite()) {
//                     signupModel.setScreenIndex(7);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const RegistrationSuccessScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RegistrationSuccessScreen extends StatelessWidget {
//   const RegistrationSuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.myTeal,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned(
//               top: size.height * 0.18,
//               left: 0,
//               right: 0,
//               child: Image.asset(
//                 "assets/Artboard_84.png",
//                 width: 130,
//                 height: 130,
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.41,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   Text(
//                     "Registration",
//                     style: GoogleFonts.poppins(
//                       fontSize: 35,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Successful",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             if (signupModel.apiError != null)
//               Positioned(
//                 top: size.height * 0.55,
//                 left: 30,
//                 right: 30,
//                 child: Text(
//                   signupModel.apiError!,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             Positioned(
//               bottom: 40,
//               left: 30,
//               right: 30,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Take a Tour",
//                         style: GoogleFonts.poppins(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w300,
//                           color: AppColors.deepTeal,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           final success =
//                               await signupModel.registerCompany(context);
//                           if (success) {
//                             Navigator.pushReplacement(
//                               context,
//                               NoAnimationPageRoute(
//                                 builder: (context) =>
//                                     const RoleSelectionScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 35, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: AppColors.deepTeal,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Text(
//                             "Finish",
//                             style: GoogleFonts.poppins(
//                               fontSize: 25,
//                               color: AppColors.myTeal,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "By Clicking finish, you agree to Quick Roll's Terms of services\n& acknowledge Quick Roll's Privacy Policy.",
//                     style: GoogleFonts.poppins(
//                       fontSize: 11,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignupFlow extends StatelessWidget {
//   const SignupFlow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BusinessNameScreen();
//   }
// }

// String _capitalizeWords(String input) {
//   if (input.isEmpty) return input;
//   return input
//       .split(' ')
//       .map((word) => word.isNotEmpty
//           ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//           : word)
//       .join(' ');
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:quick_roll/core/role_selection_screen.dart';
// import 'package:quick_roll/model/signup_form_model.dart';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/rounded_textbox.dart';
// import 'package:quick_roll/widgets/navigation_arrow.dart';
// import 'home_screen.dart'; // Placeholder or actual HomeScreen

// class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
//   NoAnimationPageRoute({required WidgetBuilder builder})
//       : super(builder: builder);

//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return child;
//   }
// }

// class BusinessNameScreen extends StatelessWidget {
//   const BusinessNameScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Sign Up As",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Name",
//                 errorText: signupModel.businessNameError,
//                 onChanged: (value) {
//                   signupModel.businessName = _capitalizeWords(value);
//                   signupModel.validateBusinessName();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateBusinessName()) {
//                     signupModel.setScreenIndex(1);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const BusinessCategoryScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BusinessCategoryScreen extends StatelessWidget {
//   const BusinessCategoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Category Of Your",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.30,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Category",
//                 dropdownItems: const [
//                   'IT Services',
//                   'Retail',
//                   'Health & Wellness',
//                   'Education',
//                   'Finance',
//                 ],
//                 errorText: signupModel.categoryError,
//                 onDropdownChanged: (value) {
//                   signupModel.setValue('category', value ?? '');
//                   signupModel.validateCategory();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(0);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateCategory()) {
//                     signupModel.setScreenIndex(2);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const VerifyScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VerifyScreen extends StatelessWidget {
//   const VerifyScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Welcome",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     signupModel.businessName.isEmpty
//                         ? "*Business Name*"
//                         : signupModel.businessName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: Column(
//                 children: [
//                   RoundedTextBox(
//                     hint: "Business Email Address",
//                     errorText: signupModel.emailError,
//                     upperText: false,
//                     onChanged: (value) {
//                       signupModel.setValue('email', value);
//                       signupModel.validateEmail();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   RoundedTextBox(
//                     hint: "Business Contact No.",
//                     upperText: false,
//                     errorText: signupModel.contactNoError,
//                     onChanged: (value) {
//                       signupModel.setValue('contactNo', value);
//                       signupModel.validateContactNo();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(1);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateEmail() &&
//                       signupModel.validateContactNo()) {
//                     signupModel.setScreenIndex(3);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const PasswordSetupScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PasswordSetupScreen extends StatelessWidget {
//   const PasswordSetupScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal, // Use your defined color
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Security",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Is Important !",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RoundedTextBox(
//                     hint: "User Name",
//                     errorText: signupModel.userNameError,
//                     onChanged: (value) {
//                       signupModel.setValue('userName', _capitalizeWords(value));
//                       signupModel.validateUserName();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   RoundedTextBox(
//                     hint: "Create A Password",
//                     isPassword: true,
//                     upperText: false,
//                     errorText: signupModel.passwordError,
//                     onChanged: (value) {
//                       signupModel.setValue('password', value);
//                       signupModel.validatePassword();
//                     },
//                   ),
//                   const SizedBox(height: 5),
//                   Center(
//                     child: Text(
//                       "Strong password recommended.*",
//                       style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: AppColors.deepTeal,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Row(
//                     children: [
//                       RoundedTextBox(
//                         hint: "Remember me",
//                         isCheckbox: true,
//                         checkboxLabel: "Remember me",
//                         onCheckboxChanged: (value) {
//                           // Handle remember me state if needed
//                         },
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(2);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateUserName() &&
//                       signupModel.validatePassword()) {
//                     signupModel.setScreenIndex(4);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const OwnerNameScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OwnerNameScreen extends StatelessWidget {
//   const OwnerNameScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Who's",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "In Charge?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Owner/Administrator Name",
//                 errorText: signupModel.ownerNameError,
//                 onChanged: (value) {
//                   signupModel.setValue('ownerName', _capitalizeWords(value));
//                   signupModel.validateOwnerName();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(3);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     signupModel.setValue('ownerName', '');
//                     signupModel.setScreenIndex(5);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const BusinessLocationScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Later",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.deepTeal,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateOwnerName()) {
//                     signupModel.setScreenIndex(5);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const BusinessLocationScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BusinessLocationScreen extends StatelessWidget {
//   const BusinessLocationScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Location of",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Business?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Business Address",
//                 errorText: signupModel.businessAddressError,
//                 onChanged: (value) {
//                   signupModel.setValue(
//                       'businessAddress', _capitalizeWords(value));
//                   signupModel.validateBusinessAddress();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(4);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     signupModel.setValue('businessAddress', '');
//                     signupModel.setScreenIndex(6);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const WebsiteScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Later",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.deepTeal,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateBusinessAddress()) {
//                     signupModel.setScreenIndex(6);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const WebsiteScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class WebsiteScreen extends StatelessWidget {
//   const WebsiteScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.LightMistGray,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: signupModel,
//               builder: (context, child) {
//                 return Positioned(
//                   top: 0,
//                   left: 0,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     height: 20,
//                     width: signupModel.getGreenStripWidth(context),
//                     color: AppColors.myTeal,
//                   ),
//                 );
//               },
//             ),
//             Positioned(
//               top: size.height * 0.15,
//               left: 0,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Customer",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Website?",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.40,
//               left: 30,
//               right: 30,
//               child: RoundedTextBox(
//                 hint: "Website URL",
//                 upperText: false,
//                 errorText: signupModel.websiteError,
//                 onChanged: (value) {
//                   signupModel.setValue('website', value);
//                   signupModel.validateWebsite();
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               left: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   signupModel.setScreenIndex(5);
//                   Navigator.pop(context);
//                 },
//                 child: const NavigationArrow(isForward: false),
//               ),
//             ),
//             Positioned(
//               bottom: 50,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     signupModel.setValue('website', '');
//                     signupModel.setScreenIndex(7);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const RegistrationSuccessScreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Later",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w300,
//                       color: AppColors.deepTeal,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 30,
//               right: 30,
//               child: GestureDetector(
//                 onTap: () {
//                   if (signupModel.validateWebsite()) {
//                     signupModel.setScreenIndex(7);
//                     Navigator.push(
//                       context,
//                       NoAnimationPageRoute(
//                         builder: (context) => const RegistrationSuccessScreen(),
//                       ),
//                     );
//                   }
//                 },
//                 child: const NavigationArrow(isForward: true),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RegistrationSuccessScreen extends StatelessWidget {
//   const RegistrationSuccessScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final signupModel = Provider.of<SignupFormModel>(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColors.myTeal,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned(
//               top: size.height * 0.18,
//               left: 0,
//               right: 0,
//               child: Image.asset(
//                 "assets/Artboard_84.png",
//                 width: 130,
//                 height: 130,
//               ),
//             ),
//             Positioned(
//               top: size.height * 0.41,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   Text(
//                     "Registration",
//                     style: GoogleFonts.poppins(
//                       fontSize: 35,
//                       fontWeight: FontWeight.w200,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text(
//                     "Successful",
//                     style: GoogleFonts.poppins(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             if (signupModel.apiError != null)
//               Positioned(
//                 top: size.height * 0.55,
//                 left: 30,
//                 right: 30,
//                 child: Text(
//                   signupModel.apiError!,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             Positioned(
//               bottom: 40,
//               left: 30,
//               right: 30,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Take a Tour",
//                         style: GoogleFonts.poppins(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w300,
//                           color: AppColors.deepTeal,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           final success =
//                               await signupModel.registerCompany(context);
//                           if (success) {
//                             Navigator.pushReplacement(
//                               context,
//                               NoAnimationPageRoute(
//                                 builder: (context) =>
//                                     const RoleSelectionScreen(),
//                               ),
//                             );
//                           }
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 35, vertical: 7),
//                           decoration: BoxDecoration(
//                             color: AppColors.deepTeal,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Text(
//                             "Finish",
//                             style: GoogleFonts.poppins(
//                               fontSize: 25,
//                               color: AppColors.myTeal,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "By Clicking finish, you agree to Quick Roll's Terms of services\n& acknowledge Quick Roll's Privacy Policy.",
//                     style: GoogleFonts.poppins(
//                       fontSize: 11,
//                       color: AppColors.deepTeal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignupFlow extends StatelessWidget {
//   const SignupFlow({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const BusinessNameScreen();
//   }
// }

// String _capitalizeWords(String input) {
//   if (input.isEmpty) return input;
//   return input
//       .trim()
//       .split(RegExp(r'\s+'))
//       .where((word) => word.isNotEmpty)
//       .map((word) =>
//           '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
//       .join(' ');
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/model/signup_form_model.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/rounded_textbox.dart';
import 'package:quick_roll/widgets/navigation_arrow.dart';
import 'home_screen.dart'; // Placeholder or actual HomeScreen

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class BusinessNameScreen extends StatelessWidget {
  const BusinessNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up As",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Business",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Business Name",
                initialValue: signupModel.businessName,
                errorText: signupModel.businessNameError,
                onChanged: (value) {
                  signupModel.setValue('businessName', value);
                  signupModel.validateBusinessName();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateBusinessName()) {
                    signupModel.setScreenIndex(1);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const BusinessCategoryScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessCategoryScreen extends StatelessWidget {
  const BusinessCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Category Of Your",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Business?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Business Category",
                dropdownItems: const [
                  'IT Services',
                  'Retail',
                  'Health & Wellness',
                  'Education',
                  'Finance',
                ],
                initialValue: signupModel.category,
                errorText: signupModel.categoryError,
                onDropdownChanged: (value) {
                  signupModel.setValue('category', value ?? '');
                  signupModel.validateCategory();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(0);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateCategory()) {
                    signupModel.setScreenIndex(2);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const VerifyScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    signupModel.businessName.isEmpty
                        ? "*Business Name*"
                        : signupModel.businessName,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  RoundedTextBox(
                    hint: "Business Email Address",
                    initialValue: signupModel.email,
                    errorText: signupModel.emailError,
                    upperText: false,
                    onChanged: (value) {
                      signupModel.setValue('email', value);
                      signupModel.validateEmail();
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedTextBox(
                    hint: "Business Contact No.",
                    initialValue: signupModel.contactNo,
                    errorText: signupModel.contactNoError,
                    upperText: false,
                    onChanged: (value) {
                      signupModel.setValue('contactNo', value);
                      signupModel.validateContactNo();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(1);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateEmail() &&
                      signupModel.validateContactNo()) {
                    signupModel.setScreenIndex(3);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const PasswordSetupScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordSetupScreen extends StatelessWidget {
  const PasswordSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Security",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Is Important !",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedTextBox(
                    hint: "User Name",
                    initialValue: signupModel.userName,
                    errorText: signupModel.userNameError,
                    onChanged: (value) {
                      signupModel.setValue('userName', value);
                      signupModel.validateUserName();
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedTextBox(
                    hint: "Create A Password",
                    isPassword: true,
                    initialValue: signupModel.password,
                    errorText: signupModel.passwordError,
                    upperText: false,
                    onChanged: (value) {
                      signupModel.setValue('password', value);
                      signupModel.validatePassword();
                    },
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Strong password recommended.*",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.deepTeal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      RoundedTextBox(
                        hint: "Remember me",
                        isCheckbox: true,
                        checkboxLabel: "Remember me",
                        onCheckboxChanged: (value) {
                          // Handle remember me state if needed
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(2);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateUserName() &&
                      signupModel.validatePassword()) {
                    signupModel.setScreenIndex(4);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const OwnerNameScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OwnerNameScreen extends StatelessWidget {
  const OwnerNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Who's",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "In Charge?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Owner/Administrator Name",
                initialValue: signupModel.ownerName,
                errorText: signupModel.ownerNameError,
                onChanged: (value) {
                  signupModel.setValue('ownerName', value);
                  signupModel.validateOwnerName();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(3);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    signupModel.setValue('ownerName', '');
                    signupModel.setScreenIndex(5);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const BusinessLocationScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Later",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateOwnerName()) {
                    signupModel.setScreenIndex(5);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const BusinessLocationScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessLocationScreen extends StatelessWidget {
  const BusinessLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Location of",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Business?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Business Address",
                initialValue: signupModel.businessAddress,
                errorText: signupModel.businessAddressError,
                onChanged: (value) {
                  signupModel.setValue('businessAddress', value);
                  signupModel.validateBusinessAddress();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(4);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    signupModel.setValue('businessAddress', '');
                    signupModel.setScreenIndex(6);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const WebsiteScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Later",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateBusinessAddress()) {
                    signupModel.setScreenIndex(6);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const WebsiteScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebsiteScreen extends StatelessWidget {
  const WebsiteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.LightMistGray,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: signupModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: signupModel.getGreenStripWidth(context),
                    color: AppColors.myTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Customer",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Website?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Website URL",
                initialValue: signupModel.website,
                errorText: signupModel.websiteError,
                upperText: false,
                onChanged: (value) {
                  signupModel.setValue('website', value);
                  signupModel.validateWebsite();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  signupModel.setScreenIndex(5);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    signupModel.setValue('website', '');
                    signupModel.setScreenIndex(7);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const RegistrationSuccessScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Later",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: AppColors.deepTeal,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (signupModel.validateWebsite()) {
                    signupModel.setScreenIndex(7);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const RegistrationSuccessScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupFormModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.myTeal,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.18,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/Artboard_84.png",
                width: 130,
                height: 130,
              ),
            ),
            Positioned(
              top: size.height * 0.41,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Registration",
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w200,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Successful",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (signupModel.apiError != null)
              Positioned(
                top: size.height * 0.55,
                left: 30,
                right: 30,
                child: Text(
                  signupModel.apiError!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          signupModel.setScreenIndex(0);
                          Navigator.pushReplacement(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) => const BusinessNameScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Take a Tour",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: AppColors.deepTeal,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final success =
                              await signupModel.registerCompany(context);
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) =>
                                    const RoleSelectionScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.deepTeal,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            "Finish",
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: AppColors.myTeal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "By Clicking finish, you agree to Quick Roll's Terms of services\n& acknowledge Quick Roll's Privacy Policy.",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.deepTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupFlow extends StatelessWidget {
  const SignupFlow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BusinessNameScreen();
  }
}

String _capitalizeWords(String input) {
  if (input.isEmpty) return input;
  return input
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) =>
          '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
}
