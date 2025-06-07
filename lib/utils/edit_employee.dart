// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/services/global_API.dart';
// import 'dart:convert';
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'package:quick_roll/widgets/image_upload.dart';
// import 'package:quick_roll/widgets/password.dart';
// // Add this import

// class AadhaarInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final rawText = newValue.text.replaceAll(' ', ''); // Remove existing spaces
//     final buffer = StringBuffer();
//     for (int i = 0; i < rawText.length; i++) {
//       if (i > 0 && i % 4 == 0) {
//         buffer.write(' '); // Add space after every 4 digits
//       }
//       buffer.write(rawText[i]);
//     }
//     final formattedText = buffer.toString();
//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }

// class DateOfBirthInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final rawText =
//         newValue.text.replaceAll('-', ''); // Remove existing hyphens
//     final buffer = StringBuffer();
//     for (int i = 0; i < rawText.length; i++) {
//       if ((i == 4 || i == 6) && i < rawText.length) {
//         buffer.write('-'); // Add hyphen at appropriate positions
//       }
//       buffer.write(rawText[i]);
//     }
//     final formattedText = buffer.toString();
//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }

// class JoiningDateInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     final rawText =
//         newValue.text.replaceAll('-', ''); // Remove existing hyphens
//     final buffer = StringBuffer();
//     for (int i = 0; i < rawText.length; i++) {
//       if ((i == 4 || i == 6) && i < rawText.length) {
//         buffer.write('-'); // Add hyphen after year and month
//       }
//       buffer.write(rawText[i]);
//     }
//     final formattedText = buffer.toString();
//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }

// class EditEmployeePage extends StatefulWidget {
//   final Map employee;

//   const EditEmployeePage({super.key, required this.employee});

//   @override
//   _EditEmployeePageState createState() => _EditEmployeePageState();
// }

// class _EditEmployeePageState extends State<EditEmployeePage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for all the fields
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController panController = TextEditingController();
//   final TextEditingController aadhaarController = TextEditingController();
//   final TextEditingController contactController = TextEditingController();
//   final TextEditingController alternateContactController = TextEditingController();
//   final TextEditingController designationController = TextEditingController();
//   final TextEditingController salaryController = TextEditingController();
//   final TextEditingController joiningDateController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   String? imageData;

//   @override
//   void initState() {
//     super.initState();
//     idController.text = widget.employee['id']?.toString() ?? '';
//     nameController.text = widget.employee['name'] ?? '';
//     dobController.text = widget.employee['dob'] ?? '';
//     emailController.text = widget.employee['email'] ?? '';
//     passwordController.text = widget.employee['password'] ?? '';
//     panController.text = widget.employee['pan'] ?? '';
//     aadhaarController.text = widget.employee['aadhaar'] ?? '';
//     contactController.text = widget.employee['contact'] ?? '';
//     alternateContactController.text = widget.employee['alternate_contact'] ?? '';
//     designationController.text = widget.employee['designation'] ?? '';
//     salaryController.text = widget.employee['salary']?.toString() ?? '';
//     joiningDateController.text = widget.employee['joining_date'] ?? '';
//     addressController.text = widget.employee['address'] ?? '';
//     imageData = widget.employee['photo_path'] ?? '';
//     print('Initialized Photo Path: $imageData');
//   }

//   Future<void> updateEmployee() async {
//     if (_formKey.currentState!.validate()) {
//       if (imageData == null || imageData!.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload an image')),
//         );
//         return;
//       }

//       final updatedEmployee = {

//         'name': nameController.text,
//         'dob': dobController.text,
//         'email': emailController.text,
//         'password': passwordController.text,
//         'pan': panController.text,
//         'aadhaar': aadhaarController.text,
//         'contact': contactController.text,
//         'alternate_contact': alternateContactController.text,
//         'designation': designationController.text,
//         'salary': salaryController.text,
//         'joining_date': joiningDateController.text,
//         'address': addressController.text,
//         'photo_path': imageData,
//       };

//      final response = await http.put(
//     Uri.parse('$baseURL/employees/${widget.employee['id']}'), // Correct URL with employee ID
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode(updatedEmployee),

