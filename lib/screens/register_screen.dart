// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Account Registration', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('User registration coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}