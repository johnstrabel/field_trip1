// lib/screens/notification_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.card,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Notification Center', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Push notifications coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}