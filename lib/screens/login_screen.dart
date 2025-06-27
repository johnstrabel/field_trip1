// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('User Authentication', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Firebase Auth integration coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
