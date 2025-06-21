import 'package:flutter/material.dart';
import 'package:quick_roll/utils/admin_colors.dart';

class NavigationArrow extends StatelessWidget {
  final bool isForward;

  const NavigationArrow({super.key, required this.isForward});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.myTeal,
      radius: 40,
      child: Icon(
        isForward ? Icons.arrow_forward : Icons.arrow_back,
        color: AppColors.white,
        size: 50,
      ),
    );
  }
}
