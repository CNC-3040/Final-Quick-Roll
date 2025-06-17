// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/services/global.dart';
// import 'package:quick_roll/services/global_API.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthService {
//   static Future<bool> isUserRegistered(
//       String identifier, String password) async {
//     final url = Uri.parse('$baseURL/login');
//
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"identifier": identifier, "password": password}),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       print('Response: $responseBody');
//
//       if (responseBody['status'] == 'success') {
//         final admin = responseBody['data'];
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('loggedInUserId', admin['id'].toString());
//         await prefs.setString('loggedInUserEmail', admin['email_id'] ?? '');
//         await prefs.setString('loggedInUserContact', admin['user_name'] ?? '');
//         await prefs.setString('companyData',
//             jsonEncode(responseBody)); // Save the entire response
//
//         // print('Logged-in User Email:$email_id')
//         global_cid = admin['id'];
//         print(global_cid);
//         print(admin['user_name']);
//
// // global_cid= admin['company_id'].toInt();
// //  global_cid = int.parse(responseData['data']['id'].toString());
//         print('company id= $global_cid');
//         print('Admin global_cid: $global_cid');
//         return true;
//       }
//     } else {
//       print('Login failed: ${response.statusCode}, Response: ${response.body}');
//     }
//     return false;
//   }
//
//   static Future<String?> getLoggedInUserEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserEmail');
//   }
//
//   static Future<String?> getLoggedInUserContact() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserContact');
//   }
//
//   static Future<String?> getLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserId');
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global.dart';
import 'package:quick_roll/services/global_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> isUserRegistered(
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

      if (responseBody['status'] == 'success') {
        final admin = responseBody['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserId', admin['id'].toString());
        await prefs.setString('loggedInUserEmail', admin['email_id'] ?? '');
        await prefs.setString('loggedInUserContact', admin['user_name'] ?? '');
        await prefs.setString('loggedInUserCompanyId',
            admin['id'].toString()); // Store company_id
        await prefs.setString(
            'companyData', jsonEncode(responseBody)); // Save entire response

        global_cid = admin['id'];
        print('company id= $global_cid');
        print('Admin global_cid: $global_cid');
        print('User logged in successfully: $admin');
        return true;
      }
    } else {
      print('Login failed: ${response.statusCode}, Response: ${response.body}');
    }
    return false;
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