//   );

//       if (response.statusCode == 200) {
//         Navigator.pop(context, true); // Return true if the update was successful
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Employee updated successfully!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to update employee. Error: ${response.body}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Edit Employee',
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
//                     // Text wrapped with a container for background and edges
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       width: 400.0, // Specify the desired width here
//                       decoration: BoxDecoration(
//                         color: AppColors.slateTeal, // Background color
//                         borderRadius: BorderRadius.circular(5), // Rounded edges
//                       ),
//                       child: const Text(
//                         'Edit Employee Details',
//                         textAlign: TextAlign.center, // Centers the text
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     // Name Field
//                     TextFormField(
//                       controller: nameController,
//                       decoration: const InputDecoration(
//                         labelText: 'Name',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.person, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set cursor color here
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Name is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     // Date of Birth Field
//                     TextFormField(
//                       controller: dobController,
//                       decoration: const InputDecoration(
//                         labelText: 'Date of Birth (yyyy-mm-dd)',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.cake, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray),
//                       cursorColor: AppColors.charcoalGray,
//                       keyboardType: TextInputType.datetime,
//                       inputFormatters: [
//                         DateOfBirthInputFormatter(),
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       validator: (value) {
//                         final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
//                         if (value == null || value.isEmpty) {
//                           return 'Date of Birth is required';
//                         } else if (!regex.hasMatch(value)) {
//                           return 'Enter DOB in yyyy-mm-dd format';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Email Field
//                     TextFormField(
//                       controller: emailController,
//                       decoration: const InputDecoration(
//                         labelText: 'Email',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.email, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set curs
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Email is required';
//                         } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                           return 'Enter a valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Password Field
//                     PasswordTextBox(
//                       controller: passwordController,
//                       onChanged: (value) {},
//                       decoration: const InputDecoration(
//                         labelText: 'Password',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.lock, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // PAN Field
//                     TextFormField(
//                       controller: panController,
//                       decoration: const InputDecoration(
//                         labelText: 'PAN',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.credit_card, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray),
//                       cursorColor: AppColors.charcoalGray,
//                       keyboardType: TextInputType.text,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       validator: (value) {
//                         final rawValue = value?.replaceAll(' ', '');
//                         if (rawValue == null || rawValue.isEmpty) {
//                           return 'PAN is required';
//                         } else if (rawValue.length != 10) {
//                           return 'PAN must be exactly 10 characters';
//                         } else if (!RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$').hasMatch(rawValue)) {
//                           return 'Enter a valid PAN';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Aadhaar Field
//                     TextFormField(
//                       controller: aadhaarController,
//                       decoration: const InputDecoration(
//                         labelText: 'Aadhaar',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.fingerprint, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set curs
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         AadhaarInputFormatter(),
//                         LengthLimitingTextInputFormatter(14),
//                       ],
//                       validator: (value) {
//                         final rawValue = value?.replaceAll(' ', '');
//                         if (rawValue == null || rawValue.isEmpty) {
//                           return 'Aadhaar is required';
//                         } else if (rawValue.length != 12) {
//                           return 'Aadhaar must be exactly 12 digits';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Contact Field
//                     TextFormField(
//                       controller: contactController,
//                       decoration: const InputDecoration(
//                         labelText: 'Contact Number',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.phone, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set curs
//                       keyboardType: TextInputType.phone,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Contact Number is required';
//                         } else if (value.length != 10) {
//                           return 'Enter a valid 10-digit phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Alternate Contact Field
//                     TextFormField(
//                       controller: alternateContactController,
//                       decoration: const InputDecoration(
//                         labelText: 'Alternate Contact Number',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.phone, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set curs
//                       keyboardType: TextInputType.phone,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       validator: (value) {
//                         if (value != null && value.isNotEmpty && value.length != 10) {
//                           return 'Enter a valid 10-digit phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Designation Field as DropdownButtonFormField
//                     DropdownButtonFormField<String>(
//                       value: (['Fullstack', 'Frontend Developer', 'Backend Developer', 'Co-ordinator']
//                               .contains(designationController.text))
//                           ? designationController.text
//                           : null,
//                       onChanged: (newValue) {
//                         designationController.text = newValue ?? '';
//                       },
//                       items: const [
//                         DropdownMenuItem(
//                           value: 'Fullstack',
//                           child: Text('Fullstack'),
//                         ),
//                         DropdownMenuItem(
//                           value: 'Frontend Developer',
//                           child: Text('Frontend Developer'),
//                         ),
//                         DropdownMenuItem(
//                           value: 'Backend Developer',
//                           child: Text('Backend Developer'),
//                         ),
//                         DropdownMenuItem(
//                           value: 'Co-ordinator',
//                           child: Text('Co-ordinator'),
//                         ),
//                       ],
//                       decoration: const InputDecoration(
//                         labelText: 'Designation',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.work, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray),
//                       dropdownColor: AppColors.white,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Designation is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Salary Field
//                     TextFormField(
//                       controller: salaryController,
//                       decoration: const InputDecoration(
//                         labelText: 'Salary',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray), // Label color
//                         prefixIcon: Icon(Icons.money, color: AppColors.slateTeal), // Icon color set to slateTeal
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal), // Focused underline color
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal), // Enabled underline color
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color
//                       cursorColor: AppColors.charcoalGray, // Set cursor color
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
//                       ],
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Salary is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Joining Date Field with Underline and Icon Color
//                     TextFormField(
//                       controller: joiningDateController,
//                       decoration: const InputDecoration(
//                         labelText: 'Joining Date (yyyy-mm-dd)',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray), // Label color
//                         prefixIcon: Icon(Icons.calendar_today, color: AppColors.slateTeal), // Icon color set to slateTeal
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal), // Focused underline color
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.slateTeal), // Enabled underline color
//                         ),
//                       ),
//                       keyboardType: TextInputType.datetime,
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color
//                       cursorColor: AppColors.charcoalGray, // Set cursor color
//                       inputFormatters: [
//                         JoiningDateInputFormatter(), // Custom formatter for date input
//                         LengthLimitingTextInputFormatter(10), // Limit input to 10 characters
//                       ],
//                       validator: (value) {
//                         final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // Corrected regex
//                         if (value == null || value.isEmpty) {
//                           return 'Joining Date is required';
//                         } else if (!regex.hasMatch(value)) {
//                           return 'Enter Joining Date in yyyy-mm-dd format';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Address Field
//                     TextFormField(
//                       controller: addressController,
//                       decoration: const InputDecoration(
//                         labelText: 'Address',
//                         labelStyle: TextStyle(color: AppColors.charcoalGray),
//                         prefixIcon: Icon(Icons.home, color: AppColors.slateTeal),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: AppColors.charcoalGray),
//                         ),
//                       ),
//                       style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
//                       cursorColor: AppColors.charcoalGray, // Set curs
//                       keyboardType: TextInputType.multiline, // Allow alphabetic and numeric input
//                       maxLines: 3,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Address is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     // Photo Display and Upload Button
//                     if (imageData != null && imageData!.isNotEmpty)
//                       Column(
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             height: MediaQuery.of(context).size.width * 0.7,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: AppColors.charcoalGray),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8.0),
//                               child: Image.memory(
//                                 base64Decode(imageData!),
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   print('Failed to load image: $imageData');
//                                   return const Center(
//                                     child: Text(
//                                       'Failed to load image',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () async {
//                               imageData = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ImageUpload(
//                                     onImageUploaded: () {
//                                       // Image upload logic here, no need for state change anymore.
//                                     },
//                                   ),
//                                 ),
//                               );

