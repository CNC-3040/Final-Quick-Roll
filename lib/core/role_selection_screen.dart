import 'package:flutter/material.dart';
import 'package:quick_roll/admin/admin_login.dart';
import 'package:quick_roll/user/user_login_screen.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skyBlue, // Set background color to skyBlue
      appBar: AppBar(
        title: const Text(
          'Select Role',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make "Select Role" bold
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.lightSkyBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your Role',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleContainer(
                  context,
                  title: 'Company ',
                  icon: Icons.business,
                  color: AppColors.charcoalGray, // Charcoal Gray
                  bgColor: AppColors.babyBlue, // Baby Blue Background
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildRoleContainer(
                  context,
                  title: 'User',
                  icon: Icons.person,
                  color: AppColors.charcoalGray, // Charcoal Gray
                  bgColor: AppColors.babyBlue, // Baby Blue Background
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Userlogin()), // Navigate to UserLoginScreen
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleContainer(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Color bgColor,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: bgColor, // Baby Blue Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2), // Charcoal Gray Border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color), // Charcoal Gray Icon
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color, // Charcoal Gray Text
              ),
            ),
          ],
        ),
      ),
    );
  }
}