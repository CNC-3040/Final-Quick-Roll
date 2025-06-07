import 'package:flutter/material.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class PasswordTextBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const PasswordTextBox({
    super.key,
    required this.controller,
    required this.onChanged, required InputDecoration decoration,
  });

  @override
  _PasswordTextBoxState createState() => _PasswordTextBoxState();
}

class _PasswordTextBoxState extends State<PasswordTextBox> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock,color: AppColors.slateTeal),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
           color: AppColors.charcoalGray,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.charcoalGray),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.charcoalGray),
                        ),
        labelStyle: const TextStyle(  color:AppColors.charcoalGray),
      ),
      style: const TextStyle(color: AppColors.charcoalGray), // Set text color here
  cursorColor: AppColors.charcoalGray, // Set curs
      onChanged: widget.onChanged,
      controller: widget.controller,
    );
  }
}