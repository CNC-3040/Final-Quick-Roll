import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:quick_roll/user/user_auth_service.dart';
import 'package:quick_roll/utils/user_colors.dart';

class UserIdCard extends StatelessWidget {
  const UserIdCard({super.key});

  // Existing method to fetch employees
  Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$baseURL/employees'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // Check if string is a valid base64
  bool _isBase64(String str) {
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Regex.hasMatch(str) && (str.length % 4 == 0);
  }

  // Decode base64 image string
  Future<Image> _decodeBase64Image(String base64String) async {
    try {
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      throw Exception('Failed to decode image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softSlateBlue,
        title: const Text(
          'Employee ID Cards',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.deepSkyBlue,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found'));
          }

          final employees = snapshot.data!;
          return FutureBuilder<String?>(
            future: AuthService.getLoggedInUserContact(),
            builder: (context, contactSnapshot) {
              if (contactSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (contactSnapshot.hasError || !contactSnapshot.hasData) {
                return const Center(child: Text('Error fetching user contact'));
              }

              final userContact = contactSnapshot.data;
              final userEmployee = employees.firstWhere(
                (employee) =>
                    employee['contact'] == userContact ||
                    employee['alternate_contact'] == userContact,
                orElse: () => {},
              );

              if (userEmployee.isEmpty) {
                return const Center(
                    child: Text('No ID card found for the logged-in user'));
              }

              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  final employee = userEmployee;
                  final photoPath = employee['photo_path'];

                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Center(
                      child: Container(
                        width: screenWidth > 600
                            ? screenWidth * 0.5
                            : screenWidth * 0.8,
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          // Remove the border property
                          // border: Border.all(color: AppColors.charcoalGray, width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400, blurRadius: 10),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color (optional)
                            borderRadius: BorderRadius.circular(
                                16), // Rounded corners for the border
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: screenHeight * 0.1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.softSlateBlue,
                                      AppColors.softSlateBlue
                                    ],
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/compony_logo.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: photoPath != null && _isBase64(photoPath)
                                    ? FutureBuilder<Image>(
                                        future: _decodeBase64Image(photoPath),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError ||
                                              snapshot.data == null) {
                                            return Icon(
                                              Icons.person,
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
                                      )
                                    : Image.network(
                                        photoPath ?? '',
                                        height: screenWidth * 0.25,
                                        width: screenWidth * 0.25,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                          Icons.image_not_supported,
                                          size: screenWidth * 0.25,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                employee['name'] ?? 'No Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepSkyBlue,
                                ),
                              ),
                              Text(
                                employee['designation'] ?? '',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey,
                                ),
                              ),
                              const Divider(color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InfoRow(
                                        label: 'ID:',
                                        value: employee['id'].toString(),
                                        color: AppColors.darkNavyBlue),
                                    InfoRow(
                                        label: 'EMAIL:',
                                        value: employee['email'] ?? '',
                                        color: AppColors.darkNavyBlue),
                                    InfoRow(
                                        label: 'PHONE:',
                                        value: employee['contact'] ?? '',
                                        color: AppColors.darkNavyBlue),
                                    InfoRow(
                                        label: 'ALTERNATE PHONE:',
                                        value: employee['alternate_contact'] ??
                                            'N/A',
                                        color: AppColors.darkNavyBlue),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const InfoRow(
      {required this.label,
      required this.value,
      required this.color,
      super.key});

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
