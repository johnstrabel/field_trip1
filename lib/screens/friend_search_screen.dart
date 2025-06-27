// lib/screens/friend_search_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendSearchScreen extends StatelessWidget {
  const FriendSearchScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
        backgroundColor: AppColors.exploreBlue,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Find Friends', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Friend discovery coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}
