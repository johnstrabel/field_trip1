// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.card,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('App Settings', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Preferences and configuration coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}