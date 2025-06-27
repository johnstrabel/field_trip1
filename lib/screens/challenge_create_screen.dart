// lib/screens/challenge_create_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeCreateScreen extends StatelessWidget {
  const ChallengeCreateScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Challenge'),
        backgroundColor: AppColors.sportAmber,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Create Challenge', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Challenge creation coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
