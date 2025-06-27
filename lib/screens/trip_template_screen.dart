// lib/screens/trip_template_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TripTemplateScreen extends StatelessWidget {
  const TripTemplateScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Templates'),
        backgroundColor: AppColors.card,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route, size: 64, color: AppColors.textSecond),
            SizedBox(height: 16),
            Text('Pre-built Routes', style: AppTextStyles.sectionTitle),
            SizedBox(height: 8),
            Text('Trip templates coming soon...', style: AppTextStyles.cardSubtitle),
          ],
        ),
      ),
    );
  }
}