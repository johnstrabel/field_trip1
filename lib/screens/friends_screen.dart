// lib/screens/friends_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: AppColors.exploreBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: Navigate to friend search
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Friend Management', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Social features coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}