//                               if (imageData != null) {
//                                 setState(() {
//                                   // Update the state to reflect the new image
//                                 });
//                                 print('Image Data: $imageData');
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: AppColors.lightSkyBlue,
//                               backgroundColor: AppColors.slateTeal,
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: MediaQuery.of(context).size.width * 0.0780, // Dynamic horizontal padding
//                                 vertical: MediaQuery.of(context).size.height * 0.018, // Dynamic vertical padding
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                             ),
//                             child: const Text(
//                               'Edit Image',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     else
//                       Center(
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.7, // Adjust the width to 70% of the screen width
//                           padding: EdgeInsets.symmetric(
//                             horizontal: MediaQuery.of(context).size.width * 0.01, // Dynamic horizontal padding
//                             vertical: MediaQuery.of(context).size.height * 0.02, // Dynamic vertical padding
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               imageData = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ImageUpload(
//                                     onImageUploaded: () {
//                                       // Image upload logic here, no need for state change anymore.
//                                     },
//                                   ),
//                                 ),
//                               );

//                               if (imageData != null) {
//                                 setState(() {
//                                   // Update the state to reflect the new image
//                                 });
//                                 print('Image Data: $imageData');
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               foregroundColor: AppColors.lightSkyBlue,
//                               backgroundColor: AppColors.slateTeal,
//                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ),
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(width: 8.0), // Spacing between icon and text
//                                     Text(
//                                       'Upload Image',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.slateTeal, // Set the background color to darkCharcoal
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () => updateEmployee(),
//                       child: const Text(
//                         'Update',
//                         style: TextStyle(
//                           color: Colors.white, // Text color set to white for contrast with darkCharcoal background
//                         ),
//                       ),
//                     ),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global_API.dart';
import 'dart:convert';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:quick_roll/widgets/image_upload.dart';
import 'package:quick_roll/widgets/password.dart';

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(rawText[i]);
    }
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class DateOfBirthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if ((i == 4 || i == 6) && i < rawText.length) {
        buffer.write('-');
      }
      buffer.write(rawText[i]);
    }
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class JoiningDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawText = newValue.text.replaceAll('-', '');
    final buffer = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if ((i == 4 || i == 6) && i < rawText.length) {
        buffer.write('-');
      }
      buffer.write(rawText[i]);
    }
    final formattedText = buffer.toString();
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
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

