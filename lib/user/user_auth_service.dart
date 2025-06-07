// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:quick_roll/services/global_API.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static Future<bool> isUserRegistered(
//       String identifier, String password) async {
//     final url = Uri.parse('$baseURL/user_login');

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"identifier": identifier, "password": password}),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseBody = json.decode(response.body);
//       print('Response: $responseBody');

//       if (responseBody['status'] == 'success') {
//         final employee = responseBody['data'];

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('loggedInUserId', employee['id'].toString());
//         await prefs.setString('loggedInUserEmail', employee['email'] ?? '');
//         await prefs.setString('loggedInUserContact', employee['contact'] ?? '');
//         // await prefs.setString(
//         //     'loggedInUserCompanyId', employee['company_id'].toString()); // Save company_id

//         if (employee.containsKey('company_id')) {
//           await prefs.setString(
//               'loggedInUserCompanyId', employee['company_id'].toString());
//         } else {
//           print('Company ID not found in response');
//         }

//         print(employee['id']);
//         print(employee['email']);
//         print(employee['contact']);
//         print(employee['company_ id']); // Print company_id

//         print('User logged in successfully: $employee');
//         return true;
//       }
//     } else {
//       print('Login failed: ${response.statusCode}, Response: ${response.body}');
//     }
//     return false;
//   }

//   static Future<String?> getLoggedInUserEmail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserEmail');
//   }

//   static Future<String?> getLoggedInUserContact() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserContact');
//   }

//   static Future<String?> getLoggedInUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInUserId');
//   }

//   static Future<String?> getLoggedInCompanyId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('loggedInCompanyId');
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_roll/services/global_API.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> isUserRegistered(
      String identifier, String password) async {
    final url = Uri.parse('$baseURL/user_login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": identifier, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      print('Response: $responseBody');

      if (responseBody['status'] == 'success') {
        final employee = responseBody['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserId', employee['id'].toString());
        await prefs.setString('loggedInUserEmail', employee['email'] ?? '');
        await prefs.setString('loggedInUserContact', employee['contact'] ?? '');
        await prefs.setString(
            'loggedInUserName', employee['name'] ?? ''); // Save name
        await prefs.setString(
            'loggedInUserSalary', employee['salary'].toString()); // Save salary

        if (employee.containsKey('company_id')) {
          await prefs.setString(
              'loggedInUserCompanyId', employee['company_id'].toString());
        } else {
          print('Company ID not found in response');
        }

        print('User ID: ${employee['id']}');
        print('Email: ${employee['email']}');
        print('Contact: ${employee['contact']}');
        print('Name: ${employee['name']}');
        print('Salary: ${employee['salary']}');
        print('Company ID: ${employee['company_id']}');

        print('User logged in successfully: $employee');
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
}
