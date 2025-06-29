// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class IDCardScreen extends StatelessWidget {
//   const IDCardScreen({super.key});

//   Future<List<Map<String, dynamic>>> fetchEmployees() async {
//     try {
//       // final url = Uri.parse('$baseURL/employees?company_id=$global_cid');
//       final url = Uri.parse('$baseURL/employees/$global_cid');
//       debugPrint('📤 Fetching employees for company_id: $global_cid');
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         final employees = List<Map<String, dynamic>>.from(data);
//         // Client-side filtering as a fallback if server doesn't filter
//         return employees
//             .where((employee) => employee['company_id'] == global_cid)
//             .toList();
//       } else {
//         throw Exception('Failed to load employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching employees: $e');
//       throw Exception('Failed to load employees: $e');
//     }
//   }

//   bool _isBase64(String str) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(str) && (str.length % 4 == 0);
//   }

//   // Decode base64 image string
//   Future<Image> _decodeBase64Image(String base64String) async {
//     try {
//       final Uint8List bytes = base64Decode(base64String);
//       return Image.memory(bytes, fit: BoxFit.cover);
//     } catch (e) {
//       throw Exception('Failed to decode image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Employee ID Cards',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchEmployees(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//                 child: Text('No employees found for this company'));
//           }

//           final employees = snapshot.data!;
//           return ListView.builder(
//             itemCount: employees.length,
//             itemBuilder: (context, index) {
//               final employee = employees[index];
//               final photoPath = employee['photo_path'];

