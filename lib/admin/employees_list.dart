// import 'dart:typed_data';

// import 'package:quick_roll/admin/user_registration.dart';
// import 'package:quick_roll/services/global_API.dart' as globalService;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/utils/admin_colors.dart';
// import 'dart:convert';
// import '../utils/edit_employee.dart'; // Adjust the file path as needed
// import '../utils/delete_employee.dart'; // Adjust the file path as needed

// class ViewEmployeesPage extends StatefulWidget {
//   const ViewEmployeesPage({super.key});

//   @override
//   _ViewEmployeesPageState createState() => _ViewEmployeesPageState();
// }

// class _ViewEmployeesPageState extends State<ViewEmployeesPage> {
//   List employees = [];
//   List filteredEmployees = [];
//   String searchText = "";

//   Future<void> fetchEmployees() async {
//     final response =
//         await http.get(Uri.parse('${globalService.baseURL}/employees'));
//     if (response.statusCode == 200) {
//       setState(() {
//         employees = json.decode(response.body);
//         filteredEmployees = employees;
//       });
//     }
//   }

//   void filterEmployees(String query) {
//     setState(() {
//       searchText = query;
//       filteredEmployees = employees.where((employee) {
//         return employee['designation']
//                 .toLowerCase()
//                 .contains(query.toLowerCase()) ||
//             employee['email'].toLowerCase().contains(query.toLowerCase()) ||
//             employee['name'].toLowerCase().contains(query.toLowerCase());
//       }).toList();
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

//   @override
//   void initState() {
//     super.initState();
//     fetchEmployees();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'QUICK ROLL',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: AppColors.charcoalGray,
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.skyBlue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.04,
//           vertical: screenHeight * 0.02,
//         ),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: filterEmployees,
//               decoration: InputDecoration(
//                 labelText: 'Search by designation, email, or name',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Expanded(
//               child: filteredEmployees.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                       itemCount: filteredEmployees.length,
//                       itemBuilder: (context, index) {
//                         final employee = filteredEmployees[index];
//                         final photoPath =
//                             employee['photo_path']; // Base64 or URL

//                         return Card(
//                           elevation: 4,
//                           margin: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.01),
//                           color: AppColors.babyBlue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(screenWidth * 0.04),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: photoPath != null &&
//                                           _isBase64(photoPath)
//                                       ? FutureBuilder<Image>(
//                                           future: _decodeBase64Image(photoPath),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return SizedBox(
//                                                 height: screenWidth * 0.25,
//                                                 width: screenWidth * 0.25,
//                                                 child: const Center(
//                                                     child:
//                                                         CircularProgressIndicator()),
//                                               );
//                                             } else if (snapshot.hasError ||
//                                                 snapshot.data == null) {
//                                               return Icon(
//                                                 Icons.image_not_supported,
//                                                 size: screenWidth * 0.25,
//                                                 color: AppColors.charcoalGray,
//                                               );
//                                             }
//                                             return SizedBox(
//                                               height: screenWidth * 0.25,
//                                               width: screenWidth * 0.25,
//                                               child: snapshot.data!,
//                                             );
//                                           },
//                                         )
//                                       : Image.network(
//                                           photoPath ??
//                                               '', // Fallback to URL if it's not Base64
//                                           height: screenWidth * 0.25,
//                                           width: screenWidth * 0.25,
//                                           fit: BoxFit.cover,
//                                           errorBuilder:
//                                               (context, error, stackTrace) =>
//                                                   Icon(
//                                             Icons.image_not_supported,
//                                             size: screenWidth * 0.25,
//                                             color: AppColors.charcoalGray,
//                                           ),
//                                         ),
//                                 ),
//                                 SizedBox(width: screenWidth * 0.04),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         employee['name'],
//                                         style: TextStyle(
//                                           fontSize: screenWidth * 0.045,
//                                           fontWeight: FontWeight.bold,
//                                           color: AppColors.charcoalGray,
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.01),
//                                       Text(
//                                         'Designation: ${employee['designation']}',
//                                         style: const TextStyle(
//                                             color: AppColors.charcoalGray),
//                                       ),
//                                       SizedBox(height: screenHeight * 0.01),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           IconButton(
//                                             icon: const Icon(Icons.edit,
//                                                 color: AppColors.charcoalGray),
//                                             onPressed: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         EditEmployeePage(
//                                                             employee:
//                                                                 employee)),
//                                               ).then((_) => fetchEmployees());
//                                             },
//                                           ),
//                                           IconButton(
//                                             icon: const Icon(Icons.delete,
//                                                 color: AppColors.charcoalGray),
//                                             onPressed: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (context) =>
//                                                     DeleteEmployeePage(
//                                                   employeeId: employee[
//                                                       'id'], // Updated to match DeleteEmployeePage's parameter
//                                                   onDeleteSuccess:
//                                                       fetchEmployees,
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.charcoalGray,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => RegistrationScreen()),
//           ).then((_) => fetchEmployees());
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:quick_roll/services/global.dart' as globalService;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/admin/user_registration.dart';
// import 'package:quick_roll/services/global_API.dart' as globalService;
// import 'package:quick_roll/utils/admin_colors.dart';
// import '../utils/edit_employee.dart'; // Adjust the file path as needed
// import '../utils/delete_employee.dart'; // Adjust the file path as needed

