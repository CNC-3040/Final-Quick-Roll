// int global_cid = 0;
// String global_userName = "";
// String global_emailId = "";
// String global_website = "";

// String global_contact = "";
// String global_gstn = "";
// String global_password = "";
// String global_category = "";
// String global_address = "";

// import 'package:shared_preferences/shared_preferences.dart';

// int global_cid = 0;
// String global_userName = "";
// String global_emailId = "";
// String global_website = "";

// String global_contact = "";
// String global_gstn = "";
// String global_password = "";
// String global_category = "";
// String global_address = "";
// double globalLatitude = 0.0;
// double globalLongitude = 0.0;
// bool global_IsWorking = false;
// String global_intimeDate = "";
// String global_intimeTime = "";

// // Save global_cid to SharedPreferences
// Future<void> saveGlobalCID(int cid) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setInt('global_cid', cid);
//   global_cid = cid;
// }

// // Load global_cid from SharedPreferences
// Future<void> loadGlobalCID() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   global_cid = prefs.getInt('global_cid') ?? 0;
// }

// // Remove global_cid on logout
// Future<void> clearGlobalCID() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('global_cid');
//   global_cid = 0;
// }

import 'package:shared_preferences/shared_preferences.dart';

// Global variables for app-wide state
int globalCid = 0;
String globalUserName = '';
String globalEmailId = '';
String globalWebsite = '';
String globalContact = '';
String globalGstn = '';
String globalPassword = '';
String globalCategory = '';
String globalAddress = '';
double globalLatitude = 0.0;
double globalLongitude = 0.0;
bool globalIsWorking = false;
String globalIntimeDate = '';
String globalIntimeTime = '';

/// Saves global company ID to SharedPreferences
Future<void> saveGlobalCID(int cid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('globalCid', cid);
  globalCid = cid;
}

/// Loads global company ID from SharedPreferences
Future<void> loadGlobalCID() async {
  final prefs = await SharedPreferences.getInstance();
  globalCid = prefs.getInt('globalCid') ?? 0;
}

/// Clears global company ID on logout
Future<void> clearGlobalCID() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('globalCid');
  globalCid = 0;
}

/// Saves global latitude and longitude to SharedPreferences
Future<void> saveGlobalLocation(double latitude, double longitude) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('globalLatitude', latitude);
  await prefs.setDouble('globalLongitude', longitude);
  globalLatitude = latitude;
  globalLongitude = longitude;
}

/// Loads global latitude and longitude from SharedPreferences
Future<void> loadGlobalLocation() async {
  final prefs = await SharedPreferences.getInstance();
  globalLatitude = prefs.getDouble('globalLatitude') ?? 0.0;
  globalLongitude = prefs.getDouble('globalLongitude') ?? 0.0;
}

/// Clears global latitude and longitude on logout
Future<void> clearGlobalLocation() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('globalLatitude');
  await prefs.remove('globalLongitude');
  globalLatitude = 0.0;
  globalLongitude = 0.0;
}
