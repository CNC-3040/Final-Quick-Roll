import 'package:flutter/material.dart';
import 'package:quick_roll/utils/user_colors.dart';

//const String baseURL = "http://192.168.1.3:8000/api"; //mobile local host
//const String baseURL = "http://10.0.2.2:8000/api"; //emulator localhost
//const String baseURL = "http://127.0.0.1:8000/api";

// Define the base URL
const String baseURL =
    "https://qr.albsocial.in/api"; //server localhost

// Define the errorSnackBar method
void errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: AppColors.floatingButtonColor,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}