//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                 child: Center(
//                   child: Container(
//                     width: screenWidth > 600
//                         ? screenWidth * 0.5
//                         : screenWidth * 0.8,
//                     padding: EdgeInsets.all(screenWidth * 0.05),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(color: Colors.grey.shade400, blurRadius: 10),
//                       ],
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.grey,
//                           width: 2.0,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: screenHeight * 0.1,
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [AppColors.skyBlue, AppColors.skyBlue],
//                               ),
//                               borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                             ),
//                             child: Center(
//                               child: Image.asset(
//                                 'assets/compony_logo.png',
//                                 width: 60,
//                                 height: 60,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Icon(Icons.business, size: 60),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: photoPath != null && _isBase64(photoPath)
//                                 ? FutureBuilder<Image>(
//                                     future: _decodeBase64Image(photoPath),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return const CircularProgressIndicator();
//                                       } else if (snapshot.hasError ||
//                                           snapshot.data == null) {
//                                         return Icon(
//                                           Icons.person,
//                                           size: screenWidth * 0.25,
//                                           color: Colors.grey,
//                                         );
//                                       }
//                                       return SizedBox(
//                                         height: screenWidth * 0.25,
//                                         width: screenWidth * 0.25,
//                                         child: snapshot.data!,
//                                       );
//                                     },
//                                   )
//                                 : Image.network(
//                                     photoPath ?? '',
//                                     height: screenWidth * 0.25,
//                                     width: screenWidth * 0.25,
//                                     fit: BoxFit.cover,
//                                     errorBuilder:
//                                         (context, error, stackTrace) => Icon(
//                                       Icons.image_not_supported,
//                                       size: screenWidth * 0.25,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//                           Text(
//                             employee['name'] ?? 'No Name',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.05,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.charcoalGray,
//                             ),
//                           ),
//                           Text(
//                             employee['designation'] ?? 'No Designation',
//                             style: TextStyle(
//                               fontSize: screenWidth * 0.04,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const Divider(color: Colors.grey),
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: screenWidth * 0.05),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 InfoRow(
//                                     label: 'ID:',
//                                     value: employee['id']?.toString() ?? 'N/A',
//                                     color: AppColors.charcoalGray),
//                                 InfoRow(
//                                     label: 'EMAIL:',
//                                     value: employee['email'] ?? 'N/A',
//                                     color: AppColors.charcoalGray),
//                                 InfoRow(
//                                     label: 'PHONE:',
//                                     value: employee['contact'] ?? 'N/A',
//                                     color: AppColors.charcoalGray),
//                                 InfoRow(
//                                     label: 'ALTERNATE PHONE:',
//                                     value:
//                                         employee['alternate_contact'] ?? 'N/A',
//                                     color: AppColors.charcoalGray),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const InfoRow({
//     required this.label,
//     required this.value,
//     required this.color,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(value, style: TextStyle(color: color)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class IDCardScreen extends StatefulWidget {
//   const IDCardScreen({super.key});

//   @override
//   State<IDCardScreen> createState() => _IDCardScreenState();
// }

// class _IDCardScreenState extends State<IDCardScreen> {
//   final List<Map<String, dynamic>> employees = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   int page = 1;
//   final int limit = 10;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchEmployees();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !isLoading &&
//           hasMore) {
//         _fetchEmployees();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchEmployees() async {
//     if (isLoading) return;
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final url =
//           Uri.parse('$baseURL/employees/$global_cid?page=$page&limit=$limit');
//       debugPrint(
//           '📤 Fetching employees for company_id: $global_cid, page: $page');
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         final newEmployees = List<Map<String, dynamic>>.from(data);
//         setState(() {
//           employees.addAll(newEmployees
//               .where((employee) => employee['company_id'] == global_cid)
//               .toList());
//           page++;
//           hasMore = newEmployees.length == limit;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         throw Exception('Failed to load employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint('❌ Error fetching employees: $e');
//     }
//   }

//   bool _isBase64(String str) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(str) && (str.length % 4 == 0);
//   }

//   Future<Image> _decodeBase64Image(String base64String) async {
//     try {
//       final Uint8List bytes = base64Decode(base64String);
//       return Image.memory(bytes, fit: BoxFit.cover);
//     } catch (e) {
//       throw Exception('Failed to decode image: $e');
//     }
//   }

//   Future<Uint8List> _loadImageBytes(String path,
//       {bool isNetwork = false}) async {
//     if (isNetwork) {
//       final response = await http.get(Uri.parse(path));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         throw Exception('Failed to load network image');
//       }
//     } else if (_isBase64(path)) {
//       return base64Decode(path);
//     } else {
//       return await DefaultAssetBundle.of(context)
//           .load(path)
//           .then((value) => value.buffer.asUint8List());
//     }
//   }

//   Future<void> _generateAndDownloadPDF(Map<String, dynamic> employee) async {
//     final pdf = pw.Document();
//     final companyLogo = await _loadImageBytes('assets/compony_logo.png');
//     final photoPath = employee['photo_path'];
//     Uint8List? employeePhoto;
//     if (photoPath != null && _isBase64(photoPath)) {
//       employeePhoto = base64Decode(photoPath);
//     } else if (photoPath != null) {
//       try {
//         employeePhoto = await _loadImageBytes(photoPath, isNetwork: true);
//       } catch (e) {
//         debugPrint('Error loading employee photo: $e');
//       }
//     }

//     pdf.addPage(
//       pw.Page(
//         pageFormat:
//             PdfPageFormat(200 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
//         build: (pw.Context context) {
//           return pw.Container(
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey, width: 2),
//               borderRadius: pw.BorderRadius.circular(16),
//             ),
//             child: pw.Column(
//               children: [
//                 // Header with company logo
//                 pw.Container(
//                   height: 60,
//                   decoration: const pw.BoxDecoration(
//                     gradient: pw.LinearGradient(
//                       colors: [PdfColors.blue200, PdfColors.blue200],
//                     ),
//                     borderRadius: pw.BorderRadius.vertical(
//                       top: pw.Radius.circular(16),
//                     ),
//                   ),
//                   child: pw.Center(
//                     child: companyLogo != null
//                         ? pw.Image(pw.MemoryImage(companyLogo),
//                             width: 50, height: 50)
//                         : pw.Icon(pw.IconData(0xe904),
//                             size: 50), // Fallback icon
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 // Employee photo
//                 employeePhoto != null
//                     ? pw.ClipRRect(
//                         horizontalRadius: 8,
//                         verticalRadius: 8,
//                         child: pw.Image(pw.MemoryImage(employeePhoto),
//                             width: 80, height: 80),
//                       )
//                     : pw.Icon(pw.IconData(0xe904),
//                         size: 80, color: PdfColors.grey),
//                 pw.SizedBox(height: 10),
//                 // Employee details
//                 pw.Text(
//                   employee['name'] ?? 'No Name',
//                   style: pw.TextStyle(
//                       fontSize: 16, fontWeight: pw.FontWeight.bold),
//                   textAlign: pw.TextAlign.center,
//                 ),
//                 pw.Text(
//                   employee['designation'] ?? 'No Designation',
//                   style:
//                       const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
//                 ),
//                 pw.Divider(color: PdfColors.grey),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.symmetric(horizontal: 10),
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       _buildPdfInfoRow(
//                           'ID:', employee['id']?.toString() ?? 'N/A'),
//                       _buildPdfInfoRow('EMAIL:', employee['email'] ?? 'N/A'),
//                       _buildPdfInfoRow('PHONE:', employee['contact'] ?? 'N/A'),
//                       _buildPdfInfoRow('ALTERNATE PHONE:',
//                           employee['alternate_contact'] ?? 'N/A'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     await Printing.sharePdf(
//       bytes: await pdf.save(),
//       filename:
//           'ID_Card_${employee['name'] ?? 'employee'}_${employee['id'] ?? 'unknown'}.pdf',
//     );
//   }

//   pw.Widget _buildPdfInfoRow(String label, String value) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 4),
//       child: pw.Row(
//         children: [
//           pw.Expanded(
//             flex: 2,
//             child: pw.Text(
//               label,
//               style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//           pw.Expanded(
//             flex: 3,
//             child: pw.Text(value),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Employee ID Cards',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: employees.length + (hasMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index == employees.length) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final employee = employees[index];
//           final photoPath = employee['photo_path'];

//           return Padding(
//             padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//             child: Center(
//               child: Container(
//                 width:
//                     screenWidth > 600 ? screenWidth * 0.5 : screenWidth * 0.8,
//                 padding: EdgeInsets.all(screenWidth * 0.05),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(color: Colors.grey.shade400, blurRadius: 10),
//                   ],
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 2.0,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: screenHeight * 0.1,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [AppColors.skyBlue, AppColors.skyBlue],
//                           ),
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(20),
//                           ),
//                         ),
//                         child: Center(
//                           child: Image.asset(
//                             'assets/compony_logo.png',
//                             width: 60,
//                             height: 60,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.business, size: 60),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: photoPath != null && _isBase64(photoPath)
//                             ? FutureBuilder<Image>(
//                                 future: _decodeBase64Image(photoPath),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return const CircularProgressIndicator();
//                                   } else if (snapshot.hasError ||
//                                       snapshot.data == null) {
//                                     return Icon(
//                                       Icons.person,
//                                       size: screenWidth * 0.25,
//                                       color: Colors.grey,
//                                     );
//                                   }
//                                   return SizedBox(
//                                     height: screenWidth * 0.25,
//                                     width: screenWidth * 0.25,
//                                     child: snapshot.data!,
//                                   );
//                                 },
//                               )
//                             : Image.network(
//                                 photoPath ?? '',
//                                 height: screenWidth * 0.25,
//                                 width: screenWidth * 0.25,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Icon(
//                                   Icons.image_not_supported,
//                                   size: screenWidth * 0.25,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       Text(
//                         employee['name'] ?? 'No Name',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.05,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.charcoalGray,
//                         ),
//                       ),
//                       Text(
//                         employee['designation'] ?? 'No Designation',
//                         style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const Divider(color: Colors.grey),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: screenWidth * 0.05),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             InfoRow(
//                               label: 'ID:',
//                               value: employee['id']?.toString() ?? 'N/A',
//                               color: AppColors.charcoalGray,
//                             ),
//                             InfoRow(
//                               label: 'EMAIL:',
//                               value: employee['email'] ?? 'N/A',
//                               color: AppColors.charcoalGray,
//                             ),
//                             InfoRow(
//                               label: 'PHONE:',
//                               value: employee['contact'] ?? 'N/A',
//                               color: AppColors.charcoalGray,
//                             ),
//                             InfoRow(
//                               label: 'ALTERNATE PHONE:',
//                               value: employee['alternate_contact'] ?? 'N/A',
//                               color: AppColors.charcoalGray,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: screenHeight * 0.02),
//                       ElevatedButton.icon(
//                         onPressed: () => _generateAndDownloadPDF(employee),
//                         icon: const Icon(Icons.download),
//                         label: const Text('Download ID Card'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.skyBlue,
//                           foregroundColor: AppColors.charcoalGray,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const InfoRow({
//     required this.label,
//     required this.value,
//     required this.color,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(value, style: TextStyle(color: color)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:quick_roll/utils/admin_colors.dart';

// class IDCardScreen extends StatefulWidget {
//   const IDCardScreen({super.key});

//   @override
//   State<IDCardScreen> createState() => _IDCardScreenState();
// }

// class _IDCardScreenState extends State<IDCardScreen> {
//   final List<Map<String, dynamic>> employees = [];
//   List<Map<String, dynamic>> filteredEmployees = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   int page = 1;
//   final int limit = 10;
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchEmployees();
//     filteredEmployees = employees;
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 200 &&
//           !isLoading &&
//           hasMore) {
//         _fetchEmployees();
//       }
//     });
//     _searchController.addListener(_filterEmployees);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchEmployees() async {
//     if (isLoading) return;
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final url =
//           Uri.parse('$baseURL/employees/$global_cid?page=$page&limit=$limit');
//       debugPrint(
//           '📤 Fetching employees for company_id: $global_cid, page: $page');
//       final response = await http.get(url, headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       debugPrint('📥 Response Status: ${response.statusCode}');
//       debugPrint('📥 Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         final newEmployees = List<Map<String, dynamic>>.from(data);
//         setState(() {
//           employees.addAll(newEmployees
//               .where((employee) => employee['company_id'] == global_cid)
//               .toList());
//           filteredEmployees = _searchController.text.isEmpty
//               ? employees
//               : employees
//                   .where((employee) =>
//                       employee['name']
//                           ?.toLowerCase()
//                           .startsWith(_searchController.text.toLowerCase()) ??
//                       false)
//                   .toList();
//           page++;
//           hasMore = newEmployees.length == limit;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         throw Exception('Failed to load employees: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint('❌ Error fetching employees: $e');
//     }
//   }

//   void _filterEmployees() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredEmployees = employees
//           .where((employee) =>
//               employee['name']?.toLowerCase().startsWith(query) ?? false)
//           .toList();
//     });
//   }

//   bool _isBase64(String str) {
//     final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
//     return base64Regex.hasMatch(str) && (str.length % 4 == 0);
//   }

//   Future<Image> _decodeBase64Image(String base64String) async {
//     try {
//       final Uint8List bytes = base64Decode(base64String);
//       return Image.memory(bytes, fit: BoxFit.cover);
//     } catch (e) {
//       throw Exception('Failed to decode image: $e');
//     }
//   }

//   Future<Uint8List> _loadImageBytes(String path,
//       {bool isNetwork = false}) async {
//     if (isNetwork) {
//       final response = await http.get(Uri.parse(path));
//       if (response.statusCode == 200) {
//         return response.bodyBytes;
//       } else {
//         throw Exception('Failed to load network image');
//       }
//     } else if (_isBase64(path)) {
//       return base64Decode(path);
//     } else {
//       return await DefaultAssetBundle.of(context)
//           .load(path)
//           .then((value) => value.buffer.asUint8List());
//     }
//   }

//   Future<void> _generateAndDownloadPDF(Map<String, dynamic> employee) async {
//     final pdf = pw.Document();
//     final companyLogo = await _loadImageBytes('assets/compony_logo.png');
//     final photoPath = employee['photo_path'];
//     Uint8List? employeePhoto;
//     if (photoPath != null && _isBase64(photoPath)) {
//       employeePhoto = base64Decode(photoPath);
//     } else if (photoPath != null) {
//       try {
//         employeePhoto = await _loadImageBytes(photoPath, isNetwork: true);
//       } catch (e) {
//         debugPrint('Error loading employee photo: $e');
//       }
//     }

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat(50 * PdfPageFormat.mm, 80 * PdfPageFormat.mm),
//         margin: const pw.EdgeInsets.all(2),
//         build: (pw.Context context) {
//           return pw.Container(
//             decoration: pw.BoxDecoration(
//               border: pw.Border.all(color: PdfColors.grey, width: 1),
//               borderRadius: pw.BorderRadius.circular(8),
//               color: PdfColors.white,
//             ),
//             child: pw.Column(
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               children: [
//                 // Header with company logo
//                 pw.Container(
//                   height: 15,
//                   decoration: const pw.BoxDecoration(
//                     gradient: pw.LinearGradient(
//                       colors: [PdfColors.blue200, PdfColors.blue200],
//                     ),
//                     borderRadius: pw.BorderRadius.vertical(
//                       top: pw.Radius.circular(8),
//                     ),
//                   ),
//                   child: pw.Center(
//                     child: companyLogo != null
//                         ? pw.Image(pw.MemoryImage(companyLogo),
//                             width: 20, height: 20)
//                         : pw.Icon(pw.IconData(0xe904),
//                             size: 20, color: PdfColors.grey),
//                   ),
//                 ),
//                 pw.SizedBox(height: 4),
//                 // Employee photo
//                 employeePhoto != null
//                     ? pw.ClipRRect(
//                         horizontalRadius: 4,
//                         verticalRadius: 4,
//                         child: pw.Image(pw.MemoryImage(employeePhoto),
//                             width: 25, height: 25),
//                       )
//                     : pw.Icon(pw.IconData(0xe904),
//                         size: 25, color: PdfColors.grey),
//                 pw.SizedBox(height: 4),
//                 // Employee details
//                 pw.Text(
//                   employee['name'] ?? 'No Name',
//                   style:
//                       pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
//                   textAlign: pw.TextAlign.center,
//                   maxLines: 1,
//                 ),
//                 pw.Text(
//                   employee['designation'] ?? 'No Designation',
//                   style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey),
//                   maxLines: 1,
//                 ),
//                 pw.Divider(color: PdfColors.grey, height: 2, thickness: 0.5),
//                 pw.Padding(
//                   padding: const pw.EdgeInsets.symmetric(horizontal: 4),
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       _buildPdfInfoRow(
//                           'ID:', employee['id']?.toString() ?? 'N/A', 6, 5),
//                       _buildPdfInfoRow(
//                           'EMAIL:', employee['email'] ?? 'N/A', 6, 5),
//                       _buildPdfInfoRow(
//                           'PHONE:', employee['contact'] ?? 'N/A', 6, 5),
//                       _buildPdfInfoRow('ALTERNATE PHONE:',
//                           employee['alternate_contact'] ?? 'N/A', 6, 5),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     await Printing.sharePdf(
//       bytes: await pdf.save(),
//       filename:
//           'ID_Card_${employee['name'] ?? 'employee'}_${employee['id'] ?? 'unknown'}.pdf',
//     );
//   }

//   pw.Widget _buildPdfInfoRow(
//       String label, String value, double labelSize, double valueSize) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 1),
//       child: pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Expanded(
//             flex: 2,
//             child: pw.Text(
//               label,
//               style: pw.TextStyle(
//                   fontSize: labelSize, fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//           pw.Expanded(
//             flex: 3,
//             child: pw.Text(
//               value,
//               style: pw.TextStyle(fontSize: valueSize),
//               maxLines: 2,
//               overflow: pw.TextOverflow.clip,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.skyBlue,
//         title: const Text(
//           'Employee ID Cards',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: AppColors.charcoalGray,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.04,
//           vertical: screenHeight * 0.02,
//         ),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search by name',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Expanded(
//               child: filteredEmployees.isEmpty && !isLoading
//                   ? const Center(child: Text('No employees found'))
//                   : ListView.builder(
//                       controller: _scrollController,
//                       itemCount: filteredEmployees.length +
//                           (hasMore && _searchController.text.isEmpty ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == filteredEmployees.length &&
//                             _searchController.text.isEmpty) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }

//                         final employee = filteredEmployees[index];
//                         final photoPath = employee['photo_path'];

//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.02),
//                           child: Center(
//                             child: Container(
//                               width: screenWidth > 600
//                                   ? screenWidth * 0.5
//                                   : screenWidth * 0.8,
//                               padding: EdgeInsets.all(screenWidth * 0.05),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Colors.grey.shade400,
//                                       blurRadius: 10),
//                                 ],
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                       color: Colors.grey, width: 2.0),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                       height: screenHeight * 0.1,
//                                       decoration: const BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             AppColors.skyBlue,
//                                             AppColors.skyBlue
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(20)),
//                                       ),
//                                       child: Center(
//                                         child: Image.asset(
//                                           'assets/compony_logo.png',
//                                           width: 60,
//                                           height: 60,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   const Icon(Icons.business,
//                                                       size: 60),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.02),
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       child: photoPath != null &&
//                                               _isBase64(photoPath)
//                                           ? FutureBuilder<Image>(
//                                               future:
//                                                   _decodeBase64Image(photoPath),
//                                               builder: (context, snapshot) {
//                                                 if (snapshot.connectionState ==
//                                                     ConnectionState.waiting) {
//                                                   return const CircularProgressIndicator();
//                                                 } else if (snapshot.hasError ||
//                                                     snapshot.data == null) {
//                                                   return Icon(
//                                                     Icons.person,
//                                                     size: screenWidth * 0.25,
//                                                     color: Colors.grey,
//                                                   );
//                                                 }
//                                                 return SizedBox(
//                                                   height: screenWidth * 0.25,
//                                                   width: screenWidth * 0.25,
//                                                   child: snapshot.data!,
//                                                 );
//                                               },
//                                             )
//                                           : Image.network(
//                                               photoPath ?? '',
//                                               height: screenWidth * 0.25,
//                                               width: screenWidth * 0.25,
//                                               fit: BoxFit.cover,
//                                               errorBuilder: (context, error,
//                                                       stackTrace) =>
//                                                   Icon(
//                                                 Icons.image_not_supported,
//                                                 size: screenWidth * 0.25,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.02),
//                                     Text(
//                                       employee['name'] ?? 'No Name',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.05,
//                                         fontWeight: FontWeight.bold,
//                                         color: AppColors.charcoalGray,
//                                       ),
//                                     ),
//                                     Text(
//                                       employee['designation'] ??
//                                           'No Designation',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.04,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     const Divider(color: Colors.grey),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: screenWidth * 0.05),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           InfoRow(
//                                             label: 'ID:',
//                                             value: employee['id']?.toString() ??
//                                                 'N/A',
//                                             color: AppColors.charcoalGray,
//                                           ),
//                                           InfoRow(
//                                             label: 'EMAIL:',
//                                             value: employee['email'] ?? 'N/A',
//                                             color: AppColors.charcoalGray,
//                                           ),
//                                           InfoRow(
//                                             label: 'PHONE:',
//                                             value: employee['contact'] ?? 'N/A',
//                                             color: AppColors.charcoalGray,
//                                           ),
//                                           InfoRow(
//                                             label: 'ALTERNATE PHONE:',
//                                             value:
//                                                 employee['alternate_contact'] ??
//                                                     'N/A',
//                                             color: AppColors.charcoalGray,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: screenHeight * 0.02),
//                                     ElevatedButton.icon(
//                                       onPressed: () =>
//                                           _generateAndDownloadPDF(employee),
//                                       icon: const Icon(Icons.download),
//                                       label: const Text('Download ID Card'),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.skyBlue,
//                                         foregroundColor: AppColors.charcoalGray,
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16, vertical: 8),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;

