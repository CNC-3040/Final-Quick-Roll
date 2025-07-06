import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<Map<String, dynamic>> isUserRegistered(
      String identifier, String password) async {
    final url = Uri.parse('$baseURL/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": identifier, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print('Response: $responseBody');

      if (responseBody['status'] == 'success' &&
          responseBody['type'] == 'employee') {
        final employee = responseBody['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserId', employee['id'].toString());
        await prefs.setString('loggedInUserEmail', employee['email'] ?? '');
        await prefs.setString('loggedInUserContact', employee['contact'] ?? '');
        await prefs.setString('loggedInUserName', employee['name'] ?? '');
        await prefs.setString(
            'loggedInUserSalary', employee['salary']?.toString() ?? '0.0');
        await prefs.setString(
            'loggedInUserCompanyId', employee['company_id'].toString());
        await prefs.setString(
            'loggedInUserCompanyName', employee['company_name'] ?? '');
        await prefs.setString(
            'loggedInUserWorkPlace', employee['work_place'] ?? '');
        await prefs.setString(
            'loggedInUserWorkingHours', employee['working_hours'] ?? '');

        print('User ID: ${employee['id']}');
        print('Email: ${employee['email']}');
        print('Contact: ${employee['contact']}');
        print('Name: ${employee['name']}');
        print('Salary: ${employee['salary']}');
        print('Company ID: ${employee['company_id']}');
        print('Company Name: ${employee['company_name']}');
        print('Work Place: ${employee['work_place']}');
        print('Working Hours: ${employee['working_hours']}');

        return responseBody;
      }
    }
    print(
        'Employee login failed: ${response.statusCode}, Response: ${response.body}');
    return {'status': 'error', 'message': 'Invalid login credentials'};
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await prefs.remove('loggedInUserEmail');
    await prefs.remove('loggedInUserContact');
    await prefs.remove('loggedInUserName');
    await prefs.remove('loggedInUserSalary');
    await prefs.remove('loggedInUserCompanyId');
    await prefs.remove('loggedInUserCompanyName');
    await prefs.remove('loggedInUserWorkPlace');
    await prefs.remove('loggedInUserWorkingHours');
    await prefs.remove('loginType');
    await prefs.remove('role');
    print('Employee logged out, SharedPreferences cleared');
  }

  static Future<String?> getLoggedInUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserEmail');
  }

  static Future<String?> getLoggedInUserContact() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserContact');
  }

  static Future<String?> getLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserId');
  }

  static Future<String?> getLoggedInCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserCompanyId');
  }

  static Future<String?> getLoggedInUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserName');
  }

  static Future<String?> getLoggedInUserSalary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserSalary');
  }

  static Future<String?> getLoggedInUserCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserCompanyName');
  }

  static Future<String?> getLoggedInUserWorkPlace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserWorkPlace');
  }

  static Future<String?> getLoggedInUserWorkingHours() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserWorkingHours');
  }
}
