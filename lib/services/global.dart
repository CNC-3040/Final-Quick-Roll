// int global_cid = 0;
// String global_userName = "";
// String global_emailId = "";
// String global_website = "";

// String global_contact = "";
// String global_gstn = "";
// String global_password = "";
// String global_category = "";
// String global_address = "";

import 'package:shared_preferences/shared_preferences.dart';

int global_cid = 0;
String global_userName = "";
String global_emailId = "";
String global_website = "";

String global_contact = "";
String global_gstn = "";
String global_password = "";
String global_category = "";
String global_address = "";
double globalLatitude = 0.0;
double globalLongitude = 0.0;
bool global_IsWorking = false;
String global_intimeDate = "";
String global_intimeTime = "";

// Save global_cid to SharedPreferences
Future<void> saveGlobalCID(int cid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('global_cid', cid);
  global_cid = cid;
}

// Load global_cid from SharedPreferences
Future<void> loadGlobalCID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  global_cid = prefs.getInt('global_cid') ?? 0;
}

// Remove global_cid on logout
Future<void> clearGlobalCID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('global_cid');
  global_cid = 0;
}
