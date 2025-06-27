// lib/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Password Reset', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Password recovery coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