class EditEmployeePage extends StatefulWidget {
  final Map employee;

  const EditEmployeePage({super.key, required this.employee});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController alternateContactController =
      TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? imageData;

  @override
  void initState() {
    super.initState();
    idController.text = widget.employee['id']?.toString() ?? '';
    nameController.text = widget.employee['name'] ?? '';
    dobController.text = widget.employee['dob'] ?? '';
    emailController.text = widget.employee['email'] ?? '';
    passwordController.text = widget.employee['password'] ?? '';
    panController.text = widget.employee['pan'] ?? '';
    aadhaarController.text = widget.employee['aadhaar'] ?? '';
    contactController.text = widget.employee['contact'] ?? '';
    alternateContactController.text =
        widget.employee['alternate_contact'] ?? '';
    designationController.text = widget.employee['designation'] ?? '';
    salaryController.text = widget.employee['salary']?.toString() ?? '';
    joiningDateController.text = widget.employee['joining_date'] ?? '';
    addressController.text = widget.employee['address'] ?? '';
    imageData = widget.employee['photo_path'] ?? '';
    print('Initialized Photo Path: $imageData');
  }

  Future<void> updateEmployee() async {
    if (_formKey.currentState!.validate()) {
      if (imageData == null || imageData!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        return;
      }

      final updatedEmployee = {
        'name': nameController.text,
        'dob': dobController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'pan': panController.text,
        'aadhaar': aadhaarController.text,
        'contact': contactController.text,
        'alternate_contact': alternateContactController.text,
        'designation': designationController.text,
        'salary': salaryController.text,
        'joining_date': joiningDateController.text,
        'address': addressController.text,
        'photo_path': imageData,
      };

      final response = await http.put(
        Uri.parse('$baseURL/employees/${widget.employee['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedEmployee),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update employee. Error: ${response.body}')),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.charcoalGray),
      prefixIcon: Icon(icon, color: AppColors.slateTeal),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.charcoalGray),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.charcoalGray),
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: _buildInputDecoration(label: label, icon: icon),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(color: AppColors.charcoalGray),
        cursorColor: AppColors.charcoalGray,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Edit Employee',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, AppColors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            color: AppColors.babyBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.00),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 400.0,
                      decoration: BoxDecoration(
                        color: AppColors.slateTeal,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Edit Employee Details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name Field
                    _buildTextField(
                      controller: nameController,
                      label: 'Name',
                      icon: Icons.person,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    // Date of Birth
                    _buildTextField(
                      controller: dobController,
                      label: 'Date of Birth (yyyy-mm-dd)',
                      icon: Icons.cake,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        DateOfBirthInputFormatter(),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                        if (value == null || value.isEmpty) {
                          return 'Date of Birth is required';
                        } else if (!regex.hasMatch(value)) {
                          return 'Enter DOB in yyyy-mm-dd format';
                        }
                        return null;
                      },
                    ),
                    // Email Field
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    // Password Field
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: PasswordTextBox(
                        controller: passwordController,
                        onChanged: (value) {},
                        decoration: _buildInputDecoration(
                          label: 'Password',
                          icon: Icons.lock,
                        ),
                      ),
                    ),
                    // PAN Field
                    _buildTextField(
                      controller: panController,
                      label: 'PAN',
                      icon: Icons.credit_card,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        final rawValue = value?.replaceAll(' ', '');
                        if (rawValue == null || rawValue.isEmpty) {
                          return 'PAN is required';
                        } else if (rawValue.length != 10) {
                          return 'PAN must be exactly 10 characters';
                        } else if (!RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$')
                            .hasMatch(rawValue)) {
                          return 'Enter a valid PAN';
                        }
                        return null;
                      },
                    ),
                    // Aadhaar Field
                    _buildTextField(
                      controller: aadhaarController,
                      label: 'Aadhaar',
                      icon: Icons.fingerprint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        AadhaarInputFormatter(),
                        LengthLimitingTextInputFormatter(14),
                      ],
                      validator: (value) {
                        final rawValue = value?.replaceAll(' ', '');
                        if (rawValue == null || rawValue.isEmpty) {
                          return 'Aadhaar is required';
                        } else if (rawValue.length != 12) {
                          return 'Aadhaar must be exactly 12 digits';
                        }
                        return null;
                      },
                    ),
                    // Contact Field
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
                        if (value == null || value.isEmpty) {
                          return 'Contact Number is required';
                        } else if (value.length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    // Alternate Contact Field
                    _buildTextField(
                      controller: alternateContactController,
                      label: 'Alternate Contact Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    // Designation Field
                    _buildTextField(
                      controller: designationController,
                      label: 'Designation',
                      icon: Icons.work,
                      inputFormatters: [
                        CapitalizeFirstFormatter(),
                        LengthLimitingTextInputFormatter(17),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Designation is required';
                        }
                        return null;
                      },
                    ),
                    // Salary Field
                    _buildTextField(
                      controller: salaryController,
                      label: 'Salary',
                      icon: Icons.money,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Salary is required';
                        }
                        return null;
                      },
                    ),
                    // Joining Date Field
                    _buildTextField(
                      controller: joiningDateController,
                      label: 'Joining Date (yyyy-mm-dd)',
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        JoiningDateInputFormatter(),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                        if (value == null || value.isEmpty) {
                          return 'Joining Date is required';
                        } else if (!regex.hasMatch(value)) {
                          return 'Enter Joining Date in yyyy-mm-dd format';
                        }
                        return null;
                      },
                    ),
                    // Address Field
                    _buildTextField(
                      controller: addressController,
                      label: 'Address',
                      icon: Icons.home,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Photo Display and Upload Button
                    if (imageData != null && imageData!.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.charcoalGray),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(
                                base64Decode(imageData!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Failed to load image: $imageData');
                                  return const Center(
                                    child: Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              imageData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageUpload(
                                    onImageUploaded: () {},
                                  ),
                                ),
                              );
                              if (imageData != null) {
                                setState(() {});
                                print('Image Data: $imageData');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.lightSkyBlue,
                              backgroundColor: AppColors.slateTeal,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.0780,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Edit Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    else
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              imageData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageUpload(
                                    onImageUploaded: () {},
                                  ),
                                ),
                              );
                              if (imageData != null) {
                                setState(() {});
                                print('Image Data: $imageData');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.lightSkyBlue,
                              backgroundColor: AppColors.slateTeal,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.slateTeal,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => updateEmployee(),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