// class ViewEmployeesPage extends StatefulWidget {
//   const ViewEmployeesPage({super.key});

//   @override
//   _ViewEmployeesPageState createState() => _ViewEmployeesPageState();
// }

// class _ViewEmployeesPageState extends State<ViewEmployeesPage> {
//   List employees = [];
//   List filteredEmployees = [];
//   String searchText = "";
//   bool _isLoading = true;
//   String? _errorMessage;

//   Future<void> _loadCompanyIdIfNeeded() async {
//     if (globalService.global_cid == null ||
//         globalService.global_cid.toString().isEmpty) {
//       final prefs = await SharedPreferences.getInstance();
//       final savedCid = prefs.getString('company_id');
//       if (savedCid != null && savedCid.isNotEmpty) {
//         globalService.global_cid = int.parse(savedCid);
//       }
//     }
//   }

//   Future<void> fetchEmployees() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Save company_id to SharedPreferences if available
//       if (globalService.global_cid != null &&
//           globalService.global_cid.toString().isNotEmpty) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(
//             'company_id', globalService.global_cid.toString());
//       }

//       final response = await http.get(
//         Uri.parse(
//             '${globalService.baseURL}/employees/${globalService.global_cid}'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           employees = json.decode(response.body);
//           filteredEmployees = employees;
//           _isLoading = false;
//         });
//       } else if (response.statusCode == 404) {
//         setState(() {
//           _errorMessage = 'No employees found for this company';
//           employees = [];
//           filteredEmployees = [];
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Failed to load employees: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   void filterEmployees(String query) {
//     setState(() {
//       searchText = query;
//       filteredEmployees = employees.where((employee) {
//         return employee['designation']
//                 .toLowerCase()
//                 .contains(query.toLowerCase()) ||
//             employee['email'].toLowerCase().contains(query.toLowerCase()) ||
//             employee['name'].toLowerCase().contains(query.toLowerCase());
//       }).toList();
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

//   @override
//   void initState() {
//     super.initState();
//     _loadCompanyIdIfNeeded().then((_) => fetchEmployees());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'QUICK ROLL',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: AppColors.charcoalGray,
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.skyBlue,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: screenWidth * 0.04,
//           vertical: screenHeight * 0.02,
//         ),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: filterEmployees,
//               decoration: InputDecoration(
//                 labelText: 'Search by designation, email, or name',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Expanded(
//               child: _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : _errorMessage != null
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 _errorMessage!,
//                                 style: const TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: fetchEmployees,
//                                 child: const Text('Retry'),
//                               ),
//                             ],
//                           ),
//                         )
//                       : filteredEmployees.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No employees found',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: AppColors.charcoalGray,
//                                 ),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: filteredEmployees.length,
//                               itemBuilder: (context, index) {
//                                 final employee = filteredEmployees[index];
//                                 final photoPath = employee['photo_path'];

//                                 return Card(
//                                   elevation: 4,
//                                   margin: EdgeInsets.symmetric(
//                                       vertical: screenHeight * 0.01),
//                                   color: AppColors.babyBlue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(screenWidth * 0.04),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           child: photoPath != null &&
//                                                   _isBase64(photoPath)
//                                               ? FutureBuilder<Image>(
//                                                   future: _decodeBase64Image(
//                                                       photoPath),
//                                                   builder: (context, snapshot) {
//                                                     if (snapshot
//                                                             .connectionState ==
//                                                         ConnectionState
//                                                             .waiting) {
//                                                       return SizedBox(
//                                                         height:
//                                                             screenWidth * 0.25,
//                                                         width:
//                                                             screenWidth * 0.25,
//                                                         child: const Center(
//                                                             child:
//                                                                 CircularProgressIndicator()),
//                                                       );
//                                                     } else if (snapshot
//                                                             .hasError ||
//                                                         snapshot.data == null) {
//                                                       return Icon(
//                                                         Icons
//                                                             .image_not_supported,
//                                                         size:
//                                                             screenWidth * 0.25,
//                                                         color: AppColors
//                                                             .charcoalGray,
//                                                       );
//                                                     }
//                                                     return SizedBox(
//                                                       height:
//                                                           screenWidth * 0.25,
//                                                       width: screenWidth * 0.25,
//                                                       child: snapshot.data!,
//                                                     );
//                                                   },
//                                                 )
//                                               : Image.network(
//                                                   photoPath ?? '',
//                                                   height: screenWidth * 0.25,
//                                                   width: screenWidth * 0.25,
//                                                   fit: BoxFit.cover,
//                                                   errorBuilder: (context, error,
//                                                           stackTrace) =>
//                                                       Icon(
//                                                     Icons.image_not_supported,
//                                                     size: screenWidth * 0.25,
//                                                     color:
//                                                         AppColors.charcoalGray,
//                                                   ),
//                                                 ),
//                                         ),
//                                         SizedBox(width: screenWidth * 0.04),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 employee['name'],
//                                                 style: TextStyle(
//                                                   fontSize: screenWidth * 0.045,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: AppColors.charcoalGray,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                   height: screenHeight * 0.01),
//                                               Text(
//                                                 'Designation: ${employee['designation']}',
//                                                 style: const TextStyle(
//                                                     color:
//                                                         AppColors.charcoalGray),
//                                               ),
//                                               SizedBox(
//                                                   height: screenHeight * 0.01),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 children: [
//                                                   IconButton(
//                                                     icon: const Icon(Icons.edit,
//                                                         color: AppColors
//                                                             .charcoalGray),
//                                                     onPressed: () {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 EditEmployeePage(
//                                                                     employee:
//                                                                         employee)),
//                                                       ).then((_) =>
//                                                           fetchEmployees());
//                                                     },
//                                                   ),
//                                                   IconButton(
//                                                     icon: const Icon(
//                                                         Icons.delete,
//                                                         color: AppColors
//                                                             .charcoalGray),
//                                                     onPressed: () {
//                                                       showDialog(
//                                                         context: context,
//                                                         builder: (context) =>
//                                                             DeleteEmployeePage(
//                                                           employeeId:
//                                                               employee['id'],
//                                                           onDeleteSuccess:
//                                                               fetchEmployees,
//                                                         ),
//                                                       );
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.charcoalGray,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => RegistrationScreen()),
//           ).then((_) => fetchEmployees());
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'dart:convert';
import 'package:quick_roll/admin/employee_signup_flow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/services/global.dart' as globalService;
import 'package:quick_roll/admin/user_registration.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import '../utils/edit_employee.dart'; // Adjust the file path as needed
import '../utils/delete_employee.dart'; // Adjust the file path as needed

