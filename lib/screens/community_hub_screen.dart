// lib/screens/community_hub_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Hub'),
        backgroundColor: AppColors.exploreBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.public, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Discover Popular Trips', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Community features coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}