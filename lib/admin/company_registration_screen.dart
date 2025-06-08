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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/password.dart';

class Company {
  String? username;
  String? email;
  String? website;
  String? contact;
  String? gstn;
  String? password;
  String? category;
  String? logoPath;

  Company({
    this.username,
    this.email,
    this.website,
    this.contact,
    this.gstn,
    this.password,
    this.category,
    this.logoPath,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      username: json['user_name'],
      email: json['email_id'],
      website: json['website'],
      contact: json['contact_no'],
      gstn: json['gstn_no'],
      password: json['password'],
      category: json['category'],
      logoPath: json['company_logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': username,
      'email_id': email,
      'website': website,
      'contact_no': contact,
      'gstn_no': gstn,
      'password': password,
      'category': category,
      'company_logo': logoPath,
    }..removeWhere((key, value) => value == null || value == '');
  }
}

class CompanyService {
  static Future<Company> register(Company company) async {
    try {
      final jsonData = jsonEncode(company.toJson());
      print('📤 Sending Company Data: $jsonData');
      final url = Uri.parse('$baseURL/company-infos');
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonData,
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map<String, dynamic> &&
            responseBody['company'] != null) {
          return Company.fromJson(responseBody['company']);
        }
        throw Exception('Invalid response format');
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['errors'] != null
            ? errorResponse['errors']
                .entries
                .map((e) => '${e.key}: ${e.value.join(', ')}')
                .join('\n')
            : errorResponse['message'] ?? 'Failed to register company';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}

class CapitalizeFirstFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final formattedText =
        text[0].toUpperCase() + text.substring(1).toLowerCase();
    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }
}

class CompanyRegistrationScreen extends StatefulWidget {
  const CompanyRegistrationScreen({super.key});

  @override
  State<CompanyRegistrationScreen> createState() =>
      _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final TextEditingController WorkingHourController = TextEditingController();
  final TextEditingController gstnController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  File? logoFile;
  bool isLoading = false;
  bool isUploadingLogo = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    websiteController.dispose();
    contactController.dispose();
    gstnController.dispose();
    passwordController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _uploadLogo() async {
    setState(() => isUploadingLogo = true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (image != null) {
        setState(() {
          logoFile = File(image.path);
        });
        print('📷 Logo Path: ${logoFile!.path}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload logo: $e')),
        );
      }
    } finally {
      setState(() => isUploadingLogo = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
      return;
    }
    if (logoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a company logo')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      // Convert logo to Base64
      final bytes = await logoFile!.readAsBytes();
      final base64Logo = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final company = Company(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        website: websiteController.text.trim(),
        contact: contactController.text.trim(),
        gstn: gstnController.text.trim().toUpperCase(),
        password: passwordController.text,
        category: categoryController.text.trim(),
        logoPath: base64Logo,
      );

      await CompanyService.register(company);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company registered successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
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

  InputDecoration _buildInputDecoration({
    required String label,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.charcoalGray),
      prefixIcon: icon != null ? Icon(icon, color: AppColors.slateTeal) : null,
      filled: true,
      fillColor: AppColors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.slateTeal),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.slateTeal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.slateTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        decoration: _buildInputDecoration(label: label, icon: icon),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(color: AppColors.charcoalGray),
        cursorColor: AppColors.slateTeal,
        maxLines: maxLines,
        obscureText: obscureText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Company Registration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
          onPressed: () => Navigator.pop(context),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              elevation: 8,
              color: AppColors.babyBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Create Company Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slateTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          if (value.length > 255) {
                            return 'Username must be less than 255 characters';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: websiteController,
                        label: 'Website',
                        icon: Icons.web,
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Website is required';
                          }
                          if (value.length > 100) {
                            return 'Website must be less than 100 characters';
                          }
                          if (!RegExp(
                                  r'^(https?://)?([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$')
                              .hasMatch(value)) {
                            return 'Enter a valid URL';
                          }
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
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact number is required';
                          }
                          if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                            return 'Enter a valid 10-15 digit number';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: WorkingHourController,
                        label: 'Working Hour',
                        icon: Icons.hourglass_bottom,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Working hour is required';
                          }
                          if (!RegExp(r'^\d{4,4}$').hasMatch(value)) {
                            return 'Enter a valid 4 digit number';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: gstnController,
                        label: 'GSTN',
                        icon: Icons.confirmation_number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'GSTN is required';
                          }
                          if (!RegExp(
                                  r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$')
                              .hasMatch(value.toUpperCase())) {
                            return 'Enter a valid GSTN (e.g., 22AAAAA0000A1Z5)';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: categoryController,
                        label: 'Category',
                        icon: Icons.category,
                        inputFormatters: [
                          CapitalizeFirstFormatter(),
                          LengthLimitingTextInputFormatter(17),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Category is required';
                          }
                          if (value.length > 100) {
                            return 'Category must be less than 100 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            if (logoFile != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  logoFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: isUploadingLogo ? null : _uploadLogo,
                              icon: isUploadingLogo
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.upload_file,
                                      color: AppColors.white),
                              label: Text(
                                logoFile == null
                                    ? 'Upload Logo'
                                    : 'Change Logo',
                                style: const TextStyle(color: AppColors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.slateTeal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.slateTeal)
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
}
