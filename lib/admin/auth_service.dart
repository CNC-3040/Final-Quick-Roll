import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global.dart';
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
          responseBody['type'] == 'company') {
        final company = responseBody['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserId', company['id'].toString());
        await prefs.setString('loggedInUserEmail', company['email_id'] ?? '');
        await prefs.setString(
            'loggedInUserContact', company['user_name'] ?? '');
        await prefs.setString(
            'loggedInUserCompanyId', company['id'].toString());
        await prefs.setString('companyData', jsonEncode(responseBody));

        global_cid = company['id'];
        print('Company ID: $global_cid');
        print('User logged in successfully as company: $company');
        return responseBody;
      }
    }
    print(
        'Company login failed: ${response.statusCode}, Response: ${response.body}');
    return {'status': 'error', 'message': 'Invalid login credentials'};
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await prefs.remove('loggedInUserEmail');
    await prefs.remove('loggedInUserContact');
    await prefs.remove('loggedInUserCompanyId');
    await prefs.remove('companyData');
    await prefs.remove('loginType');
    await prefs.remove('role');
    global_cid = 0;
    print('Company logged out, SharedPreferences cleared');
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

  static Future<String?> getLoggedInUserCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserCompanyId');
  }
}