//   const InfoRow({
//     required this.label,
//     required this.value,
//     required this.color,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(fontWeight: FontWeight.bold, color: color),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(value, style: TextStyle(color: color)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quick_roll/services/global.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class IDCardScreen extends StatefulWidget {
  const IDCardScreen({super.key});

  @override
  State<IDCardScreen> createState() => _IDCardScreenState();
}

class _IDCardScreenState extends State<IDCardScreen> {
  final List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filteredEmployees = [];
  String? companyLogo; // Store company_logo from API
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  final int limit = 10;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    filteredEmployees = employees;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore &&
          _searchController.text.isEmpty) {
        _fetchEmployees();
      }
    });
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployees() async {
    if (isLoading || globalCid == null) {
      setState(() {
        _errorMessage = globalCid == null ? 'Company ID is not set' : null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    try {
      final url =
          Uri.parse('$baseURL/employees/$globalCid?page=$page&limit=$limit');
      debugPrint(
          '📤 Fetching employees for company_id: $globalCid, page: $page');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> newEmployees = responseData['employees'] ?? [];
        setState(() {
          companyLogo ??=
              responseData['company_logo']; // Set only if not already set
          employees.addAll(List<Map<String, dynamic>>.from(newEmployees));
          filteredEmployees = _searchController.text.isEmpty
              ? employees
              : employees
                  .where((employee) =>
                      employee['name']
                          ?.toLowerCase()
                          .startsWith(_searchController.text.toLowerCase()) ??
                      false)
                  .toList();
          page++;
          hasMore = newEmployees.length == limit;
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'No employees found for this company';
          hasMore = false;
          isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load employees: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching employees: $e';
        isLoading = false;
      });
      debugPrint('❌ Error fetching employees: $e');
    }
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredEmployees = employees
          .where((employee) =>
              employee['name']?.toLowerCase().startsWith(query) ?? false)
          .toList();
    });
  }

  bool _isBase64(String? str) {
    if (str == null) return false;
    // Handle Data URL format (e.g., data:image/jpeg;base64,...)
    if (str.startsWith('data:image/')) {
      final base64Part = str.split(',').last;
      final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
      return base64Regex.hasMatch(base64Part) && (base64Part.length % 4 == 0);
    }
    // Handle plain Base64 string
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Regex.hasMatch(str) && (str.length % 4 == 0);
  }

  Future<Uint8List> _loadImageBytes(String? path,
      {bool isNetwork = false}) async {
    if (path == null) {
      throw Exception('Image path is null');
    }
    if (isNetwork) {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load network image: ${response.statusCode}');
      }
    } else if (path.startsWith('data:image/')) {
      // Handle Data URL by extracting Base64 part
      final base64String = path.split(',').last;
      return base64Decode(base64String);
    } else if (_isBase64(path)) {
      return base64Decode(path);
    } else {
      return await DefaultAssetBundle.of(context)
          .load(path)
          .then((value) => value.buffer.asUint8List());
    }
  }

  Future<Widget> _buildCompanyLogoWidget(
      {double width = 60, double height = 60}) async {
    if (companyLogo == null) {
      return const Icon(Icons.business, size: 60, color: Colors.grey);
    }
    try {
      final bytes = await _loadImageBytes(companyLogo,
          isNetwork: !(_isBase64(companyLogo) ||
              companyLogo!.startsWith('data:image/')));
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error rendering company logo: $error');
          return const Icon(Icons.business, size: 60, color: Colors.grey);
        },
      );
    } catch (e) {
      debugPrint('Error loading company logo for UI: $e');
      return const Icon(Icons.business, size: 60, color: Colors.grey);
    }
  }

  Future<Widget> _buildImageWidget(String? path,
      {double width = 60, double height = 60}) async {
    if (path == null) {
      return const Icon(Icons.image_not_supported,
          size: 60, color: Colors.grey);
    }
    try {
      final bytes = await _loadImageBytes(path,
          isNetwork: !(_isBase64(path) || path.startsWith('data:image/')));
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error rendering employee photo: $error');
          return const Icon(Icons.image_not_supported,
              size: 60, color: Colors.grey);
        },
      );
    } catch (e) {
      debugPrint('Error loading employee photo for UI: $e');
      return const Icon(Icons.image_not_supported,
          size: 60, color: Colors.grey);
    }
  }

  Future<void> _generateAndDownloadPDF(Map<String, dynamic> employee) async {
    final pdf = pw.Document();
    Uint8List? companyLogoBytes;
    Uint8List? employeePhoto;

    // Load company logo
    try {
      if (companyLogo != null) {
        companyLogoBytes = await _loadImageBytes(companyLogo,
            isNetwork: !(_isBase64(companyLogo) ||
                companyLogo!.startsWith('data:image/')));
      }
    } catch (e) {
      debugPrint('Error loading company logo for PDF: $e');
    }

    // Load employee photo
    final photoPath = employee['photo_path'];
    if (photoPath != null) {
      try {
        employeePhoto = await _loadImageBytes(photoPath,
            isNetwork:
                !(_isBase64(photoPath) || photoPath.startsWith('data:image/')));
      } catch (e) {
        debugPrint('Error loading employee photo for PDF: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(50 * PdfPageFormat.mm, 80 * PdfPageFormat.mm),
        margin: const pw.EdgeInsets.all(2),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 1),
              borderRadius: pw.BorderRadius.circular(8),
              color: PdfColors.white,
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                // Header with company logo
                pw.Container(
                  height: 15,
                  decoration: const pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [PdfColors.blue200, PdfColors.blue200],
                    ),
                    borderRadius:
                        pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
                  ),
                  child: pw.Center(
                    child: companyLogoBytes != null
                        ? pw.Image(pw.MemoryImage(companyLogoBytes),
                            width: 20, height: 20)
                        : pw.Icon(pw.IconData(0xe904),
                            size: 20, color: PdfColors.grey),
                  ),
                ),
                pw.SizedBox(height: 4),
                // Employee photo
                employeePhoto != null
                    ? pw.ClipRRect(
                        horizontalRadius: 4,
                        verticalRadius: 4,
                        child: pw.Image(pw.MemoryImage(employeePhoto),
                            width: 25, height: 25),
                      )
                    : pw.Icon(pw.IconData(0xe904),
                        size: 25, color: PdfColors.grey),
                pw.SizedBox(height: 4),
                // Employee details
                pw.Text(
                  employee['name'] ?? 'No Name',
                  style:
                      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                  maxLines: 1,
                ),
                pw.Text(
                  employee['designation'] ?? 'No Designation',
                  style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey),
                  maxLines: 1,
                ),
                pw.Divider(color: PdfColors.grey, height: 2, thickness: 0.5),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPdfInfoRow(
                          'ID:', employee['id']?.toString() ?? 'N/A', 6, 5),
                      _buildPdfInfoRow(
                          'EMAIL:', employee['email'] ?? 'N/A', 6, 5),
                      _buildPdfInfoRow(
                          'PHONE:', employee['contact'] ?? 'N/A', 6, 5),
                      _buildPdfInfoRow('ALTERNATE PHONE:',
                          employee['alternate_contact'] ?? 'N/A', 6, 5),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'ID_Card_${employee['name'] ?? 'employee'}_${employee['id'] ?? 'unknown'}.pdf',
    );
  }

  pw.Widget _buildPdfInfoRow(
      String label, String value, double labelSize, double valueSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                  fontSize: labelSize, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: valueSize),
              maxLines: 2,
              overflow: pw.TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Employee ID Cards',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: isLoading && employees.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _fetchEmployees,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredEmployees.isEmpty
                          ? const Center(child: Text('No employees found'))
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: filteredEmployees.length +
                                  (hasMore && _searchController.text.isEmpty
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index == filteredEmployees.length &&
                                    _searchController.text.isEmpty) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final employee = filteredEmployees[index];
                                final photoPath = employee['photo_path'];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.02),
                                  child: Center(
                                    child: Container(
                                      width: screenWidth > 600
                                          ? screenWidth * 0.5
                                          : screenWidth * 0.8,
                                      padding:
                                          EdgeInsets.all(screenWidth * 0.05),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              blurRadius: 10),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: Colors.grey, width: 2.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: screenHeight * 0.1,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.skyBlue,
                                                    AppColors.skyBlue
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              child: Center(
                                                child: FutureBuilder<Widget>(
                                                  future:
                                                      _buildCompanyLogoWidget(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                            .hasError ||
                                                        snapshot.data == null) {
                                                      return const Icon(
                                                          Icons.business,
                                                          size: 60,
                                                          color: Colors.grey);
                                                    }
                                                    return snapshot.data!;
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: FutureBuilder<Widget>(
                                                future: _buildImageWidget(
                                                  photoPath,
                                                  width: screenWidth * 0.25,
                                                  height: screenWidth * 0.25,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot
                                                          .hasError ||
                                                      snapshot.data == null) {
                                                    return Icon(
                                                      Icons.image_not_supported,
                                                      size: screenWidth * 0.25,
                                                      color: Colors.grey,
                                                    );
                                                  }
                                                  return SizedBox(
                                                    height: screenWidth * 0.25,
                                                    width: screenWidth * 0.25,
                                                    child: snapshot.data!,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Text(
                                              employee['name'] ?? 'No Name',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.05,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.charcoalGray,
                                              ),
                                            ),
                                            Text(
                                              employee['designation'] ??
                                                  'No Designation',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Divider(color: Colors.grey),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenWidth * 0.05),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InfoRow(
                                                    label: 'ID:',
                                                    value: employee['id']
                                                            ?.toString() ??
                                                        'N/A',
                                                    color:
                                                        AppColors.charcoalGray,
                                                  ),
                                                  InfoRow(
                                                    label: 'EMAIL:',
                                                    value: employee['email'] ??
                                                        'N/A',
                                                    color:
                                                        AppColors.charcoalGray,
                                                  ),
                                                  InfoRow(
                                                    label: 'PHONE:',
                                                    value:
                                                        employee['contact'] ??
                                                            'N/A',
                                                    color:
                                                        AppColors.charcoalGray,
                                                  ),
                                                  InfoRow(
                                                    label: 'ALTERNATE PHONE:',
                                                    value: employee[
                                                            'alternate_contact'] ??
                                                        'N/A',
                                                    color:
                                                        AppColors.charcoalGray,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _generateAndDownloadPDF(
                                                      employee),
                                              icon: const Icon(Icons.download),
                                              label: const Text(
                                                  'Download ID Card'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.skyBlue,
                                                foregroundColor:
                                                    AppColors.charcoalGray,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const InfoRow({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
