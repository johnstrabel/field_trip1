// lib/screens/help_feedback_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        backgroundColor: AppColors.card,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Help & Support', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Support center and feedback coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