class ViewEmployeesPage extends StatefulWidget {
  const ViewEmployeesPage({super.key});

  @override
  _ViewEmployeesPageState createState() => _ViewEmployeesPageState();
}

class _ViewEmployeesPageState extends State<ViewEmployeesPage> {
  List employees = [];
  List filteredEmployees = [];
  String searchText = "";
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _loadCompanyIdIfNeeded() async {
    if (globalService.globalCid == null ||
        globalService.globalCid.toString().isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final savedCid = prefs.getString('company_id');
      if (savedCid != null && savedCid.isNotEmpty) {
        globalService.globalCid = int.parse(savedCid);
      }
    }
  }

  Future<void> fetchEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Save company_id to SharedPreferences if available
      if (globalService.globalCid != null &&
          globalService.globalCid.toString().isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('company_id', globalService.globalCid.toString());
      } else {
        setState(() {
          _errorMessage = 'Company ID is not set';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${baseURL}/employees/${globalService.globalCid}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          employees = responseData['employees'] ?? [];
          filteredEmployees = employees;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'No employees found for this company';
          employees = [];
          filteredEmployees = [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load employees: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void filterEmployees(String query) {
    setState(() {
      searchText = query;
      filteredEmployees = employees.where((employee) {
        return (employee['designation']?.toLowerCase() ?? '')
                .contains(query.toLowerCase()) ||
            (employee['email']?.toLowerCase() ?? '')
                .contains(query.toLowerCase()) ||
            (employee['name']?.toLowerCase() ?? '')
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  bool _isBase64(String str) {
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Regex.hasMatch(str) && (str.length % 4 == 0);
  }

  Future<Image> _decodeBase64Image(String base64String) async {
    try {
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      throw Exception('Failed to decode image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCompanyIdIfNeeded().then((_) => fetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'QUICK ROLL',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoalGray,
            ),
          ),
        ),
        backgroundColor: AppColors.skyBlue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            TextField(
              onChanged: filterEmployees,
              decoration: InputDecoration(
                labelText: 'Search by designation, email, or name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: fetchEmployees,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredEmployees.isEmpty
                          ? const Center(
                              child: Text(
                                'No employees found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.charcoalGray,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredEmployees.length,
                              itemBuilder: (context, index) {
                                final employee = filteredEmployees[index];
                                final photoPath = employee['photo_path'];

                                return Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01),
                                  color: AppColors.babyBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: photoPath != null &&
                                                  _isBase64(photoPath)
                                              ? FutureBuilder<Image>(
                                                  future: _decodeBase64Image(
                                                      photoPath),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return SizedBox(
                                                        height:
                                                            screenWidth * 0.25,
                                                        width:
                                                            screenWidth * 0.25,
                                                        child: const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      );
                                                    } else if (snapshot
                                                            .hasError ||
                                                        snapshot.data == null) {
                                                      return Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size:
                                                            screenWidth * 0.25,
                                                        color: AppColors
                                                            .charcoalGray,
                                                      );
                                                    }
                                                    return SizedBox(
                                                      height:
                                                          screenWidth * 0.25,
                                                      width: screenWidth * 0.25,
                                                      child: snapshot.data!,
                                                    );
                                                  },
                                                )
                                              : Image.network(
                                                  photoPath ?? '',
                                                  height: screenWidth * 0.25,
                                                  width: screenWidth * 0.25,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(
                                                    Icons.image_not_supported,
                                                    size: screenWidth * 0.25,
                                                    color:
                                                        AppColors.charcoalGray,
                                                  ),
                                                ),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                employee['name'] ?? 'Unknown',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.045,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.charcoalGray,
                                                ),
                                              ),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              Text(
                                                'Designation: ${employee['designation'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.charcoalGray),
                                              ),
                                              SizedBox(
                                                  height: screenHeight * 0.01),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        color: AppColors
                                                            .charcoalGray),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditEmployeePage(
                                                                    employee:
                                                                        employee)),
                                                      ).then((_) =>
                                                          fetchEmployees());
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: AppColors
                                                            .charcoalGray),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            DeleteEmployeePage(
                                                          employeeId:
                                                              employee['id'],
                                                          onDeleteSuccess:
                                                              fetchEmployees,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.charcoalGray,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeSignupFlow()),
          ).then((_) => fetchEmployees());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
