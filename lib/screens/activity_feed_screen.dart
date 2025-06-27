// lib/screens/activity_feed_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        backgroundColor: AppColors.exploreBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dynamic_feed, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Social Activity', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Activity stream coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
