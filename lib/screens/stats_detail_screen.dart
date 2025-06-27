// lib/screens/stats_detail_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatsDetailScreen extends StatelessWidget {
  const StatsDetailScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Statistics'),
        backgroundColor: AppColors.card,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Advanced Analytics', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Detailed statistics coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}