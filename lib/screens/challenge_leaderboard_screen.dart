// lib/screens/challenge_leaderboard_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeLeaderboardScreen extends StatelessWidget {
  final String challengeId;
  
  const ChallengeLeaderboardScreen({Key? key, required this.challengeId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Rankings'),
        backgroundColor: AppColors.sportAmber,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Challenge Leaderboard', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Challenge rankings coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
