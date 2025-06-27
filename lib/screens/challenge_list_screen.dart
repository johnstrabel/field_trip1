// lib/screens/challenge_list_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        backgroundColor: AppColors.sportAmber,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Challenge System', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Community challenges coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
